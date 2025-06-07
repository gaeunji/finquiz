const pool = require("../db");

// 틀린 문제 조회 컨트롤러
exports.getWrongQuestions = async (req, res) => {
  const userId = Number(req.params.userId);

  // 입력 유효성 검사
  try {
    const result = await pool.query(
      `SELECT 
         q.question_id, q.question_text, q.category_id, q.options,
         q.correct_answer, ua.selected_answer, q.difficulty,
         c.name AS category
       FROM user_answers ua
       JOIN questions q ON ua.question_id = q.question_id
       JOIN categories c ON q.category_id = c.id
       WHERE ua.user_id = $1 AND ua.is_correct = FALSE
       ORDER BY ua.question_id DESC`,
      [userId]
    );

    // 결과가 없으면 빈 배열 반환
    if (result.rows.length === 0) {
      return res.json([]);
    }
    // 결과를 원하는 형식으로 변환
    const wrongQuestions = result.rows.map((row) => ({
      questionId: row.question_id,
      question: row.question_text,
      categoryId: row.category_id,
      difficulty: row.difficulty,
      category: row.category,
      options:
        typeof row.options === "string" ? JSON.parse(row.options) : row.options,
      correctAnswer: row.correct_answer,
      userAnswer: row.selected_answer,
    }));

    // 클라이언트에 응답
    res.json(wrongQuestions);
  } catch (err) {
    console.error("틀린 문제 조회 실패:", err);
    res.status(500).json({ error: "틀린 문제를 가져오는 데 실패했습니다." });
  }
};
