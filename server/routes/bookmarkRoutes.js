const express = require("express");
const router = express.Router();
const controller = require("../controllers/bookmarkController");

router.post("/:userId/:questionId", controller.addBookmark); // 북마크 추가
router.delete("/:userId/:questionId", controller.removeBookmark); // 북마크 삭제
router.get("/:userId/:questionId", controller.checkBookmark); // 북마크 여부 확인
router.get("/:userId", controller.getBookmarks); // 북마크 목록 조회

module.exports = router;
