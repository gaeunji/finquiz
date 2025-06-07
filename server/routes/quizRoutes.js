const express = require("express");
const router = express.Router();

const quizController = require("../controllers/quizController");
const sessionController = require("../controllers/sessionController");

// 퀴즈 관련
router.get("/daily", quizController.getDailyQuiz);
router.get("/trending", quizController.getTrendingQuizzes);
router.get("/:quizId", quizController.getQuizById);
router.post("/:quizId/submit", quizController.submitAnswer);
router.post("/questions", quizController.getQuestionsByIds);

// 세션 관련
router.post("/session", sessionController.createSession);
router.post("/session/:sessionId/complete", sessionController.completeSession);
router.post("/session/:sessionId/retry", sessionController.retrySession);
router.post("/submit", sessionController.submitQuizResult);
router.post("/review/wrong", sessionController.createReviewSessionFromWrong);

module.exports = router;
