import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('학습'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '오답 복습',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '틀린 문제 다시 풀기',
            description: '이전에 틀린 문제들을 복습합니다.',
            icon: Icons.replay,
            onTap: () {
              Navigator.pushNamed(context, '/review-wrong');
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '북마크 퀴즈',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '내가 저장한 퀴즈',
            description: '중요하다고 표시한 퀴즈들을 다시 풀어볼 수 있어요.',
            icon: Icons.bookmark,
            onTap: () {
              Navigator.pushNamed(context, '/bookmarks');
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '약한 영역',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '정답률이 낮은 카테고리 복습',
            description: '나에게 어려운 분야를 집중적으로 학습해요.',
            icon: Icons.warning_amber,
            onTap: () {
              Navigator.pushNamed(context, '/weak-areas');
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '복습 노트',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '개념 메모 보기',
            description: '중요한 개념이나 내용을 정리한 메모를 확인해요.',
            icon: Icons.note_alt,
            onTap: () {
              Navigator.pushNamed(context, '/review-notes');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
