const express = require("express");
const cors = require("cors");

const app = express();
const quizRoutes = require("./routes/quizRoutes");

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

module.exports = app;
