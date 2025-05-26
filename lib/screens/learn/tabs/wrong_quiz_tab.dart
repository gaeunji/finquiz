import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WrongQuizTab extends StatelessWidget {
  const WrongQuizTab({super.key});

  // 난이도에 따라 뱃지 색상 조절하눈 함수
  Color _getDifficultyColor(String level) {
    switch (level) {
      case '고급':
        return Colors.red;
      case '중급':
        return Colors.orange;
      case '초급':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }


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
        const SizedBox(height: 2),
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

  // 검색 바 UI (Row + Expanded + Container)
  Widget _buildSearchBar() {
    return Row(
      children: [
        // 검색 입력창
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '틀린 문제 검색...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 40,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(width: 12),
        // 필터 버튼
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt, size: 20),
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // 틀린 문제 quick review 카드 (빠른 복습) !!!!!
  Widget _buildQuickReviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfffa4872), Color(0xffeb5967)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                  style: TextStyle(color: Colors.white70, fontSize: 12),
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

  // 각 문제별 카드
  Widget _buildIncorrectQuestionCard(Map<String, dynamic> question) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 배지 + 화살표
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 난이도 + 카테고리
                Row(
                  children: [
                    // 카테고리 뱃지 (왼쪽)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300), // ✅ border 추가
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        question['category'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 난이도 뱃지 (오른쪽)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(question['difficulty']),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        question['difficulty'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const Icon(LucideIcons.chevronRight, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 16),

            // 질문
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // 내 답변 / 정답
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, //  카드 너비만큼 확장
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "내 답변: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: question['userAnswer'],
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "정답: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        TextSpan(
                          text: question['correctAnswer'],
                          style: const TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 마지막 시도일 + 틀린 횟수
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      question['lastAttempt'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${question['attempts']}회 틀림',
                    style: const TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ),
              ],
            )
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
