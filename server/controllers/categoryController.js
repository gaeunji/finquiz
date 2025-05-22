const pool = require("../db");

// 전체 카테고리 목록
exports.getAllCategories = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM categories ORDER BY id");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// 이름으로 카테고리 조회
exports.getCategoryByName = async (req, res) => {
  const { name } = req.params;

  try {
    const result = await pool.query(
      `SELECT * FROM categories WHERE name = $1 LIMIT 1`,
      [name]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "카테고리를 찾을 수 없습니다." });
    }

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ID로 카테고리 조회
exports.getCategoryById = async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query(
      `SELECT * FROM categories WHERE id = $1 LIMIT 1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "카테고리를 찾을 수 없습니다." });
    }

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
