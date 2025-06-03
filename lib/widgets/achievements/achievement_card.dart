import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final UserAchievement? userAchievement;
  final VoidCallback? onTap;
  final bool isSimple; // 프로필 화면에서는 더 심플한 업적 카드 표시

  const AchievementCard({
    Key? key,
    required this.achievement,
    this.userAchievement,
    this.onTap,
    this.isSimple = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSimple) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: achievement.unlocked ? Colors.white : const Color(0xFFF0F0F0),
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
                    color: achievement.unlocked ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  achievement.unlocked ? Colors.white : const Color(0xFFE0E0E0),
            ),
            alignment: Alignment.center,
            child: Text(achievement.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
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
                                colors: [Color(0xFF007AFF), Color(0xFF34C759)],
                              )
                              : const LinearGradient(
                                colors: [Color(0xFFDDDDDD), Color(0xFFDDDDDD)],
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
  }
}
