const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

// 사용자 정보 조회
router.get("/:userId/info", userController.getUserInfo);

// 사용자 레벨 조회
router.get("/:userId/level", userController.getUserLevel);

module.exports = router;
