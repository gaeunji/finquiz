import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DailyQuizWidget extends StatelessWidget {
  const DailyQuizWidget({Key? key}) : super(key: key);

  Future<void> _handleTap(BuildContext context) async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2:5000/quizzes/daily'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final quizId = data['id'].toString();

      // 세션 생성
      final createRes = await http.post(
        // 일단 퀴즈 세션으로 넘어가도록 임시 구현
        Uri.parse('http://10.0.2.2:5000/quizzes/session'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'categoryId': data['category_id'],
          'userId': 123, // TODO: 사용자 ID로 변경하기
        }),
      );

      if (createRes.statusCode == 201) {
        final session = json.decode(createRes.body);
        Navigator.pushNamed(context, '/quiz', arguments: {
          'sessionId': session['sessionId'],
          'quizIds': session['quizIds'],
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('퀴즈를 불러오지 못했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '매일 업데이트',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 하얀색 박스
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
              onTap: () async => _handleTap(context),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 뱃지 ( 카테고리 + 난이도 + 완료 여부 )
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '거시경제학',
                            style: TextStyle(
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
                          child: const Text(
                            '중급',
                            style: TextStyle(
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
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '미완료',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '중앙은행이 기준금리를 인상할 때 일반적으로 나타나는 현상은 무엇인가요?',
                      style: TextStyle(
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
