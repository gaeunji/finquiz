import 'achievement.dart';

class UserAchievement {
  final int id;
  final int userId;
  final int achievementId;
  final DateTime? unlockedAt;
  final int progress;
  final bool isUnlocked;
  final Achievement achievement;

  UserAchievement({
    required this.id,
    required this.userId,
    required this.achievementId,
    this.unlockedAt,
    required this.progress,
    required this.isUnlocked,
    required this.achievement,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    // achievement 필드가 없는 경우, json 자체를 achievement로 사용
    final achievementData = json['achievement'] ?? json;

    return UserAchievement(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      achievementId: json['achievement_id'] as int,
      unlockedAt:
          json['unlocked_at'] != null
              ? DateTime.parse(json['unlocked_at'] as String)
              : null,
      progress: json['progress'] as int? ?? 0,
      isUnlocked: json['unlocked'] as bool? ?? false,
      achievement: Achievement.fromMap(achievementData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'achievement_id': achievementId,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'progress': progress,
      'unlocked': isUnlocked,
      ...achievement.toMap(),
    };
  }
}
