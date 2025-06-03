import 'package:flutter/material.dart';

class Achievement {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final int progress;
  final bool unlocked;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.unlocked,
    required this.color,
  });
}

class Friend {
  final String name;
  final int level;
  final int xp;
  final int rank;
  final String avatar;

  Friend({
    required this.name,
    required this.level,
    required this.xp,
    required this.rank,
    required this.avatar,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;
  bool darkMode = false;
  bool soundEffects = true;

  final List<Achievement> achievements = [
    Achievement(
      id: 1,
      title: "경제학 박사",
      description: "100개 퀴즈 완료",
      icon: Icons.emoji_events,
      progress: 85,
      unlocked: false,
      color: Colors.amber,
    ),
    Achievement(
      id: 2,
      title: "연속 학습왕",
      description: "30일 연속 학습",
      icon: Icons.star,
      progress: 100,
      unlocked: true,
      color: Colors.blue,
    ),
    Achievement(
      id: 3,
      title: "완벽주의자",
      description: "10개 퀴즈 만점",
      icon: Icons.military_tech,
      progress: 60,
      unlocked: false,
      color: Colors.purple,
    ),
    Achievement(
      id: 4,
      title: "전 분야 마스터",
      description: "모든 카테고리 완료",
      icon: Icons.workspace_premium,
      progress: 50,
      unlocked: false,
      color: Colors.orange,
    ),
  ];

  final List<Friend> friends = [
    Friend(name: "김사라", level: 15, xp: 3250, rank: 1, avatar: "👩"),
    Friend(name: "이민수", level: 12, xp: 2450, rank: 2, avatar: "👨"),
    Friend(name: "나", level: 12, xp: 2450, rank: 3, avatar: "👤"),
    Friend(name: "박지영", level: 11, xp: 2100, rank: 4, avatar: "👩‍🦰"),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            // 프로필 헤더
            Container(
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
                  // 프로필 사진 + 이름/레벨
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 사진
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(width: 16),
                      // 사용자 이름 + 레벨/칭호
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Johnny",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "레벨 12 · 금융 마스터",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 84, 84, 84),
                            ),
                          ),
                        ],
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

            SizedBox(height: 24),

            // 학습 통계 요약 카드
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 4),
                  child: Text(
                    "학습 요약",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff333B69),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: stats.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.8,
                            crossAxisSpacing: 1.8,
                            mainAxisSpacing: 2,
                          ),
                      itemBuilder: (context, index) {
                        final item = stats[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey[200]!),
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
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // 설정
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "설정",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.notifications,
                      title: "푸시 알림",
                      subtitle: "일일 리마인더 및 성취 알림",
                      value: pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          pushNotifications = value;
                        });
                      },
                    ),
                    Divider(),
                    _buildSettingItem(
                      icon: Icons.dark_mode,
                      title: "다크 모드",
                      subtitle: "어두운 테마로 전환",
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    ),
                    Divider(),
                    _buildSettingItem(
                      icon: Icons.volume_up,
                      title: "효과음",
                      subtitle: "상호작용 시 오디오 피드백",
                      value: soundEffects,
                      onChanged: (value) {
                        setState(() {
                          soundEffects = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // 액션 버튼
            Column(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                  label: Text("앱 설정"),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: Text("로그아웃", style: TextStyle(color: Colors.red[600])),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red[200]!),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
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
