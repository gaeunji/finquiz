const pool = require("../db");

// 북마크 여부 확인
exports.checkBookmark = async (req, res) => {
  const userId = Number(req.params.userId); // 사용자 ID
  const questionId = Number(req.params.questionId); // 질문 ID

  try {
    const result = await pool.query(
      `SELECT EXISTS (
         SELECT 1 FROM bookmarked_questions
         WHERE user_id = $1 AND question_id = $2
       ) AS is_bookmarked`,
      [userId, questionId]
    );

    res.json({ isBookmarked: result.rows[0].is_bookmarked });
  } catch (err) {
    console.error("북마크 여부 확인 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 북마크 추가
exports.addBookmark = async (req, res) => {
  const userId = Number(req.params.userId); // 사용자 ID
  // 요청 본문에서 questionId 추출
  const { questionId } = req.body;

  if (!questionId) {
    return res.status(400).json({ error: "questionId가 필요합니다." });
  }

  try {
    await pool.query(
      `INSERT INTO bookmarked_questions (user_id, question_id)
       VALUES ($1, $2)
       ON CONFLICT DO NOTHING`,
      [userId, questionId]
    );
    res.status(201).json({ message: "북마크에 추가되었습니다." });
  } catch (err) {
    console.error("북마크 추가 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 북마크 삭제
exports.removeBookmark = async (req, res) => {
  const userId = Number(req.params.userId);
  const questionId = Number(req.params.questionId);

  try {
    const result = await pool.query(
      `DELETE FROM bookmarked_questions
       WHERE user_id = $1 AND question_id = $2`,
      [userId, questionId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "북마크가 존재하지 않습니다." });
    }

    res.json({ message: "북마크에서 삭제되었습니다." });
  } catch (err) {
    console.error("북마크 삭제 실패:", err);
    res.status(500).json({ error: err.message });
  }
};

// 북마크 목록 조회
exports.getAllBookmarks = async (req, res) => {
  const userId = Number(req.params.userId);

  try {
    const result = await pool.query(
      `SELECT q.question_id, q.question_text, q.category_id, b.bookmarked_at
       FROM bookmarked_questions b
       JOIN questions q ON b.question_id = q.question_id
       WHERE b.user_id = $1
       ORDER BY b.bookmarked_at DESC`,
      [userId]
    );

    res.json(
      result.rows.map((row) => ({
        questionId: row.question_id,
        question: row.question_text,
        categoryId: row.category_id,
        bookmarkedAt: row.bookmarked_at,
      }))
    );
    // 북마크된 질문이 없을 경우
  } catch (err) {
    console.error("북마크 목록 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
