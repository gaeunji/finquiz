import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';
import '../../widgets/achievements/achievement_card.dart';
import 'achievement_detail_screen.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievements = [
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "🏆 업적",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: GridView.builder(
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    achievement.unlocked
                        ? Colors.white
                        : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      achievement.unlocked
                          ? const Color(0xFF007AFF)
                          : const Color(0xFFF0F0F0),
                  width: achievement.unlocked ? 2 : 1,
                ),
                boxShadow: [
                  if (achievement.unlocked)
                    const BoxShadow(
                      color: Color(0x29007AFF),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  if (!achievement.unlocked)
                    const BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            achievement.unlocked
                                ? const Color(0xFF34C759)
                                : const Color(0xFFF0F0F0),
                      ),
                      child: Center(
                        child: Text(
                          achievement.unlocked ? "✓" : "🔒",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                achievement.unlocked
                                    ? Colors.white
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          achievement.unlocked
                              ? Colors.white
                              : const Color(0xFFE0E0E0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      achievement.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          achievement.unlocked
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFF999999),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          achievement.unlocked
                              ? const Color(0xFF666666)
                              : const Color(0xFFAAAAAA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (achievement.progress > 0)
                        FractionallySizedBox(
                          widthFactor: achievement.progress,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient:
                                  achievement.unlocked
                                      ? const LinearGradient(
                                        colors: [
                                          Color(0xFF007AFF),
                                          Color(0xFF34C759),
                                        ],
                                      )
                                      : const LinearGradient(
                                        colors: [
                                          Color(0xFFDDDDDD),
                                          Color(0xFFDDDDDD),
                                        ],
                                      ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
