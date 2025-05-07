const express = require("express");
const router = express.Router();
const pool = require("../db");
const categoryController = require("../controllers/categoryController");

// ✅ 전체 카테고리 목록
router.get("/", categoryController.getAllCategories);

// ✅ 특정 이름의 카테고리 상세 조회
// GET /categories/name/:name
router.get("/name/:name", async (req, res) => {
  const { name } = req.params;

  try {
    const result = await pool.query(
      `SELECT description, keywords FROM categories WHERE name = $1`,
      [name]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "카테고리를 찾을 수 없습니다." });
    }

    const { description, keywords } = result.rows[0];

    // ✅ keywords가 JSON 문자열이면 파싱 처리
    let parsedKeywords = keywords;
    if (typeof keywords === "string") {
      try {
        parsedKeywords = JSON.parse(keywords);
      } catch (err) {
        console.warn("⚠️ keywords 파싱 실패: 문자열 그대로 반환");
      }
    }

    res.json({
      description,
      keywords: parsedKeywords,
    });
  } catch (err) {
    console.error("카테고리 조회 실패:", err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
