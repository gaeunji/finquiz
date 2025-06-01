const pool = require("../db");

exports.getDailyQuiz = async (req, res) => {
  try {
    // 오늘 날짜를 무자열로
    const today = new Date().toISOString().split("T")[0];
    const userId = req.query.userId;

    // 오늘 날짜에 대한 퀴즈가 이미 정해졌는지 확인
    const check = await pool.query(
      `SELECT q.question_id, q.category_id, q.question_text, q.options
       FROM daily_quiz d
       JOIN questions q ON d.question_id = q.question_id
       WHERE d.date = $1`,
      [today]
    );

    if (check.rows.length > 0) {
      const quiz = check.rows[0];
      quiz.id = quiz.question_id;
      quiz.question = quiz.question_text;
      delete quiz.question_id;
      delete quiz.question_text;
      quiz.options =
        typeof quiz.options === "string"
          ? JSON.parse(quiz.options)
          : quiz.options;

      // 사용자별 완료 상태 확인
      if (userId) {
        const completionCheck = await pool.query(
          `SELECT * FROM user_question_log 
           WHERE user_id = $1 AND question_id = $2`,
          [Number(userId), quiz.id]
        );
        quiz.is_completed = completionCheck.rows.length > 0;
      } else {
        quiz.is_completed = false;
      }

      return res.json(quiz);
    }

    // 없으면 새로운 퀴즈를 1개 랜덤으로 선택
    const newQuizResult = await pool.query(`
      SELECT question_id
      FROM questions
      ORDER BY RANDOM()
      LIMIT 1
    `);
    if (newQuizResult.rows.length === 0) {
      return res.status(404).json({ message: "퀴즈가 없습니다." });
    }

    const selectedId = newQuizResult.rows[0].question_id;

    // 해당 퀴즈를 오늘의 퀴즈로 설정한 쿼리
    await pool.query(
      `INSERT INTO daily_quiz (date, question_id) VALUES ($1, $2)`,
      [today, selectedId]
    );

    // 다시 조회해서 반환
    const final = await pool.query(
      `SELECT q.question_id, q.category_id, q.question_text, q.options
       FROM questions q
       WHERE q.question_id = $1`,
      [selectedId]
    );

    const quiz = final.rows[0];
    quiz.id = quiz.question_id;
    quiz.question = quiz.question_text;
    delete quiz.question_id;
    delete quiz.question_text;
    quiz.options =
      typeof quiz.options === "string"
        ? JSON.parse(quiz.options)
        : quiz.options;

    // 새 퀴즈는 항상 미완료 상태여야 함
    quiz.is_completed = false;

    res.json(quiz);
  } catch (err) {
    console.error("getDailyQuiz error:", err);
    res.status(500).json({ error: err.message });
  }
};

// 퀴즈 포맷팅 함수
const formatQuiz = (quiz) => {
  if (!quiz) return null;

  const formattedQuiz = {
    id: quiz.question_id,
    category_id: quiz.category_id,
    question: quiz.question_text,
    options:
      typeof quiz.options === "string"
        ? JSON.parse(quiz.options)
        : quiz.options,
  };

  delete formattedQuiz.question_id;
  delete formattedQuiz.question_text;

  return formattedQuiz;
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
      SELECT correct_answer, explanation
      FROM questions
      WHERE question_id = $1
      LIMIT 1;
    `;
    const result = await pool.query(query, [quizId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "해당 퀴즈를 찾을 수 없습니다." });
    }

    const quiz = result.rows[0];
    const isCorrect = quiz.correct_answer === userAnswer;

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
      SELECT q.question_id, q.category_id, q.question_text, q.options, t.hint_url
      FROM trending_quizzes t
      JOIN questions q ON t.question_id = q.question_id
      WHERE t.added_at >= NOW() - INTERVAL '14 days'
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

// 사용자가 오늘의 퀴즈를 풀었는지 확인
exports.logDailyQuiz = async (req, res) => {
  const { userId, questionId } = req.body;

  if (!userId || !questionId) {
    return res.status(400).json({ error: "userId와 questionId가 필요합니다." });
  }

  try {
    await pool.query(
      `INSERT INTO daily_quiz_log (user_id, date, question_id)
       VALUES ($1, CURRENT_DATE, $2)
       ON CONFLICT (user_id, date) DO NOTHING`,
      [userId, questionId]
    );

    res.status(200).json({ message: "오늘의 퀴즈 기록 완료" });
  } catch (err) {
    console.error("오늘의 퀴즈 기록 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 완료 여부 조회
exports.getDailyQuizStatus = async (req, res) => {
  const userId = req.params.userId;

  try {
    const result = await pool.query(
      `SELECT 1 FROM daily_quiz_log
       WHERE user_id = $1 AND date = CURRENT_DATE
       LIMIT 1`,
      [userId]
    );

    res.json({ completed: result.rows.length > 0 });
  } catch (err) {
    console.error("오늘의 퀴즈 상태 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
