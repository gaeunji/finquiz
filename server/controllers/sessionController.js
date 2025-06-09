const pool = require("../db");
const achievementController = require("./achievementController");

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
    const quiz_ids = sessionRes.rows[0].quiz_ids;

    const results = [];
    let correctCount = 0;
    let categoryQuizCounts = {};

    for (const ans of answers) {
      const { questionId, selectedAnswer } = ans;

      const questionRes = await pool.query(
        `SELECT question_text, correct_answer, explanation, category_id 
         FROM questions WHERE question_id = $1`,
        [questionId]
      );

      if (questionRes.rows.length === 0) continue;

      const questionText = questionRes.rows[0].question_text;
      const correctAnswer = questionRes.rows[0].correct_answer;
      const explanation = questionRes.rows[0].explanation;
      const categoryId = questionRes.rows[0].category_id;
      const isCorrect = selectedAnswer === correctAnswer;

      if (isCorrect) correctCount++;

      // 카테고리별 퀴즈 카운트 업데이트
      categoryQuizCounts[categoryId] =
        (categoryQuizCounts[categoryId] || 0) + 1;

      await pool.query(
        `INSERT INTO user_answers (user_id, question_id, selected_answer, is_correct)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (user_id, question_id) DO UPDATE 
         SET selected_answer = EXCLUDED.selected_answer,
         is_correct = EXCLUDED.is_correct`,
        [userId, questionId, selectedAnswer, isCorrect]
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
      `UPDATE quiz_sessions SET is_completed = true WHERE session_id = $1`,
      [sessionId]
    );

    // XP 업데이트 - 재시도 여부 확인
    const isRetrySession = await pool.query(
      `SELECT COUNT(*) FROM quiz_sessions 
       WHERE user_id = $1 
       AND quiz_ids = $2 
       AND session_id != $3 
       AND is_completed = true`,
      [userId, quiz_ids, sessionId]
    );

    // 재시도인 경우 5xp, 처음 푸는 경우 10xp
    const xpPerQuestion = isRetrySession.rows[0].count > 0 ? 5 : 10;
    const xpEarned = correctCount * xpPerQuestion;

    await pool.query(`UPDATE users SET xp = xp + $1 WHERE user_id = $2;`, [
      xpEarned,
      userId,
    ]);
    await pool.query(`INSERT INTO user_xp_log (user_id, xp) VALUES ($1, $2)`, [
      userId,
      xpEarned,
    ]);

    // 사용자 데이터 조회
    const userDataRes = await pool.query(
      `SELECT 
        (SELECT COUNT(*) FROM user_question_log WHERE user_id = $1) as total_quiz_count,
        (SELECT COUNT(*) FROM user_answers WHERE user_id = $1 AND is_correct = true) as perfect_scores,
        (SELECT xp FROM users WHERE user_id = $1) as xp_amount,
        (SELECT COUNT(*) FROM bookmarked_questions WHERE user_id = $1) as bookmark_count,
        (SELECT COUNT(*) FROM (
          SELECT date_trunc('day', answered_at) as day
          FROM user_question_log
          WHERE user_id = $1
          GROUP BY day
          ORDER BY day DESC
          LIMIT 1
        ) as consecutive_days) as consecutive_days`,
      [userId]
    );

    const userData = {
      ...userDataRes.rows[0],
      categoryQuizCounts,
    };

    // 업적 업데이트
    try {
      const achievementResult =
        await achievementController.updateAllUserAchievements({
          body: { userId, userData },
        });

      // 응답 반환
      res.status(200).json({
        score: correctCount,
        total: answers.length,
        results,
        xpEarned,
        achievements: achievementResult.achievements,
      });
    } catch (error) {
      console.error("업적 업데이트 실패:", error);
      // 업적 업데이트 실패해도 세션 완료는 성공으로 처리
      res.status(200).json({
        score: correctCount,
        total: answers.length,
        results,
        xpEarned,
        achievementError: "업적 업데이트에 실패했습니다.",
      });
    }
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

// 세션 재시도
exports.retrySession = async (req, res) => {
  const sessionId = req.params.sessionId;

  try {
    // 기존 세션 정보 조회
    const sessionRes = await pool.query(
      `SELECT quiz_ids, user_id FROM quiz_sessions WHERE session_id = $1`,
      [sessionId]
    );

    if (sessionRes.rows.length === 0) {
      return res.status(404).json({ error: "세션을 찾을 수 없습니다." });
    }

    const { quiz_ids, user_id } = sessionRes.rows[0];

    // quiz_ids가 문자열 배열인 경우 정수 배열로 변환
    const quizIdsArray = Array.isArray(quiz_ids)
      ? quiz_ids.map((id) => Number(id))
      : JSON.parse(quiz_ids).map((id) => Number(id));

    // 새로운 세션 생성
    const insertSession = `
      INSERT INTO quiz_sessions (quiz_ids, user_id)
      VALUES ($1, $2)
      RETURNING session_id;
    `;
    const newSessionResult = await pool.query(insertSession, [
      quizIdsArray,
      user_id,
    ]);
    const newSessionId = newSessionResult.rows[0].session_id;

    // 응답 반환
    res.status(201).json({
      sessionId: newSessionId,
      quizIds: quizIdsArray,
    });
  } catch (err) {
    console.error("세션 재시도 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 틀린 퀴즈 복습 세션 생성
exports.createReviewSessionFromWrong = async (req, res) => {
  const { userId, count = 5 } = req.body;

  if (!userId) {
    return res.status(400).json({ error: "userId는 필수입니다." });
  }

  try {
    // 1. 틀린 문제 ID 조회
    const wrongQuery = `
      SELECT DISTINCT question_id, answered_at
      FROM user_answers
      WHERE user_id = $1 AND is_correct = false
      ORDER BY answered_at DESC
      LIMIT $2;
    `;
    const wrongResult = await pool.query(wrongQuery, [userId, count]);
    let wrongQuestionIds = wrongResult.rows.map((row) => row.question_id);

    if (wrongQuestionIds.length === 0) {
      return res.status(404).json({ error: "틀린 퀴즈가 존재하지 않습니다." });
    }

    // 2. 랜덤 추출
    wrongQuestionIds = wrongQuestionIds
      .sort(() => Math.random() - 0.5)
      .slice(0, count);

    // 3. 세션 생성
    const insertSession = `
      INSERT INTO quiz_sessions (quiz_ids, user_id)
      VALUES ($1, $2)
      RETURNING session_id;
    `;
    const sessionRes = await pool.query(insertSession, [
      wrongQuestionIds,
      userId,
    ]);
    const sessionId = sessionRes.rows[0].session_id;

    // 4. 응답
    res.status(201).json({
      sessionId,
      quizIds: wrongQuestionIds,
      actualCount: wrongQuestionIds.length,
    });
  } catch (err) {
    console.error("복습 세션 생성 실패:", err);
    res.status(500).json({ error: "서버 오류" });
  }
};
