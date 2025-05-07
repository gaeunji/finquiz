const pool = require("../db");

exports.getAllCategories = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT category_id, name FROM categories ORDER BY name;
    `);

    res.json(result.rows);
  } catch (err) {
    console.error("카테고리 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
};
