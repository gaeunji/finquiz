# 📊 Economics Quiz App

**Economics Quiz App**은 경제 지식을 재미있게 학습할 수 있도록 설계된 퀴즈 기반 모바일 애플리케이션입니다. 사용자는 다양한 경제 카테고리 중 관심 분야를 선택하고, 퀴즈를 통해 XP를 얻으며 레벨을 올릴 수 있습니다.

---

## 📱 주요 기능 (Flutter Frontend)

### Home Screen

- 경험치(XP) 및 최근 학습 현황 대시보드
- 연속 학습 일수 추적
- "내 카테고리" 관리

### Explore Screen

- 오늘의 퀴즈 제시
- 전체 카테고리 목록 및 선택 기능
- 트렌딩 퀴즈 카드 제공

### Intro & Quiz

- 선택한 카테고리의 설명 및 키워드 제공
- "시작하기" 버튼으로 퀴즈 세션 생성
- 문제별 선택지 표시 및 다음 문제로 이동
- 세션 완료 시 정답 결과 및 해설 확인 가능

---

## 🌐 백엔드 (Node.js + Express)

### 주요 API

- `POST /quizzes/session` : 새 퀴즈 세션 생성
- `GET /quizzes/:quizId` : 개별 퀴즈 조회
- `POST /quizzes/session/:sessionId/complete` : 세션 결과 제출
- `GET /quizzes/daily` : 오늘의 랜덤 퀴즈 제공
- `GET /categories/`, `GET /categories/name/:name` : 카테고리 정보 조회
- `POST /categories/user/:userId` : 내 카테고리 추가
- `DELETE /categories/user/:userId/:categoryId` : 내 카테고리 삭제

---

## 🛠️ 기술 스택

### Frontend

- **Flutter**
- **Dart**
- `http`, `provider` 등 사용

### Backend

- **Node.js**, **Express**
- **PostgreSQL** + `pg` module
- CORS, JSON 파싱 미들웨어 적용

### Database

- 퀴즈(question), 사용자(user), 카테고리(category), 세션(quiz_sessions) 등의 여러 테이블 사용
- `user_question_log`, `user_answers` 등을 통해 학습 기록 관리

---

## 📁 프로젝트 구조 요약

\`\`\`
📦 quiz_app_project/
├── lib/
│ ├── screens/ # Flutter UI 화면
│ ├── models/ # Category 모델 정의
│ ├── data/ # 카테고리 데이터
│ └── widgets/ # 공통 UI 컴포넌트
├── server/
│ ├── controllers/ # Express 컨트롤러
│ ├── routes/ # API 라우트 정의
│ ├── db.js # PostgreSQL 연결
│ ├── app.js # Express 앱 구성
│ └── server.js # 서버 실행 엔트리포인트
\`\`\`

---

## 🚀 시작 방법

### Backend

\`\`\`bash
cd server
npm install
node server.js
\`\`\`

### Flutter

\`\`\`bash
flutter pub get
flutter run
\`\`\`

> ❗ IP 주소 및 포트(\`10.0.2.2:5000\`)는 로컬 환경에 맞게 조정 필요

---

## 🙌 기여 및 문의
