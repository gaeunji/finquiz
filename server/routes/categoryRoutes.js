const express = require("express");
const router = express.Router();
const categoryController = require("../controllers/categoryController");

router.get("/", categoryController.getAllCategories);
router.get("/name/:name", categoryController.getCategoryByName);
router.get("/:id", categoryController.getCategoryById);

module.exports = router;
