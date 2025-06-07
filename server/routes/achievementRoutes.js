const express = require("express");
const router = express.Router();
const achievementController = require("../controllers/achievementController");
router.get("/", achievementController.getAllAchievements); // 전체 업적 목록
router.get("/user/:userId", achievementController.getUserAchievements); // 특정 사용자의 업적
router.post("/update", achievementController.updateUserAchievement); // 단일 업적 업데이트
router.post("/update-all", achievementController.updateAllUserAchievements); // 전체 업적 업데이트
router.get("/update-existing", async (req, res) => {
  try {
    const updatedCount =
      await achievementController.updateExistingAchievements();
    res.json({
      message: `Updated ${updatedCount} achievements to unlocked status`,
      updatedCount,
    });
  } catch (error) {
    console.error("Error updating existing achievements:", error);
    res.status(500).json({ error: "Failed to update existing achievements" });
  }
});

module.exports = router;
