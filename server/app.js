const express = require("express");
const cors = require("cors");

const app = express();
const quizRoutes = require("./routes/quizRoutes");

app.use((req, res, next) => {
  // 요청 로깅
  console.log(
    `\n📥 [${new Date().toLocaleTimeString()}] ${req.method} ${req.url}`
  );

  const originalSend = res.send;
  res.send = function (body) {
    // 응답 로깅 - 상태 코드, 응답 데이터
    const responseType = typeof body === "string" ? "JSON" : "Data";
    console.log(
      `📤 [${new Date().toLocaleTimeString()}] Response: ${responseType} (${
        res.statusCode
      })`
    );
    return originalSend.call(this, body);
  };

  next();
});

app.use(cors());
app.use(express.json());

// 라우터 연결
app.use("/quizzes", quizRoutes);

const categoryRoutes = require("./routes/categoryRoutes");
app.use("/categories", categoryRoutes);

const userCategoryRoutes = require("./routes/userCategoryRoutes");
app.use("/user-categories", userCategoryRoutes);

const bookmarkRoutes = require("./routes/bookmarkRoutes");
app.use("/user-bookmarks", bookmarkRoutes);

const wrongQuestionRoutes = require("./routes/wrongQuestionRoutes");
app.use("/wrong-questions", wrongQuestionRoutes);

const userRoutes = require("./routes/userRoutes");
app.use("/users", userRoutes);

module.exports = app;
