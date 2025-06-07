const express = require("express");
const router = express.Router();
const pool = require("../db");

// 업적 평가 로직
const evaluateAchievement = async (achievement, userData, userId) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

  console.log("Evaluating achievement:", {
    achievement,
    userData,
    userId,
  });

  let isAchieved = false;
  switch (targetType) {
    case "total_quiz_count":
      isAchieved = (userData.totalQuizCount || 0) >= targetValue;
      break;
    case "perfect_scores":
      isAchieved = (userData.perfectScores || 0) >= targetValue;
      break;
    case "consecutive_days":
      isAchieved = (userData.consecutiveDays || 0) >= targetValue;
      break;
    case "category_quiz_count":
      const categoryId = attributes?.categoryId;
      isAchieved =
        categoryId &&
        (userData.categoryQuizCounts?.[categoryId] || 0) >= targetValue;
      break;
    case "bookmark_count":
      isAchieved = (userData.bookmarkCount || 0) >= targetValue;
      break;
    case "xp_amount":
      isAchieved = (userData.xpAmount || 0) >= targetValue;
      break;
    default:
      isAchieved = false;
  }

  console.log("Achievement evaluation result:", {
    targetType,
    targetValue,
    isAchieved,
  });

  return isAchieved;
};

// 업적 진행률 계산
const calculateProgress = (achievement, userData) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

  console.log("Calculating progress for:", {
    targetType,
    targetValue,
    attributes,
    userData,
  });

  let currentValue = 0;
  switch (targetType) {
    case "total_quiz_count":
      currentValue = parseInt(userData.total_quiz_count) || 0;
      break;
    case "perfect_scores":
      currentValue = parseInt(userData.perfect_scores) || 0;
      break;
    case "consecutive_days":
      currentValue = parseInt(userData.consecutive_days) || 0;
      break;
    case "category_quiz_count":
      const categoryId = attributes?.categoryId;
      currentValue = categoryId
        ? parseInt(userData.categoryQuizCounts?.[categoryId]) || 0
        : 0;
      break;
    case "bookmark_count":
      currentValue = parseInt(userData.bookmark_count) || 0;
      break;
    case "xp_amount":
      currentValue = parseInt(userData.xp_amount) || 0;
      break;
  }

  console.log("Progress calculation:", {
    targetType,
    targetValue,
    currentValue,
    calculatedProgress: Math.min(
      Math.round((currentValue / targetValue) * 100),
      100
    ),
  });

  return Math.min(Math.round((currentValue / targetValue) * 100), 100);
};

