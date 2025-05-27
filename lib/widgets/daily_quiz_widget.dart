import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DailyQuizWidget extends StatefulWidget {
  const DailyQuizWidget({super.key});

  @override
  State<DailyQuizWidget> createState() => _DailyQuizWidgetState();
}

class _DailyQuizWidgetState extends State<DailyQuizWidget> {
  Map<String, dynamic>? quiz;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDailyQuiz();
  }

  Future<void> _fetchDailyQuiz() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/quizzes/daily'));
      if (response.statusCode == 200) {
        setState(() {
          quiz = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('[에러] 퀴즈 응답 실패: ${response.body}');
      }
    } catch (e) {
      print('[에러] 퀴즈 요청 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 탭 핸들러 함수
  // error: The method '[]' can't be unconditionally invoked because the receiver can be 'null'.
  Future<void> _handleTap(BuildContext context) async {
    if (quiz == null) return;

    final rawCategoryId = quiz!['category_id'];
    if (rawCategoryId == null) {
      print('[에러] category_id가 null입니다.');
      return;
    }

    final categoryId = int.tryParse(rawCategoryId.toString());
    if (categoryId == null) {
      print('[에러] category_id 변환 실패');
      return;
    }

    final userId = 123;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/quizzes/session'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'categoryId': categoryId,
          'userId': userId,
          'count': 1,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        Navigator.pushNamed(context, '/quiz', arguments: {
          'sessionId': data['sessionId'],
          'quizIds': data['quizIds'],
        });
      } else {
        print('[세션 생성 실패] ${response.body}');
      }
    } catch (e) {
      print('[세션 생성 예외] $e');
    }
  }

  // 카테고리 이름 매핑 함수
  String _getCategoryName(int? categoryId) {
    switch (categoryId) {
      case 1:
        return '거시경제학';
      case 2:
        return '국제경제·무역';
      case 3:
        return '금융·투자';
      case 4:
        return '기초 경제 개념';
      case 5:
        return '미시경제학';
      case 6:
        return '시사 상식';
      case 7:
        return '행동경제학';
      default:
        return '경제학';
    }
  }

  // 난이도 매핑 함수
  String _getDifficultyText(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return '초급';
      case 'medium':
        return '중급';
      case 'hard':
        return '고급';
      default:
        return '중급';
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    )
        : quiz == null
        ? const Center(
      child: Text(
        '퀴즈를 불러올 수 없습니다.',
        style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      ),
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              // 카테고리 뱃지
              child: Text(
                _getCategoryName(quiz!['category_id']),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _getDifficultyText(quiz!['difficulty']),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: quiz!['is_completed'] == true
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                quiz!['is_completed'] == true ? '완료' : '미완료',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: quiz!['is_completed'] == true
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          quiz?['question'] ?? '문제를 불러오는 중...',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Row(
              children: const [
                Text(
                  '문제 풀기',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2563EB),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Color(0xFF2563EB),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘의 퀴즈',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.access_time, size: 12, color: Color(0xFF6B7280)),
                  SizedBox(width: 4),
                  Text(
                    '매일 업데이트',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isLoading || quiz == null
                  ? null
                  : () async => _handleTap(context),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
