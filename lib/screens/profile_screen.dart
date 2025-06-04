import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/user_achievement.dart';
import '../widgets/achievements/achievement_card.dart';
import 'achievements/achievement_detail_screen.dart';
import 'achievements/achievements_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;
  bool darkMode = false;
  bool soundEffects = true;
  bool isLoading = true;
  String username = '';
  int level = 1;
  int xp = 0;
  int currentLevelXp = 0;
  int xpToNextLevel = 0;
  int progressPercent = 0;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      const userId = 123; // TODO: 실제 사용자 ID로 교체 필요

      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/users/$userId/info'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          username = data['username'] ?? '';
          level = data['level'] ?? 1;
          xp = data['xp'] ?? 0;
          currentLevelXp = data['currentLevelXp'] ?? 0;
          xpToNextLevel = data['xpToNextLevel'] ?? 100;
          progressPercent = data['progressPercent'] ?? 0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<Achievement> achievements = [
    Achievement(
      id: 1,
      title: "초보 투자자",
      description: "첫 10문제 정답",
      icon: "💰",
      progress: 1.0,
      unlocked: true,
      color: "#FFD700",
      condition: {"type": "quiz_completion", "count": 10},
    ),
    Achievement(
      id: 2,
      title: "경제 분석가",
      description: "50문제 연속 정답",
      icon: "📊",
      progress: 0.6,
      unlocked: false,
      color: "#2196F3",
      condition: {"type": "perfect_quizzes", "count": 50},
    ),
    Achievement(
      id: 3,
      title: "주식 마스터",
      description: "주식 분야 100% 정답",
      icon: "📈",
      progress: 0.25,
      unlocked: false,
      color: "#9C27B0",
      condition: {"type": "category_completion", "category": "stock"},
    ),
    Achievement(
      id: 4,
      title: "금융 전문가",
      description: "모든 카테고리 우수",
      icon: "🏦",
      progress: 0.1,
      unlocked: false,
      color: "#FF9800",
      condition: {"type": "category_completion", "count": 10},
    ),
    Achievement(
      id: 5,
      title: "경제학 박사",
      description: "1000문제 돌파",
      icon: "🎓",
      progress: 0.05,
      unlocked: false,
      color: "#4CAF50",
      condition: {"type": "quiz_completion", "count": 1000},
    ),
    Achievement(
      id: 6,
      title: "월스트리트 킹",
      description: "최상위 랭커 달성",
      icon: "👑",
      progress: 0.01,
      unlocked: false,
      color: "#E91E63",
      condition: {"type": "ranking", "position": 1},
    ),
  ];

  final stats = [
    {
      "icon": Icons.local_fire_department,
      "color": Colors.orange,
      "value": "188",
      "label": "Day streak",
    },
    {
      "icon": Icons.check_circle_outline,
      "color": Colors.green,
      "value": "72",
      "label": "완료 퀴즈",
    },
    {
      "icon": Icons.star_border,
      "color": Colors.amber,
      "value": "14",
      "label": "획득 뱃지",
    },
    {
      "icon": Icons.timer_outlined,
      "color": Colors.blue,
      "value": "32h",
      "label": "누적 시간",
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          'Hello, $username',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@ $username",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "레벨 $level · 금융 마스터",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF545454),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 자기소개 입력창
                    TextField(
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Hello World !",
                        hintStyle: const TextStyle(fontSize: 13),
                        suffixIcon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 18,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F8FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),

                    // 팔로워 / 팔로잉
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "6 ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "followers",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(text: " · "),
                          TextSpan(
                            text: "8 ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "following",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 학습 통계 요약 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "학습 요약",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff333B69),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: stats.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.8,
                          crossAxisSpacing: 1.8,
                          mainAxisSpacing: 3.2,
                        ),
                    itemBuilder: (context, index) {
                      final item = stats[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 212, 212, 212)!,
                          ),
                        ),
                        elevation: 0,
                        color: const Color(0xFFF9FAFB),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                item["icon"] as IconData,
                                color: item["color"] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["value"] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item["label"] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 업적 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '업적',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333B69),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AchievementsScreen(),
                            ),
                          );
                        },
                        child: const Text('전체 보기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 16),
                          child: AchievementCard(
                            achievement: achievement,
                            userAchievement: null,
                            isSimple: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AchievementDetailScreen(
                                        achievement: achievement,
                                        userAchievement: null,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
