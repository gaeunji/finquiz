import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';
import 'achievement_card.dart';

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final List<UserAchievement> userAchievements;
  final Function(Achievement) onAchievementTap;

  const AchievementGrid({
    Key? key,
    required this.achievements,
    required this.userAchievements,
    required this.onAchievementTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
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
                unlockedAt: null,
                progress: 0,
                isUnlocked: false,
                achievement: achievement,
              ),
        );
        return AchievementCard(
          achievement: achievement,
          userAchievement: userAchievement,
          onTap: () => onAchievementTap(achievement),
        );
      },
    );
  }
}
