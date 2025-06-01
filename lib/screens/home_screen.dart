import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../models/category.dart';
import '../data/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/daily_quiz_widget.dart';
import 'trending_quiz_screen.dart';
import '../models/trending_quiz.dart';
import '../widgets/trending_quiz_card.dart';

final List<int> xpData = [40, 30, 60, 20, 70, 50, 80];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _userCategories;
  final List<TrendingQuiz> trendingQuizzes = [
    TrendingQuiz(
      id: 1,
      question: "2025년 한국 경제성장률이 하락할 것으로 전망되는 주요 원인으로 가장 옳은 것은?",
      difficulty: "중급",
      participants: 1520,
      trendingRank: 1,
      category: "거시경제",
      newsTitle: "내수 부진·수출 둔화에 2025년 성장률 하락 전망",
      newsImage:
          "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=200&fit=crop",
      newsUrl: "https://www.yna.co.kr/view/AKR20250514053600002",
      options: [
        "내수와 수출 모두 급격히 증가",
        "내수 부진과 수출 증가세 둔화",
        "정부의 대규모 재정지출",
        "기업 투자 확대와 고용 증가",
      ],
    ),
    TrendingQuiz(
      id: 2,
      question: "트럼프 대통령의 철강 관세 50% 인상이 세계 경제에 미친 영향으로 가장 옳은 것은?",
      difficulty: "초급",
      participants: 2340,
      trendingRank: 2,
      category: "국제경제",
      newsTitle: "미국 철강 관세 인상, 글로벌 무역 불확실성 확대",
      newsImage:
          "https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=400&h=200&fit=crop",
      newsUrl: "https://www.yna.co.kr/view/AKR20250514053600002",
      options: [
        "글로벌 무역이 더욱 자유로워짐",
        "글로벌 무역 불확실성 확대",
        "모든 국가의 성장률이 동반 상승",
        "원자재 가격이 안정적으로 유지",
      ],
    ),
    TrendingQuiz(
      id: 3,
      question: "2025년 한국 민간 소비 증가에 긍정적으로 작용한 요인으로 가장 옳은 것은?",
      difficulty: "중급",
      participants: 980,
      trendingRank: 3,
      category: "금융·투자",
      newsTitle: "금리 인하·정국 불안 완화로 민간 소비 증가 전망",
      newsImage:
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=200&fit=crop",
      newsUrl: "https://www.yna.co.kr/view/AKR20250514053600002",
      options: ["금리 인상", "금리 인하와 정국 불안 완화", "수출 둔화", "가계부채 급증"],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _userCategories = fetchUserCategories();
  }

  // 사용자 카테고리 불러온느 함수
  Future<List<dynamic>> fetchUserCategories() async {
    final userId = '123'; // 임시 사용자 ID
    final url = Uri.parse(
      'http://10.0.2.2:5000/user-categories/$userId/categories',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('카테고리 불러오기 실패');
    }
  }

  void refreshCategories() {
    setState(() {
      _userCategories = fetchUserCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(40, 90, 35, 20),
              height: 210,
              width: double.infinity,
              color: const Color(0xFF005eff),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Johnny',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Great to see you again!',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ],
              ),
            ),

            // My Level Card (overlap effect using Transform.translate)
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                width: 334,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFF344BFD)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My level',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '419 / 1500 XP',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 419 / 1500,
                            color: Color(0XFF344BFD),
                            backgroundColor: Colors.grey[300],
                            strokeWidth: 5,
                          ),
                          const Center(
                            child: Text(
                              '29',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),

            // XP Earned
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 334,

                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:
                            xpData.map((xp) {
                              double height = (xp / 100) * 60;
                              return Container(
                                width: 8,
                                height: height,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF344BFD),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${xpData.reduce((a, b) => a + b)} XP',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Last 7 days',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 연속 학습 일수
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 334,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Color(0xFF344BFD)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '연속 학습 일수',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '188',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF344BFD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: DailyQuizWidget(),
            ),
            const SizedBox(height: 24),

            // 카테고리
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 36),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'My Categories',
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            //       ),
            //       const Spacer(),
            //       IconButton(
            //         icon: const Icon(Icons.add_circle_outline),
            //         onPressed: () async {
            //           final result = await Navigator.pushNamed(
            //             context,
            //             '/all-categories',
            //           );
            //           // 사용자가 AllCategoriesScreen에서 카테고리를 북마크하면,
            //           // 서버에서 최신 사용자 카테고리 목록을 다시 불러옴
            //           if (result == true) {
            //             await Future.delayed(Duration(milliseconds: 100));
            //             refreshCategories();
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 12),
            // FutureBuilder<List<dynamic>>(
            //   future: _userCategories,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     }

            //     if (snapshot.hasError) {
            //       return Center(child: Text('에러: ${snapshot.error}'));
            //     }

            //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return const Center(child: Text('북마크한 카테고리가 없습니다.'));
            //     }

            //     final categories = snapshot.data!;
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 24),
            //       child: Wrap(
            //         spacing: 16,
            //         runSpacing: 16,
            //         children:
            //             categories.map((cat) {
            //               final dynamic rawId = cat['id'];
            //               final dynamic rawLabel = cat['name'];

            //               if (rawId == null || rawLabel == null)
            //                 return const SizedBox();

            //               final int id =
            //                   rawId is String
            //                       ? int.tryParse(rawId) ?? 0
            //                       : rawId as int;
            //               final String label = rawLabel.toString();

            //               return CategoryCard(
            //                 categoryId: id,
            //                 label: label,
            //                 onTap: () {
            //                   Navigator.pushNamed(
            //                     context,
            //                     '/intro',
            //                     arguments: {'id': id},
            //                   );
            //                 },
            //               );
            //             }).toList(),
            //       ),
            //     );
            //   },
            // ),
            // 트렌딩 퀴즈 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_up, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        "트렌딩 퀴즈",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => TrendingQuizListScreen(
                                quizzes: trendingQuizzes,
                              ),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          "전체보기",
                          style: TextStyle(color: Color(0xFF2563EB)),
                        ),
                        Icon(Icons.chevron_right, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            // 트렌딩 퀴즈 개별 카드
            SizedBox(
              height: 200, // 스크롤 뷰 높이
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                scrollDirection: Axis.horizontal,
                itemCount: trendingQuizzes.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 180, // 카드 너비
                    child: TrendingQuizCard(
                      quiz: trendingQuizzes[index],
                      isHorizontal: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => TrendingQuizDetail(
                                  quiz: trendingQuizzes[index],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
