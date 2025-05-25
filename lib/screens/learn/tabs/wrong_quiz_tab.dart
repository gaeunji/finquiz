import 'package:flutter/material.dart';

class WrongQuizTab extends StatelessWidget {
  const WrongQuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> incorrectQuestions = [
      {
        'id': 1,
        'question': '통화정책의 주요 수단은 무엇인가요?',
        'category': '거시경제학',
        'difficulty': '중급',
        'attempts': 3,
        'lastAttempt': '2일 전',
        'correctAnswer': '기준금리',
        'userAnswer': '정부지출',
      },
      {
        'id': 2,
        'question': '진입장벽이 가장 높은 시장구조는?',
        'category': '미시경제학',
        'difficulty': '고급',
        'attempts': 2,
        'lastAttempt': '1주 전',
        'correctAnswer': '독점',
        'userAnswer': '과점',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(4),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildQuickReviewCard(),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: incorrectQuestions.length,
          shrinkWrap: true, //
          physics: const NeverScrollableScrollPhysics(), //  중첩 스크롤 방지
          itemBuilder: (context, index) {
            return _buildIncorrectQuestionCard(incorrectQuestions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: '틀린 문제 검색...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildQuickReviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfff56725), Colors.pink],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '빠른 복습',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '최근 틀린 문제 5개를 복습하세요',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncorrectQuestionCard(Map<String, dynamic> question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBadge(
                  question['category'],
                  Colors.grey[300]!,
                  Colors.black,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  question['difficulty'],
                  Colors.grey[200]!,
                  Colors.black54,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '정답: ${question['correctAnswer']}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              '내 답: ${question['userAnswer']}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 풀기'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('해설 보기')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }
}
