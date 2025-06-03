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
import '../models/user_info.dart';
import '../models/weekly_xp.dart';

final List<int> xpData = [40, 30, 60, 20, 70, 50, 80];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _userCategories;
  late Future<UserInfo> _userInfo;
  late Future<WeeklyXp> _weeklyXp;

  // 사용자 정보 불러오기
  Future<UserInfo> fetchUserInfo() async {
    final userId = '123'; // 임시 사용자 ID
    try {
      debugPrint('Fetching user info for userId: $userId');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/users/$userId/info'),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint('Parsed JSON data: $jsonData');
        final userInfo = UserInfo.fromJson(jsonData);
        debugPrint(
          'Created UserInfo object: ${userInfo.username}, Level: ${userInfo.level}',
        );
        return userInfo;
      } else {
        debugPrint(
          'Failed to fetch user info. Status code: ${response.statusCode}',
        );
        throw Exception('사용자 정보 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
      throw Exception('사용자 정보 불러오기 실패: $e');
    }
  }

  // 트렌딩 퀴즈 불러오기
  Future<List<TrendingQuiz>> fetchTrendingQuizzes() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/quizzes/trending'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        debugPrint('Server response: $data');
        return data.map((q) {
          debugPrint('Processing quiz: $q');
          return TrendingQuiz.fromJson(q);
        }).toList();
      } else {
        debugPrint('Server error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('트렌딩 퀴즈 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching trending quizzes: $e');
      throw Exception('트렌딩 퀴즈 불러오기 실패: $e');
    }
  }

  // 주간 XP 데이터 불러오기
  Future<WeeklyXp> fetchWeeklyXp() async {
    final userId = '123'; // 임시 사용자 ID
    try {
      debugPrint('Fetching weekly XP for userId: $userId');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/users/$userId/weekly-xp'),
      );

      debugPrint('Weekly XP response status code: ${response.statusCode}');
      debugPrint('Weekly XP response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint('Parsed weekly XP data: $jsonData');
        return WeeklyXp.fromJson(jsonData);
      } else {
        debugPrint(
          'Failed to fetch weekly XP. Status code: ${response.statusCode}',
        );
        throw Exception('주간 XP 데이터 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching weekly XP: $e');
      throw Exception('주간 XP 데이터 불러오기 실패: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _userCategories = fetchUserCategories();
    _userInfo = fetchUserInfo();
    _weeklyXp = fetchWeeklyXp();
  }

  // 사용자 카테고리 불러오는 함수
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
                        FutureBuilder<UserInfo>(
                          future: _userInfo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error loading user info',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Text(
                              'Hello, ${snapshot.data?.username ?? "User"}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        const Text(
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
                child: FutureBuilder<UserInfo>(
                  future: _userInfo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('사용자 정보를 가져오는 데 실패했습니다.'),
                      );
                    }

                    final userInfo = snapshot.data!;
                    return Row(
                      children: [
                        const Icon(Icons.stars, color: Color(0xFF344BFD)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'My level',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${userInfo.currentLevelXp} / ${userInfo.xpToNextLevel} XP',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
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
                                value: userInfo.progressPercent / 100,
                                color: const Color(0XFF344BFD),
                                backgroundColor: Colors.grey[300],
                                strokeWidth: 5,
                              ),
                              Center(
                                child: Text(
                                  '${userInfo.level}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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
                child: FutureBuilder<WeeklyXp>(
                  future: _weeklyXp,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('주간 XP 데이터를 가져오는 데 실패했습니다.'),
                      );
                    }

                    final weeklyXp = snapshot.data!;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:
                                weeklyXp.dailyXp.map((dailyXp) {
                                  // 최소 높이 3px, 최대 높이 60px로 제한
                                  double height =
                                      dailyXp.xp > 0
                                          ? (dailyXp.xp / 100 * 60).clamp(3, 60)
                                          : 3;
                                  return Container(
                                    width: 8,
                                    height: height,
                                    decoration: BoxDecoration(
                                      color:
                                          dailyXp.xp > 0
                                              ? const Color(0xFF344BFD)
                                              : const Color(0xFFE0E0E0),
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
                              '${weeklyXp.totalXp} XP',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Last 7 days',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
                    onPressed: () async {
                      final trendingQuizzes = await fetchTrendingQuizzes();
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
            FutureBuilder<List<TrendingQuiz>>(
              future: fetchTrendingQuizzes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('트렌딩 퀴즈가 없습니다.');
                }

                final trendingQuizzes = snapshot.data!.take(3).toList();

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingQuizzes.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 180,
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
                );
              },
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
