const express = require("express");
const router = express.Router();
const controller = require("../controllers/wrongQuestionController");

router.get("/:userId", controller.getWrongQuestions);

module.exports = router;
