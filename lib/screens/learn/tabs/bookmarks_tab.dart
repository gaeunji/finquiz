import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookmarksTab extends StatelessWidget {
  const BookmarksTab({super.key});

  Color _getDifficultyColor(String level) {
    switch (level) {
      case '고급':
        return Colors.purple;
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
    final List<Map<String, dynamic>> bookmarkedQuestions = [
      {
        'id': 4,
        'question': '기회비용의 개념을 설명하세요',
        'category': '미시경제학',
        'difficulty': '초급',
        'bookmarkedDate': '1주 전',
        'note': '선택의 트레이드오프 이해에 중요',
      },
      {
        'id': 5,
        'question': '양적완화는 어떻게 작동하나요?',
        'category': '거시경제학',
        'difficulty': '고급',
        'bookmarkedDate': '3일 전',
        'note': '복잡한 통화정책 도구',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(4),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildStudySessionCard(),
        const SizedBox(height: 28),
        ...bookmarkedQuestions.map((q) => _buildBookmarkCard(q)).toList(),
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
              hintText: '북마크 검색...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
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

  // 북마크 quick session 카드 (학습 세션) !!!!!
  Widget _buildStudySessionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
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
                  '학습 세션',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '북마크한 문제를 복습해보세요',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('학습 시작'),
            ),
          ],
        ),
      ),
    );
  }

  // 문제별 카드
  Widget _buildBookmarkCard(Map<String, dynamic> question) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 + 난이도 (가로 정렬)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 난이도 + 카테고리
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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

            // 질문 텍스트
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

            // 북마크 날짜
            Row(
              children: [
                const Icon(LucideIcons.tag, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '북마크: ${question['bookmarkedDate']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
