const mongoose = require("mongoose");
const Quiz = require("../models/Quiz");
require("dotenv").config();

const seed = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);

    const sampleQuiz = new Quiz({
      category_id: "basic_econ",
      question: "GDP가 의미하는 것은 무엇인가요?",
      correct_answer: "국내 총생산",
      explanation:
        "GDP는 일정 기간 동안 한 나라 안에서 생산된 모든 최종 재화와 서비스의 시장 가치입니다.",
    });

    await sampleQuiz.save();
    console.log("✅ 샘플 퀴즈 저장 완료");
    mongoose.disconnect();
  } catch (err) {
    console.error("❌ 퀴즈 저장 실패:", err);
  }
};

seed();
