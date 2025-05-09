const pool = require("../db");

// 내 카테고리 추가
exports.addCategory = async (req, res) => {
  const { userId } = req.params;
  const { categoryId } = req.body;

  if (!categoryId) {
    return res.status(400).json({ error: "categoryId가 필요합니다." });
  }

  try {
    await pool.query(
      `INSERT INTO user_categories (user_id, category_id)
       VALUES ($1, $2)
       ON CONFLICT DO NOTHING`,
      [userId, categoryId]
    );

    res.status(201).json({ message: "카테고리가 추가되었습니다." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// 내 카테고리 목록 조회
exports.getUserCategories = async (req, res) => {
  const { userId } = req.params;

  try {
    const result = await pool.query(
      `SELECT c.* FROM user_categories uc
       JOIN categories c ON uc.category_id = c.id
       WHERE uc.user_id = $1`,
      [userId]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// 내 카테고리 삭제
exports.removeCategory = async (req, res) => {
  const { userId, categoryId } = req.params;

  try {
    const result = await pool.query(
      `DELETE FROM user_categories WHERE user_id = $1 AND category_id = $2`,
      [userId, categoryId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "삭제할 카테고리가 없습니다." });
    }

    res.json({ message: "카테고리가 삭제되었습니다." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
