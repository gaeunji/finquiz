import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final UserAchievement? userAchievement;
  final bool isSimple;
  final VoidCallback? onTap;

  const AchievementCard({
    Key? key,
    required this.achievement,
    this.userAchievement,
    this.isSimple = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.unlocked ?? false;
    final progress = achievement.progress ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isUnlocked ? const Color(0xFF007AFF) : const Color(0xFFF0F0F0),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: [
            if (isUnlocked)
              const BoxShadow(
                color: Color(0x29007AFF),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            if (!isUnlocked)
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
                      isUnlocked
                          ? const Color(0xFF34C759)
                          : const Color(0xFFF0F0F0),
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? "✓" : "🔒",
                    style: TextStyle(
                      fontSize: 12,
                      color: isUnlocked ? Colors.white : Colors.grey,
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
                color: isUnlocked ? Colors.white : const Color(0xFFE0E0E0),
              ),
              alignment: Alignment.center,
              child: Text(
                achievement.icon ?? '🏆',
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
                    isUnlocked
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
                    isUnlocked
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
                if (progress > 0)
                  FractionallySizedBox(
                    widthFactor: progress / 100,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient:
                            isUnlocked
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
      ),
    );
  }
}
