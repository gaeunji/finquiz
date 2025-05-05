import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '📌 북마크한 문제',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildQuizCard('시장 경제의 정의는?'),
          _buildQuizCard('GDP와 GNP의 차이점은?'),

          const SizedBox(height: 30),
          const Text(
            '❌ 내가 틀린 문제',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildQuizCard('수요법칙은 어떤 상황에서 예외가 될 수 있을까?'),
          _buildQuizCard('인플레이션의 원인은 무엇일까?'),
        ],
      ),
    );
  }

  Widget _buildQuizCard(String question) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.quiz, color: Color(0xFF344BFD)),
        title: Text(question),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 향후 문제 상세 페이지로 이동
        },
      ),
    );
  }
}
