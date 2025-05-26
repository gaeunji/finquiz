import 'package:flutter/material.dart';

class BookmarksTab extends StatelessWidget {
  const BookmarksTab({super.key});

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

    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildStudySessionCard(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: bookmarkedQuestions.length,
            itemBuilder: (context, index) {
              return _buildBookmarkCard(bookmarkedQuestions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: '북마크 검색...',
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('학습 세션',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(height: 4),
                Text('북마크한 문제를 복습해보세요',
                    style: TextStyle(color: Colors.white70, fontSize: 14))
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('학습 시작'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(Map<String, dynamic> question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blue, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildBadge(question['category'], Colors.grey[300]!, Colors.black87),
                          const SizedBox(width: 8),
                          _buildBadge(question['difficulty'], Colors.grey[200]!, Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.blue, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      question['bookmarkedDate'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            if (question['note'] != null) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Text('메모: ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue)),
                    Expanded(
                      child: Text(
                        question['note'],
                        style:
                        const TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.book),
                    label: const Text('학습하기'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('메모 수정'),
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
