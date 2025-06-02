const pool = require("../db");

// 레벨 계산 함수
function calculateLevelDetails(xp) {
  if (xp < 0) xp = 0;

  let level = 1;
  let requiredXp = 100; // 레벨 2로 가기 위한 초기 xp
  let cumulativeXp = 0;

  while (xp >= cumulativeXp + requiredXp) {
    cumulativeXp += requiredXp;
    level++;
    requiredXp = Math.floor(requiredXp * 1.5); // 1.5배 증가
  }

  return {
    level,
    xp,
    currentLevelXp: xp - cumulativeXp,
    xpToNextLevel: requiredXp,
    progressPercent: Math.floor(((xp - cumulativeXp) / requiredXp) * 100),
  };
}

exports.getUserInfo = async (req, res) => {
  const userId = Number(req.params.userId);

  if (isNaN(userId)) {
    return res.status(400).json({ error: "유효한 userId가 필요합니다." });
  }

  try {
    // 사용자 기본 정보 (XP)
    const userRes = await pool.query(
      `SELECT user_id, username, xp FROM users WHERE user_id = $1`,
      [userId]
    );

    if (userRes.rows.length === 0) {
      return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
    }

    const user = userRes.rows[0];
    const levelDetails = calculateLevelDetails(user.xp);

    // 북마크 수
    const bookmarkRes = await pool.query(
      `SELECT COUNT(*) FROM bookmarked_questions WHERE user_id = $1`,
      [userId]
    );

    // 선택한 카테고리 수
    const categoryRes = await pool.query(
      `SELECT COUNT(*) FROM user_categories WHERE user_id = $1`,
      [userId]
    );

    // 답변한 문제 수
    const answeredRes = await pool.query(
      `SELECT COUNT(*) FROM user_answers WHERE user_id = $1`,
      [userId]
    );

    res.json({
      userId: user.user_id,
      username: user.username,
      xp: user.xp,
      level: levelDetails.level,
      currentLevelXp: levelDetails.currentLevelXp,
      xpToNextLevel: levelDetails.xpToNextLevel,
      progressPercent: levelDetails.progressPercent,
      bookmarks: Number(bookmarkRes.rows[0].count),
      answered: Number(answeredRes.rows[0].count),
      categories: Number(categoryRes.rows[0].count),
    });
  } catch (err) {
    console.error("사용자 정보 조회 실패:", err);
    res.status(500).json({ error: "서버 오류가 발생했습니다." });
  }
};
