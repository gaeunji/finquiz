const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

// 사용자 정보 조회
router.get("/:userId/info", userController.getUserInfo);

// 주간 xp 조회
router.get("/:userId/weekly-xp", userController.getWeeklyXp);

module.exports = router;
