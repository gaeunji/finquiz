const express = require("express");
const router = express.Router();
const controller = require("../controllers/bookmarkController");

router.post("/:userId/bookmarks", controller.addBookmark); // 북마크 추가
router.delete("/:userId/bookmarks/:questionId", controller.removeBookmark); // 북마크 삭제

router.get("/:userId/bookmarks/:questionId", controller.checkBookmark); // 특정 퀴즈에 대한 북마크 조회

// 북마크 전체 목록 조회
router.get("/:userId/bookmarks", controller.getAllBookmarks);

module.exports = router;
