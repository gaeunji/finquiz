import 'package:flutter/material.dart';

class OverlayCardScreen extends StatelessWidget {
  const OverlayCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // 배경색
      body: Stack(
        children: [
          // 배경 컨텐츠
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF7F9FC),
            ),
          ),

          // 하단 고정 카드
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 상단 아이콘 줄
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.arrow_back_ios, color: Colors.grey),
                      Icon(Icons.bookmark, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 여기부터 콘텐츠
                  const Text(
                    '금융·투자',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '금융·투자 카테고리는 개인과 기업의 자금 운용, 투자 전략, 금융시장과 상품에 대한 이해를 높이는 데 중점을 둡니다. 이 카테고리를 통해 돈의 흐름, 금융기관의 역할, 투자 리스크와 수익률 간의 균형 등에 대해 배울 수 있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
