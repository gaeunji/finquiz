const express = require("express");
const router = express.Router();
const pool = require("../db");

// 업적 평가 로직
const evaluateAchievement = async (achievement, userData, userId) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

  let isAchieved = false;
  let currentValue = 0;

  switch (targetType) {
    case "total_quiz_count":
      currentValue = parseInt(userData.total_quiz_count) || 0;
      isAchieved = currentValue >= targetValue;
      break;
    case "perfect_scores":
      currentValue = parseInt(userData.perfect_scores) || 0;
      isAchieved = currentValue >= targetValue;
      break;
    case "consecutive_days":
      currentValue = parseInt(userData.consecutive_days) || 0;
      isAchieved = currentValue >= targetValue;
      break;
    case "category_quiz_count":
      const categoryId = attributes?.categoryId;
      currentValue = categoryId
        ? parseInt(userData.categoryQuizCounts?.[categoryId]) || 0
        : 0;
      isAchieved = currentValue >= targetValue;
      break;
    case "bookmark_count":
      currentValue = parseInt(userData.bookmark_count) || 0;
      isAchieved = currentValue >= targetValue;
      break;
    case "xp_amount":
      currentValue = parseInt(userData.xp_amount) || 0;
      isAchieved = currentValue >= targetValue;
      break;
    default:
      isAchieved = false;
  }

  // 진행도가 100% 이상이면 업적 해제
  const progress = Math.min(
    Math.round((currentValue / targetValue) * 100),
    100
  );
  if (progress >= 100) {
    isAchieved = true;
  }

  return isAchieved;
};

// 업적 진행률 계산
const calculateProgress = (achievement, userData) => {
  const { targetType, targetValue } = achievement;
  const { attributes } = achievement;

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
const updateUserAchievement = async (userId, achievementId, userData) => {
  try {
    const achievement = await getAchievementById(achievementId);
    if (!achievement) {
      throw new Error("Achievement not found");
    }

    const isAchieved = await evaluateAchievement(achievement, userData, userId);
    const progress = calculateProgress(achievement, userData);

    // 진행도가 100% 이상이면 unlocked를 true로 설정
    const unlocked = progress >= 100 ? true : isAchieved;

    const query = `
      UPDATE user_achievements 
      SET 
        unlocked = ?,
        progress = ?,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ? AND achievement_id = ?
    `;

    const [result] = await pool.query(query, [
      unlocked,
      progress,
      userId,
      achievementId,
    ]);

    if (result.affectedRows === 0) {
      throw new Error("Failed to update user achievement");
    }

    return {
      ...achievement,
      unlocked,
      progress,
    };
  } catch (error) {
    console.error("Error updating user achievement:", error);
    throw error;
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
      const isAchieved = await evaluateAchievement(
        achievement,
        userData,
        userId
      );
      const progress = calculateProgress(achievement, userData);

      console.log("Processing achievement:", {
        id: achievement.id,
        isAchieved,
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

      // 진행도가 100% 이상이면 unlocked를 true로 설정
      const unlocked = progress >= 100 ? true : isAchieved;

      // 업적 상태 업데이트
      return pool.query(
        `UPDATE user_achievements 
         SET 
           unlocked = $1,
           progress = $2,
           updated_at = $3
         WHERE user_id = $4 AND achievement_id = $5`,
        [unlocked, progress, currentTimestamp, userId, achievement.id]
      );
    });

    const results = await Promise.all(updatePromises);
    const updatedAchievements = results.map((result) => result.rows[0]);

    console.log("All achievements updated:", updatedAchievements.length);

    // 업데이트된 업적 정보와 함께 원본 업적 정보도 포함
    const achievementsWithDetails = achievements.map((achievement) => {
      const updatedInfo = updatedAchievements.find(
        (ua) => ua.achievement_id === achievement.id
      );
      return {
        ...achievement,
        progress: updatedInfo?.progress || 0,
        unlocked: updatedInfo?.unlocked || false,
        unlockedAt: updatedInfo?.unlocked_at || null,
        updatedAt: updatedInfo?.updated_at || null,
      };
    });

    res.json({
      message: "모든 업적이 업데이트되었습니다.",
      achievements: achievementsWithDetails,
    });
  } catch (error) {
    console.error("업적 일괄 업데이트 중 오류:", error);
    res.status(500).json({
      error: "업적 일괄 업데이트에 실패했습니다.",
      details: error.message,
    });
  }
};

const updateExistingAchievements = async () => {
  try {
    const query = `
      UPDATE user_achievements 
      SET 
        unlocked = true,
        updated_at = CURRENT_TIMESTAMP
      WHERE progress >= 100 AND unlocked = false
    `;

    const result = await pool.query(query);
    return result.rowCount;
  } catch (error) {
    console.error("Error updating existing achievements:", error);
    throw error;
  }
};

// 기존 업적 업데이트 실행
updateExistingAchievements().catch(console.error);

module.exports = {
  getAllAchievements,
  getUserAchievements,
  updateUserAchievement,
  updateAllUserAchievements,
  updateExistingAchievements,
};
