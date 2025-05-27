const pool = require("../db");

const categoryMap = {
  macro: 1,
  intl: 2,
  finance: 3,
  basic: 4,
  micro: 5,
  current: 6,
  behav: 7,
};

// 세션 생성 (카테고리 기반)
exports.createSession = async (req, res) => {
  console.log("📥 [세션 생성 요청] 클라이언트 요청 데이터:", req.body);
  // 1. 입력 유효성 검사
  if (!req.body.categoryId || !req.body.userId) {
    return res.status(400).json({ error: "categoryId와 userId는 필수입니다." });
  }

  const categoryId = Number(req.body.categoryId);
  const userId = Number(req.body.userId);
  const count = Number(req.body.count) || 5; //   기본값 5개, 1개도 가능

  // 특정 퀴즈 ID들이 제공된 경우
  const specificQuizIds = req.body.quizIds;

  if (isNaN(userId)) {
    return res.status(400).json({ error: "userId는 숫자여야 합니다." });
  }

  try {
    let quizIds = [];

    // 특정 퀴즈 ID들이 제공된 경우 (일일 퀴즈 등)
    if (specificQuizIds && Array.isArray(specificQuizIds)) {
      quizIds = specificQuizIds.map((id) => Number(id));
      console.log("📌 특정 퀴즈 ID로 세션 생성:", quizIds);
    }
    // 카테고리별 랜덤 퀴즈 (기존 로직)
    else if (req.body.categoryId) {
      const categoryId = Number(req.body.categoryId);

      if (isNaN(categoryId)) {
        return res.status(400).json({ error: "categoryId는 숫자여야 합니다." });
      }

      // 기존 랜덤 퀴즈 선택 로직...
      const newQuizQuery = `
        SELECT question_id
        FROM questions
        WHERE category_id = $1
          AND question_id NOT IN (
            SELECT question_id FROM user_question_log WHERE user_id = $2
          )
        ORDER BY RANDOM()
        LIMIT $3;
      `;
      const newQuizResult = await pool.query(newQuizQuery, [
        categoryId,
        userId,
        count,
      ]);
      quizIds = newQuizResult.rows.map((row) => row.question_id);

      // 부족할 경우 보완 로직...
      if (quizIds.length < count) {
        const remainingCount = count - quizIds.length;
        const fallbackQuery = `
          SELECT question_id
          FROM questions
          WHERE category_id = $1
          ORDER BY RANDOM()
          LIMIT $2;
        `;
        const fallbackResult = await pool.query(fallbackQuery, [
          categoryId,
          remainingCount,
        ]);
        const fallbackIds = fallbackResult.rows.map((row) => row.question_id);
        quizIds = quizIds.concat(fallbackIds);
      }
    } else {
      return res.status(400).json({
        error: "categoryId 또는 quizIds 중 하나는 필수입니다.",
      });
    }
    // 배열이 비어있으면 예외 처리
    if (quizIds.length === 0) {
      return res
        .status(404)
        .json({ error: "해당 카테고리에 출제할 퀴즈가 없습니다." });
    }

    // 중복 제거
    quizIds = [...new Set(quizIds)];
    // 요청된 개수보다 적으면 예외 처리

    // 세션 저장
    const insertSession = `
      INSERT INTO quiz_sessions (quiz_ids, user_id)
      VALUES ($1, $2)
      RETURNING session_id;
    `;
    const sessionResult = await pool.query(insertSession, [quizIds, userId]);
    const sessionId = sessionResult.rows[0].session_id;

    console.log("📤 [세션 생성 응답] sessionId:", sessionId);
    console.log("📤 [세션 생성 응답] quizIds:", quizIds);

    res.status(201).json({
      sessionId,
      quizIds,
      actualCount: quizIds.length,
    });
  } catch (err) {
    console.error("세션 생성 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

exports.createSessionByCategory = exports.createSession;

// 세션 완료 (사용자가 푼 문제 제출)
exports.completeSession = async (req, res) => {
  const sessionId = req.params.sessionId;
  const { answers } = req.body;

  if (!answers || !Array.isArray(answers)) {
    return res.status(400).json({ error: "answers 배열이 필요합니다." });
  }

  try {
    const sessionRes = await pool.query(
      `SELECT quiz_ids, user_id FROM quiz_sessions WHERE session_id = $1`,
      [sessionId]
    );

    if (sessionRes.rows.length === 0) {
      return res.status(404).json({ error: "세션을 찾을 수 없습니다." });
    }

    const userId = sessionRes.rows[0].user_id;

    const results = [];
    let correctCount = 0;

    for (const ans of answers) {
      const { questionId, selectedAnswer } = ans;

      const questionRes = await pool.query(
        `SELECT question_text, correct_answer, explanation FROM questions WHERE question_id = $1`,
        [questionId]
      );

      if (questionRes.rows.length === 0) continue;

      const questionText = questionRes.rows[0].question_text;
      const correctAnswer = questionRes.rows[0].correct_answer;
      const explanation = questionRes.rows[0].explanation;
      const isCorrect = selectedAnswer === correctAnswer;

      if (isCorrect) correctCount++;

      await pool.query(
        `INSERT INTO user_answers (session_id, question_id, selected_answer, is_correct)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (session_id, question_id) DO UPDATE 
         SET selected_answer = EXCLUDED.selected_answer,
             is_correct = EXCLUDED.is_correct`,
        [sessionId, questionId, selectedAnswer, isCorrect]
      );

      await pool.query(
        `INSERT INTO user_question_log (user_id, question_id)
         VALUES ($1, $2)
         ON CONFLICT (user_id, question_id)
         DO UPDATE SET answered_at = NOW();`,
        [userId, questionId]
      );

      results.push({
        questionId,
        questionText,
        selectedAnswer,
        correctAnswer,
        explanation,
        correct: isCorrect,
      });
    }

    await pool.query(
      `UPDATE quiz_sessions SET completed = true WHERE session_id = $1`,
      [sessionId]
    );

    // XP 업데이트
    const xpEarned = correctCount * 10;
    await pool.query(`UPDATE users SET xp = xp + $1 WHERE user_id = $2;`, [
      xpEarned,
      userId,
    ]);

    // 응답 반환
    res.status(200).json({
      score: correctCount,
      total: answers.length,
      results,
    });
  } catch (err) {
    console.error("세션 완료 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 사용자가 문제를 푼 로그 기록 (복습용)
exports.submitQuizResult = async (req, res) => {
  const { userId, questionIds } = req.body;

  if (!userId || !Array.isArray(questionIds)) {
    return res
      .status(400)
      .json({ error: "userId와 questionIds 배열이 필요합니다." });
  }

  try {
    for (const qid of questionIds) {
      await pool.query(
        `INSERT INTO user_question_log (user_id, question_id) VALUES ($1, $2)
         ON CONFLICT (user_id, question_id) DO UPDATE SET answered_at = NOW();`,
        [userId, qid]
      );
    }

    res.status(200).json({ message: "기록 완료" });
  } catch (err) {
    console.error("기록 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
