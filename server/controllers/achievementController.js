const express = require("express");
const router = express.Router();
const pool = require("../db");

// 업적 평가 로직
const evaluateAchievement = (achievement, userData) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

  switch (targetType) {
    case "total_quiz_count":
      return userData.totalQuizCount >= targetValue;
    case "perfect_scores":
      return userData.perfectScores >= targetValue;
    case "consecutive_days":
      return userData.consecutiveDays >= targetValue;
    case "category_quiz_count":
      const categoryId = attributes?.categoryId;
      return (
        categoryId && userData.categoryQuizCounts[categoryId] >= targetValue
      );
    case "bookmark_count":
      return userData.bookmarkCount >= targetValue;
    case "xp_amount":
      return userData.xpAmount >= targetValue;
    default:
      return false;
  }
};

// 업적 진행률 계산
const calculateProgress = (achievement, userData) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

  let currentValue = 0;
  switch (targetType) {
    case "total_quiz_count":
      currentValue = userData.totalQuizCount;
      break;
    case "perfect_scores":
      currentValue = userData.perfectScores;
      break;
    case "consecutive_days":
      currentValue = userData.consecutiveDays;
      break;
    case "category_quiz_count":
      const categoryId = attributes?.categoryId;
      currentValue = categoryId
        ? userData.categoryQuizCounts[categoryId] || 0
        : 0;
      break;
    case "bookmark_count":
      currentValue = userData.bookmarkCount;
      break;
    case "xp_amount":
      currentValue = userData.xpAmount;
      break;
  }

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

    if (achievementResult.rows.length === 0) {
      return res.status(404).json({ error: "업적을 찾을 수 없습니다." });
    }

    const achievement = achievementResult.rows[0];
    const isUnlocked = evaluateAchievement(achievement, userData);
    const progress = calculateProgress(achievement, userData);

    // 업적 상태 업데이트
    const result = await pool.query(
      `INSERT INTO user_achievements 
        (user_id, achievement_id, progress, unlocked, unlocked_at)
      VALUES ($1, $2, $3, $4, CASE WHEN $4 = true THEN NOW() ELSE NULL END)
      ON CONFLICT (user_id, achievement_id) DO UPDATE
      SET 
        progress = $3,
        unlocked = $4,
        unlocked_at = CASE 
          WHEN $4 = true AND user_achievements.unlocked = false 
          THEN NOW() 
          ELSE user_achievements.unlocked_at 
        END
      RETURNING *`,
      [userId, achievementId, progress, isUnlocked]
    );

    res.json({
      message: "업적이 업데이트되었습니다.",
      achievement: {
        ...achievement,
        progress,
        unlocked: isUnlocked,
        unlockedAt: isUnlocked ? new Date() : null,
      },
    });
  } catch (error) {
    console.error("업적 업데이트 중 오류:", error);
    res.status(500).json({ error: "업적 업데이트에 실패했습니다." });
  }
};

// 모든 업적 업데이트
const updateAllUserAchievements = async (req, res) => {
  try {
    const { userId, userData } = req.body;

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

    // 각 업적에 대해 진행도 계산 및 업데이트
    const updatePromises = achievements.map(async (achievement) => {
      const isUnlocked = evaluateAchievement(achievement, userData);
      const progress = calculateProgress(achievement, userData);

      return pool.query(
        `INSERT INTO user_achievements 
          (user_id, achievement_id, progress, unlocked, unlocked_at)
        VALUES ($1, $2, $3, $4, CASE WHEN $4 = true THEN NOW() ELSE NULL END)
        ON CONFLICT (user_id, achievement_id) DO UPDATE
        SET 
          progress = $3,
          unlocked = $4,
          unlocked_at = CASE 
            WHEN $4 = true AND user_achievements.unlocked = false 
            THEN NOW() 
            ELSE user_achievements.unlocked_at 
          END
        RETURNING *`,
        [userId, achievement.id, progress, isUnlocked]
      );
    });

    const results = await Promise.all(updatePromises);
    const updatedAchievements = results.map((result) => result.rows[0]);

    res.json({
      message: "모든 업적이 업데이트되었습니다.",
      achievements: updatedAchievements,
    });
  } catch (error) {
    console.error("업적 일괄 업데이트 중 오류:", error);
    res.status(500).json({ error: "업적 일괄 업데이트에 실패했습니다." });
  }
};

module.exports = {
  getAllAchievements,
  getUserAchievements,
  updateUserAchievement,
  updateAllUserAchievements,
};
