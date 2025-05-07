const pool = require("../db");

// 세션 생성 (카테고리 기반)
exports.createSessionByCategory = async (req, res) => {
  const categoryId = Number(req.body.categoryId);
  const userId = Number(req.body.userId);

  if (isNaN(categoryId) || isNaN(userId)) {
    return res
      .status(400)
      .json({ error: "categoryId와 userId는 숫자여야 합니다." });
  }

  try {
    const newQuizQuery = `
      SELECT question_id
      FROM questions
      WHERE category_id = $1
        AND question_id NOT IN (
          SELECT question_id FROM user_question_log WHERE user_id = $2
        )
      ORDER BY RANDOM()
      LIMIT 5;
    `;
    const newQuizResult = await pool.query(newQuizQuery, [categoryId, userId]);
    let quizIds = newQuizResult.rows.map((row) => row.question_id);

    if (quizIds.length < 5) {
      const remainingCount = 5 - quizIds.length;
      const reviewQuery = `
        SELECT question_id
        FROM questions
        WHERE category_id = $1
          AND question_id IN (
            SELECT question_id
            FROM user_question_log
            WHERE user_id = $2
              AND answered_at < NOW() - INTERVAL '7 days'
          )
          AND question_id NOT IN (${quizIds
            .map((_, i) => `$${i + 3}`)
            .join(", ")})
        ORDER BY RANDOM()
        LIMIT $${quizIds.length + 3};
      `;

      const params = [categoryId, userId, ...quizIds, remainingCount];
      const reviewResult = await pool.query(reviewQuery, params);
      const reviewIds = reviewResult.rows.map((row) => row.question_id);
      quizIds = quizIds.concat(reviewIds);
    }

    if (quizIds.length === 0) {
      return res.status(404).json({ message: "출제할 퀴즈가 없습니다." });
    }

    const insertSession = `
      INSERT INTO quiz_sessions (quiz_ids, user_id)
      VALUES ($1, $2)
      RETURNING session_id;
    `;
    const sessionResult = await pool.query(insertSession, [quizIds, userId]);
    const sessionId = sessionResult.rows[0].session_id;

    res.status(201).json({ sessionId, quizIds });
  } catch (err) {
    console.error("세션 생성 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
// 세션 결과 제출 (채점 + 기록)
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
        `SELECT answer, explanation FROM questions WHERE question_id = $1`,
        [questionId]
      );

      if (questionRes.rows.length === 0) continue;

      const correctAnswer = questionRes.rows[0].answer;
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

    res
      .status(200)
      .json({ score: correctCount, total: answers.length, results });
  } catch (err) {
    console.error("세션 완료 실패:", err);
    res.status(500).json({ error: err.message });
  }

  const xpEarned = correctCount * 10;

  await pool.query(
    `
    UPDATE users
    SET xp = xp + $1
    WHERE user_id = $2;
  `,
    [xpEarned, userId]
  );
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
