import 'package:flutter/material.dart';

class QuizReviewScreen extends StatelessWidget {
  final List<dynamic> results; // 퀴즈 결과 데이터 리스트 받아옴

  const QuizReviewScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 뒤로 가기
        ),
        title: const Text('해설 보기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F9FC),

      // 결과 목록 리스트
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = results[index];
          final isCorrect = item['correct'] == true;

          // 각 문제별 해설 카드
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // 문제 제목 + 정오 아이콘
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isCorrect ? Colors.green[100] : Colors.red[100],
                        ),
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 문제 내용 텍스트
                      Expanded(
                        child: Text(
                          '문제 ${index + 1}: ${item['questionText'] ?? '질문을 불러올 수 없습니다.'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 사용자 답변
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: '내 답변: '),
                          TextSpan(
                            text: item['selectedAnswer'],
                            style: TextStyle(
                              color: isCorrect ? Colors.black : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 실제 정답
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: '정답: '),
                          TextSpan(
                            text: item['correctAnswer'],
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 해설 박스
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '해설',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3366CC),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['explanation'] ?? '-',
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// // arguments로 받은 results를 전달 -> QuizReviewScreen 생성
class QuizReviewScreenWrapper extends StatelessWidget {
  const QuizReviewScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return QuizReviewScreen(results: args);
  }
}
