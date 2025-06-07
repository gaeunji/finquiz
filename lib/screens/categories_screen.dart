import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final int quizCount;
  final int progress;
  final List<Color> gradientColors;
  final Color bgColor;
  final Color textColor;

  Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.quizCount,
    required this.progress,
    required this.gradientColors,
    required this.bgColor,
    required this.textColor,
  });
}

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  static final List<Category> categories = [
    Category(
      id: "basic-economics",
      title: "기초 경제 개념",
      subtitle: "수요·공급, 시장구조",
      icon: "📊",
      quizCount: 132,
      progress: 90,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      bgColor: Color(0xFFfcf7ff), // 보라
      textColor: Color(0xFF6D28D9),
    ),
    Category(
      id: "macroeconomics",
      title: "거시경제학",
      subtitle: "GDP, 인플레이션, 통화정책",
      icon: "🏛️",
      quizCount: 145,
      progress: 75,
      gradientColors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      bgColor: Color(0xFFe4f1f5), // 하늘
      textColor: Color(0xFF1D4ED8),
    ),
    Category(
      id: "international-trade",
      title: "국제경제·무역",
      subtitle: "환율, 무역수지, 글로벌 경제",
      icon: "🌐",
      quizCount: 118,
      progress: 30,
      gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
      bgColor: Color(0xFFf0faf0), // 연두
      textColor: Color(0xFF047857),
    ),
    Category(
      id: "finance",
      title: "금융·투자",
      subtitle: "주식, 채권, 투자 전략",
      icon: "💰",
      quizCount: 156,
      progress: 45,
      gradientColors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
      bgColor: Color(0xFFfefff2), // 연노랑
      textColor: Color(0xFFD97706),
    ),
    Category(
      id: "microeconomics",
      title: "미시경제학",
      subtitle: "소비자 이론, 기업 이론",
      icon: "🔍",
      quizCount: 124,
      progress: 60,
      gradientColors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      bgColor: Color(0xFFfff5f2), // 다홍
      textColor: Color(0xFFB91C1C),
    ),
    Category(
      id: "current-affairs",
      title: "시사 상식",
      subtitle: "최신 경제 뉴스와 동향",
      icon: "📰",
      quizCount: 89,
      progress: 20,
      gradientColors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      bgColor: Color(0xFFe6f8fc), // 하늘
      textColor: Color(0xFF0891B2),
    ),
    Category(
      id: "behavioral-economics",
      title: "행동경제학",
      subtitle: "심리학과 경제학의 융합",
      icon: "🧠",
      quizCount: 98,
      progress: 0,
      gradientColors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
      bgColor: Color(0xFFf5f2f5), // 연분홍
      textColor: Color(0xFFBE185D),
    ),
  ];

  int _mapCategoryId(String id) {
    final Map<String, int> categoryMap = {
      'basic-economics': 4,
      'macroeconomics': 1,
      'microeconomics': 5,
      'international-trade': 2,
      'finance': 3,
      'current-affairs': 6,
      'behavioral-economics': 7,
    };
    return categoryMap[id] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // 헤더
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 2, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      '관심 있는 경제 분야를 선택해서 학습해보세요',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              // 카테고리 리스트
              Column(
                children:
                    categories
                        .map(
                          (category) => _buildCategoryCard(context, category),
                        )
                        .toList(),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 상단 헤더 + 정보 + 진행률 바 → 상세 설명(intro) 화면으로 이동
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/intro',
                arguments: {
                  'id': _mapCategoryId(category.id),
                }, // Map<String, dynamic>
              );
            },
            // borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                // 상단 헤더
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: category.bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 기타 장식용
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        left: -4,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // 콘텐츠
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: category.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: category.gradientColors[0].withAlpha(
                                    76,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                category.icon,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  category.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 하단 정보
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 통계 정보
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: category.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${category.quizCount}개",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: category.textColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "진행률 ${category.progress}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // 진행률 바
                      Container(
                        width: double.infinity,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor:
                                  category.progress /
                                  100.0, // widthFactor: 진행률만큼 진행바 너비 설정
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: category.gradientColors,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // 학습하기 버튼 + 상세 보기(정보) 버튼
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: category.gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: category.gradientColors[0].withAlpha(
                                      76,
                                    ),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    // 학습하기 버튼 누르면 바로 퀴즈 시작
                                    final url = Uri.parse(
                                      'http://10.0.2.2:5000/quizzes/session',
                                    );
                                    final response = await http.post(
                                      url,
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body: json.encode({
                                        'categoryId': _mapCategoryId(
                                          category.id,
                                        ),
                                        'userId': 123, // 사용자 ID!~!!!!!!
                                      }),
                                    );

                                    if (response.statusCode == 201) {
                                      final data = json.decode(response.body);
                                      Navigator.pushNamed(
                                        context,
                                        '/quiz',
                                        arguments: {
                                          'sessionId': data['sessionId'],
                                          'quizIds': List<int>.from(
                                            data['quizIds'],
                                          ),
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "세션 생성 실패: ${response.body}",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "학습하기",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap:
                                    () => print("${category.title} 상세 정보 보기"),
                                borderRadius: BorderRadius.circular(8),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF6B7280),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 하단 빠른 액션 카드
  Widget _buildQuickActionCard({
    required String icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required List<Color> bgColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: bgColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(icon, style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
