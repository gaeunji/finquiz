const express = require("express");
const router = express.Router();
const controller = require("../controllers/bookmarkController");

router.post("/:userId/bookmarks", controller.addBookmark);
router.delete("/:userId/bookmarks/:questionId", controller.removeBookmark);
router.get("/:userId/bookmarks", controller.getBookmarks);

module.exports = router;
