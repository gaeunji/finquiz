import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';
import '../../widgets/achievements/achievement_card.dart';
import 'achievement_detail_screen.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 데이터로 교체
    final achievements = [
      Achievement(
        id: 1,
        title: "경제학 박사",
        description: "100개 퀴즈 완료",
        icon: "0xe0b0", // Icons.emoji_events
        progress: 85,
        unlocked: false,
        color: "#FFD700",
        condition: {"type": "quiz_completion", "count": 100},
      ),
      Achievement(
        id: 2,
        title: "연속 학습왕",
        description: "30일 연속 학습",
        icon: "0xe0b0", // Icons.star
        progress: 100,
        unlocked: true,
        color: "#2196F3",
        condition: {"type": "streak", "days": 30},
      ),
      // ... more achievements
    ];

    final userAchievements = [
      UserAchievement(
        id: 1,
        userId: 123,
        achievementId: 1,
        unlockedAt: DateTime.now(),
        progress: 85,
        isUnlocked: false,
      ),
      UserAchievement(
        id: 2,
        userId: 123,
        achievementId: 2,
        unlockedAt: DateTime.now(),
        progress: 100,
        isUnlocked: true,
      ),
      // ... more user achievements
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        '업적 및 뱃지',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: 전체 보기 화면으로 이동
                    },
                    child: const Text('전체 보기'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    final userAchievement = userAchievements.firstWhere(
                      (ua) => ua.achievementId == achievement.id,
                      orElse:
                          () => UserAchievement(
                            id: 0,
                            userId: 123,
                            achievementId: achievement.id,
                            unlockedAt: DateTime.now(),
                            progress: 0,
                            isUnlocked: false,
                          ),
                    );
                    return AchievementCard(
                      achievement: achievement,
                      userAchievement: userAchievement,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AchievementDetailScreen(
                                  achievement: achievement,
                                  userAchievement: userAchievement,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
