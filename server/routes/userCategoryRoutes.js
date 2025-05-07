const express = require("express");
const router = express.Router();
const controller = require("../controllers/userCategoryController");

router.post("/:userId/categories", controller.addCategory);
router.get("/:userId/categories", controller.getUserCategories);
router.delete("/:userId/categories/:categoryId", controller.removeCategory);

module.exports = router;
