const express = require("express");
const router = express.Router();
const achievementController = require("../controllers/achievementController");
router.get("/", achievementController.getAllAchievements); // 전체 업적 목록
router.get("/user/:userId", achievementController.getUserAchievements); // 특정 사용자의 업적
router.post("/update", achievementController.updateUserAchievement); // 단일 업적 업데이트
router.post("/update-all", achievementController.updateAllUserAchievements); // 전체 업적 업데이트

module.exports = router;
