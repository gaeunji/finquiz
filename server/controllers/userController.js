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
  console.log("Received request for userId:", userId);

  if (isNaN(userId)) {
    console.log("Invalid userId provided");
    return res.status(400).json({ error: "유효한 userId가 필요합니다." });
  }

  try {
    console.log("Attempting to query user data...");
    // 사용자 기본 정보 (XP)
    const userRes = await pool.query(
      `SELECT user_id, username, xp FROM users WHERE user_id = $1`,
      [userId]
    );
    console.log("User query result:", userRes.rows);

    if (userRes.rows.length === 0) {
      console.log("No user found with id:", userId);
      return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
    }

    const user = userRes.rows[0];
    console.log("Found user:", user);
    const levelDetails = calculateLevelDetails(user.xp);
    console.log("Calculated level details:", levelDetails);

    console.log("Fetching bookmark count...");
    // 북마크 수
    const bookmarkRes = await pool.query(
      `SELECT COUNT(*) FROM bookmarked_questions WHERE user_id = $1`,
      [userId]
    );
    console.log("Bookmark count:", bookmarkRes.rows[0].count);

    console.log("Fetching category count...");
    // 선택한 카테고리 수
    const categoryRes = await pool.query(
      `SELECT COUNT(*) FROM user_categories WHERE user_id = $1`,
      [userId]
    );
    console.log("Category count:", categoryRes.rows[0].count);

    const response = {
      userId: user.user_id,
      username: user.username,
      xp: user.xp,
      level: levelDetails.level,
      currentLevelXp: levelDetails.currentLevelXp,
      xpToNextLevel: levelDetails.xpToNextLevel,
      progressPercent: levelDetails.progressPercent,
      bookmarks: Number(bookmarkRes.rows[0].count),
      categories: Number(categoryRes.rows[0].count),
    };
    console.log("Sending response:", response);
    res.json(response);
  } catch (err) {
    console.error("사용자 정보 조회 실패. 상세 에러:", err);
    console.error("에러 스택:", err.stack);
    res.status(500).json({
      error: "서버 오류가 발생했습니다.",
      details: err.message,
    });
  }
};

const { format } = require("date-fns");

exports.getWeeklyXp = async (req, res) => {
  const userId = Number(req.params.userId);
  if (isNaN(userId)) {
    return res.status(400).json({ error: "유효한 userId가 필요합니다." });
  }

  try {
    // 1. 최근 7일간 날짜별 XP 집계
    const result = await pool.query(
      `
      SELECT DATE(earned_at) AS date, SUM(xp) AS xp
      FROM user_xp_log
      WHERE user_id = $1 AND earned_at >= CURRENT_DATE - INTERVAL '6 days'
      GROUP BY DATE(earned_at)
      `,
      [userId]
    );

    const xpMap = {};
    for (const row of result.rows) {
      xpMap[format(new Date(row.date), "yyyy-MM-dd")] = Number(row.xp);
    }

    // 2. 오늘 포함 최근 7일간 날짜 리스트 구성
    const today = new Date();
    const dailyXp = [];
    let total = 0;

    for (let i = 6; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(today.getDate() - i);
      const dateStr = format(date, "yyyy-MM-dd");
      const xp = xpMap[dateStr] || 0;
      dailyXp.push({ date: dateStr, xp });
      total += xp;
    }

    res.json({
      userId,
      totalXp: total,
      dailyXp,
    });
  } catch (err) {
    console.error("주간 XP 조회 실패:", err);
    res.status(500).json({ error: "서버 오류가 발생했습니다." });
  }
};
