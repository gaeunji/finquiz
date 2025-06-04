import 'dart:convert';
import 'package:http/http.dart' as http;

class Achievement {
  final int id;
  final String title;
  final String description;
  final String targetType;
  final int targetValue;
  final DateTime createdAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.targetType,
    required this.targetValue,
    required this.createdAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      targetType: map['target_type'] as String,
      targetValue: map['target_value'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_type': targetType,
      'target_value': targetValue,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class UserAchievement {
  final int userId;
  final int achievementId;
  int progress;
  bool unlocked;
  DateTime? unlockedAt;

  UserAchievement({
    required this.userId,
    required this.achievementId,
    this.progress = 0,
    this.unlocked = false,
    this.unlockedAt,
  });

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      userId: map['user_id'] as int,
      achievementId: map['achievement_id'] as int,
      progress: map['progress'] as int,
      unlocked: map['unlocked'] as bool,
      unlockedAt:
          map['unlocked_at'] != null
              ? DateTime.parse(map['unlocked_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'achievement_id': achievementId,
      'progress': progress,
      'unlocked': unlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }
}

class AchievementParser {
  static const String baseUrl =
      'https://your-api-server.com/api'; // API 서버 URL을 적절히 변경하세요

  static bool evaluateCondition(
    Achievement achievement,
    Map<String, dynamic> userData,
  ) {
    switch (achievement.targetType) {
      case 'quiz_completed':
        return userData['quiz_completed_count'] >= achievement.targetValue;
      case 'correct_answers':
        return userData['correct_answers_count'] >= achievement.targetValue;
      case 'streak_days':
        return userData['current_streak'] >= achievement.targetValue;
      default:
        return false;
    }
  }

  static int calculateProgress(
    Achievement achievement,
    Map<String, dynamic> userData,
  ) {
    switch (achievement.targetType) {
      case 'quiz_completed':
        return (userData['quiz_completed_count'] *
                100 /
                achievement.targetValue)
            .round();
      case 'correct_answers':
        return (userData['correct_answers_count'] *
                100 /
                achievement.targetValue)
            .round();
      case 'streak_days':
        return (userData['current_streak'] * 100 / achievement.targetValue)
            .round();
      default:
        return 0;
    }
  }

  static Future<void> updateUserAchievement(
    int userId,
    Achievement achievement,
    Map<String, dynamic> userData,
  ) async {
    final progress = calculateProgress(achievement, userData);
    final isUnlocked = evaluateCondition(achievement, userData);

    final response = await http.post(
      Uri.parse('$baseUrl/achievements/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'achievement': achievement.toMap(),
        'progress': progress,
        'unlocked': isUnlocked,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('업적 업데이트 실패: ${response.body}');
    }
  }

  static Future<List<Achievement>> getUserAchievements(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/achievements/user/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('업적을 불러오는 데 실패했습니다: ${response.body}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Achievement.fromMap(json)).toList();
  }

  static Future<List<UserAchievement>> getUserAchievementProgress(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/achievements/progress/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('진행도를 불러오는 데 실패했습니다: ${response.body}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => UserAchievement.fromMap(json)).toList();
  }
}
