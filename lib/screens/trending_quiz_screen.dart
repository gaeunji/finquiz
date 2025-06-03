import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/trending_quiz.dart';
import '../widgets/trending_quiz_card.dart';
import '../services/quiz_service.dart';
import '../config/env.dart';

Color _difficultyColor(String difficulty) {
  switch (difficulty) {
    case '초급':
      return Colors.green.shade100;
    case '중급':
      return Colors.yellow.shade100;
    case '고급':
      return Colors.red.shade100;
    default:
      return Colors.grey.shade100;
  }
}

class TrendingQuizListScreen extends StatelessWidget {
  final List<TrendingQuiz> quizzes;

  const TrendingQuizListScreen({super.key, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("트렌딩 퀴즈 전체보기"), leading: BackButton()),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: quizzes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return TrendingQuizCard(
            quiz: quiz,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrendingQuizDetail(quiz: quiz),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 트렌딩 퀴즈 문제 풀이 화면
class TrendingQuizDetail extends StatelessWidget {
  final TrendingQuiz quiz;

  const TrendingQuizDetail({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          '퀴즈 문제',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 뉴스 이미지와 제목
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        // 테스트용 URL
                        const testUrl = 'https://www.google.com';
                        debugPrint('URL 실행 시도: $testUrl');

                        final result = await launchUrlString(
                          testUrl,
                          mode: LaunchMode.externalApplication,
                        );

                        debugPrint('URL 실행 결과: $result');
                        if (!result) {
                          debugPrint('URL 실행 실패: launchUrlString이 false를 반환');
                        }
                      } catch (e) {
                        debugPrint('URL 실행 중 오류 발생: $e');
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        quiz.newsImage,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback 1: 키워드 기반 Unsplash
                          return Image.network(
                            'https://source.unsplash.com/400x200/?economy',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback 2: 로컬 이미지
                              return Image.asset(
                                'assets/images/news_image1.jpg',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '트렌딩 #${quiz.trendingRank ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quiz.newsTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 문제와 선택지
            Container(
              padding: const EdgeInsets.all(26),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          quiz.difficulty,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    quiz.question,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 보기 옵션
                  ...quiz.options.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          child: Text(
                            e.value,
                            style: const TextStyle(fontSize: 16),
                            maxLines: null, // 줄바꿈 허용
                            overflow: TextOverflow.visible, // overflow 방지
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff006FFD),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "정답 확인하기",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
