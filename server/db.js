// db.js
const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "quizapp",
  password: "0419", // 비밀번호 입력
  port: 5432,
});

module.exports = pool;