// 모든 업적 가져오기
const getAllAchievements = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT 
        id,
        title,
        description,
        icon,
        color,
        target_type as "targetType",
        target_value as "targetValue",
        category_id as "categoryId",
        created_at as "createdAt"
      FROM achievements 
      ORDER BY id`
    );
    res.json(result.rows);
  } catch (error) {
    console.error("업적 목록 조회 중 오류:", error);
    res.status(500).json({ error: "업적 목록을 가져오는데 실패했습니다." });
  }
};

// 사용자의 업적 가져오기
const getUserAchievements = async (req, res) => {
  try {
    const { userId } = req.params;

    // 사용자 ID 유효성 검사
    if (!userId || isNaN(parseInt(userId))) {
      return res.status(400).json({ error: "유효하지 않은 사용자 ID입니다." });
    }

    // 모든 업적을 가져옴
    const achievementsResult = await pool.query(
      `SELECT 
        id,
        title,
        description,
        icon,
        color,
        target_type as "targetType",
        COALESCE(target_value, 0) as "targetValue",
        COALESCE(category_id, 0) as "categoryId",
        created_at as "createdAt"
      FROM achievements
      ORDER BY id`
    );

    // 사용자의 업적 진행도를 가져옴
    const userProgressResult = await pool.query(
      `SELECT 
        achievement_id,
        COALESCE(progress, 0) as progress,
        COALESCE(unlocked, false) as unlocked,
        unlocked_at as "unlockedAt",
        updated_at as "updatedAt"
      FROM user_achievements
      WHERE user_id = $1`,
      [userId]
    );

    // 업적 + 진행도
    const achievements = achievementsResult.rows.map((achievement) => {
      const progress = userProgressResult.rows.find(
        (p) => p.achievement_id === achievement.id
      );

      // 진행도가 없는 경우 기본값 설정
      const achievementWithProgress = {
        ...achievement,
        progress: 0,
        unlocked: false,
        unlockedAt: null,
        updatedAt: null,
      };

      // 진행도가 있는 경우 해당 값으로 업데이트
      if (progress) {
        achievementWithProgress.progress = progress.progress;
        achievementWithProgress.unlocked = progress.unlocked;
        achievementWithProgress.unlockedAt = progress.unlockedAt;
        achievementWithProgress.updatedAt = progress.updatedAt;
      }

      return achievementWithProgress;
    });

    res.json(achievements);
  } catch (error) {
    console.error("사용자 업적 목록 조회 중 오류:", error);
    res.status(500).json({
      error: "사용자의 업적 목록을 가져오는데 실패했습니다.",
      details:
        process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// 단일 업적 업데이트
const updateUserAchievement = async (req, res) => {
  try {
    const { userId, achievementId, userData } = req.body;

    console.log("Update request received:", {
      userId,
      achievementId,
      userData,
    });

    if (!userId || !achievementId || !userData) {
      console.error("Missing required data:", {
        userId,
        achievementId,
        userData,
      });
      return res.status(400).json({ error: "필수 데이터가 누락되었습니다." });
    }

    // 업적 정보 조회
    const achievementResult = await pool.query(
      `SELECT 
        id,
        title,
        description,
        icon,
        color,
        target_type as "targetType",
        target_value as "targetValue",
        category_id as "categoryId",
        created_at as "createdAt"
      FROM achievements 
      WHERE id = $1`,
      [achievementId]
    );

    console.log("Achievement query result:", achievementResult.rows);

    if (achievementResult.rows.length === 0) {
      return res.status(404).json({ error: "업적을 찾을 수 없습니다." });
    }

    const achievement = achievementResult.rows[0];
    const isUnlocked = await evaluateAchievement(achievement, userData, userId);
    const progress = calculateProgress(achievement, userData);

    console.log("Final values before update:", {
      isUnlocked,
      progress,
      achievement,
    });

    // 현재 시간을 기준으로 업데이트
    const currentTimestamp = new Date();

    // 현재 업적 상태 확인
    const currentStatus = await pool.query(
      `SELECT unlocked FROM user_achievements 
       WHERE user_id = $1 AND achievement_id = $2`,
      [userId, achievementId]
    );

    console.log("Current achievement status:", currentStatus.rows);

    // 업적 상태 업데이트
    const result = await pool.query(
      `INSERT INTO user_achievements 
        (user_id, achievement_id, progress, unlocked, unlocked_at, updated_at)
      VALUES ($1, $2, $3, $4, $5, $5)
      ON CONFLICT (user_id, achievement_id) DO UPDATE
      SET 
        progress = $3,
        unlocked = $4,
        unlocked_at = CASE 
          WHEN $4 = true AND user_achievements.unlocked = false 
          THEN $5
          ELSE user_achievements.unlocked_at 
        END,
        updated_at = $5
      RETURNING *`,
      [userId, achievementId, progress, isUnlocked, currentTimestamp]
    );

    console.log("Final update result:", result.rows);

    res.json({
      message: "업적이 업데이트되었습니다.",
      achievement: {
        ...achievement,
        progress,
        unlocked: isUnlocked,
        unlockedAt: isUnlocked ? currentTimestamp : null,
        updatedAt: currentTimestamp,
      },
    });
  } catch (error) {
    console.error("업적 업데이트 중 오류:", error);
    res.status(500).json({
      error: "업적 업데이트에 실패했습니다.",
      details: error.message,
    });
  }
};

// 모든 업적 업데이트
const updateAllUserAchievements = async (req, res) => {
  try {
    const { userId, userData } = req.body;
    const currentTimestamp = new Date();

    console.log("Update all achievements request received:", {
      userId,
      userData,
    });

    if (!userId || !userData) {
      console.error("Missing required data:", { userId, userData });
      return res.status(400).json({ error: "필수 데이터가 누락되었습니다." });
    }

    // 모든 업적 조회
    const achievementsResult = await pool.query(
      `SELECT 
        id,
        title,
        description,
        icon,
        color,
        target_type as "targetType",
        target_value as "targetValue",
        category_id as "categoryId",
        created_at as "createdAt"
      FROM achievements`
    );
    const achievements = achievementsResult.rows;

    console.log("Found achievements:", achievements.length);

    // 각 업적에 대해 진행도 계산 및 업데이트
    const updatePromises = achievements.map(async (achievement) => {
      const isUnlocked = await evaluateAchievement(
        achievement,
        userData,
        userId
      );
      const progress = calculateProgress(achievement, userData);

      console.log("Processing achievement:", {
        id: achievement.id,
        isUnlocked,
        progress,
      });

      // 현재 업적 상태 확인
      const currentStatus = await pool.query(
        `SELECT unlocked FROM user_achievements 
         WHERE user_id = $1 AND achievement_id = $2`,
        [userId, achievement.id]
      );

      console.log("Current status for achievement:", {
        id: achievement.id,
        status: currentStatus.rows[0],
      });

      // 업적 상태 업데이트
      return pool.query(
        `INSERT INTO user_achievements 
          (user_id, achievement_id, progress, unlocked, unlocked_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $5)
        ON CONFLICT (user_id, achievement_id) DO UPDATE
        SET 
          progress = $3,
          unlocked = $4,
          unlocked_at = CASE 
            WHEN $4 = true AND user_achievements.unlocked = false 
            THEN $5
            ELSE user_achievements.unlocked_at 
          END,
          updated_at = $5
        RETURNING *`,
        [userId, achievement.id, progress, isUnlocked, currentTimestamp]
      );
    });

    const results = await Promise.all(updatePromises);
    const updatedAchievements = results.map((result) => result.rows[0]);

    console.log("All achievements updated:", updatedAchievements.length);

    res.json({
      message: "모든 업적이 업데이트되었습니다.",
      achievements: updatedAchievements,
    });
  } catch (error) {
    console.error("업적 일괄 업데이트 중 오류:", error);
    res.status(500).json({
      error: "업적 일괄 업데이트에 실패했습니다.",
      details: error.message,
    });
  }
};

module.exports = {
  getAllAchievements,
  getUserAchievements,
  updateUserAchievement,
  updateAllUserAchievements,
};
