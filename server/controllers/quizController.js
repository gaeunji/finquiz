const pool = require("../db");

exports.getDailyQuiz = async (req, res) => {
  try {
    const query = `
      SELECT question_id, category_id, question_text, options
      FROM questions
      ORDER BY RANDOM()
      LIMIT 1;
    `;
    const result = await pool.query(query);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "퀴즈가 없습니다." });
    }

    const quiz = result.rows[0];
    quiz.id = quiz.question_id;
    quiz.question = quiz.question_text;

    delete quiz.question_id;
    delete quiz.question_text;

    quiz.options =
      typeof quiz.options === "string"
        ? JSON.parse(quiz.options)
        : quiz.options;

    res.json(quiz);
  } catch (err) {
    console.error("getDailyQuiz error:", err);
    res.status(500).json({ error: err.message });
  }
};

// ✅ 단일 퀴즈 조회
exports.getQuizById = async (req, res) => {
  const quizId = req.params.quizId;

  try {
    const query = `
      SELECT question_id, category_id, question_text, options
      FROM questions
      WHERE question_id = $1
      LIMIT 1;
    `;
    const result = await pool.query(query, [quizId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "해당 퀴즈를 찾을 수 없습니다." });
    }

    const quiz = result.rows[0];
    quiz.id = quiz.question_id;
    quiz.question = quiz.question_text;

    delete quiz.question_id;
    delete quiz.question_text;

    quiz.options =
      typeof quiz.options === "string"
        ? JSON.parse(quiz.options)
        : quiz.options;

    res.json(quiz);
  } catch (err) {
    console.error("퀴즈 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 퀴즈 제출
exports.submitAnswer = async (req, res) => {
  const quizId = req.params.quizId;
  const userAnswer = req.body.answer;

  if (!userAnswer) {
    return res.status(400).json({ error: "사용자 응답이 필요합니다." });
  }

  try {
    const query = `
      SELECT answer, explanation
      FROM questions
      WHERE question_id = $1
      LIMIT 1;
    `;
    const result = await pool.query(query, [quizId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "해당 퀴즈를 찾을 수 없습니다." });
    }

    const quiz = result.rows[0];
    const isCorrect = quiz.answer === userAnswer;

    res.json({
      correct: isCorrect,
      explanation: quiz.explanation,
    });
  } catch (err) {
    console.error("정답 제출 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 트렌딩 퀴즈
exports.getTrendingQuizzes = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT question_id, category_id, question_text, options
      FROM questions
      WHERE is_trending = true
      ORDER BY RANDOM()
      LIMIT 10;
    `);

    const quizzes = result.rows.map((q) => ({
      id: q.question_id,
      category_id: q.category_id,
      question: q.question_text,
      options:
        typeof q.options === "string" ? JSON.parse(q.options) : q.options,
    }));

    res.json(quizzes);
  } catch (err) {
    console.error("트렌딩 퀴즈 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 모든 퀴즈 정보 한 번에 가져오기
exports.getQuestionsByIds = async (req, res) => {
  const { questionIds } = req.body;

  if (!Array.isArray(questionIds) || questionIds.length === 0) {
    return res.status(400).json({ error: "questionIds 배열이 필요합니다." });
  }

  try {
    // 동적 파라미터 생성: $1, $2, ...
    const placeholders = questionIds.map((_, i) => `$${i + 1}`).join(", ");
    const query = `
      SELECT question_id, question_text, options
      FROM questions
      WHERE question_id IN (${placeholders});
    `;

    const result = await pool.query(query, questionIds);

    res.status(200).json({ questions: result.rows });
  } catch (err) {
    console.error("퀴즈 정보 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
