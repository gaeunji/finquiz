import '../models/achievement.dart';
import '../models/user_achievement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AchievementService {
  final String baseUrl;

  AchievementService({required this.baseUrl});

  Future<List<UserAchievement>> getUserAchievements(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/achievements/user/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          final achievementData = <String, dynamic>{
            ...json as Map<String, dynamic>,
            'id': json['id'],
            'user_id': userId,
            'achievement_id': json['id'],
            'progress': json['progress'] ?? 0,
            'unlocked': json['unlocked'] ?? false,
            'unlocked_at': json['unlockedAt'],
          };
          return UserAchievement.fromJson(achievementData);
        }).toList();
      } else {
        throw Exception(
          'Failed to load achievements: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load achievements: $e');
    }
  }

  Future<void> evaluateConditions(int userId) async {
    // Implementation
  }

  Future<void> unlockAchievement(int userId, int achievementId) async {
    // Implementation
  }

  // 모든 업적 목록 조회
  Future<List<Achievement>> getAllAchievements() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/achievements'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Achievement.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load achievements');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 단일 업적 업데이트
  Future<Achievement> updateUserAchievement({
    required int userId,
    required int achievementId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/achievements/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'achievementId': achievementId,
          'userData': userData,
        }),
      );

      if (response.statusCode == 200) {
        return Achievement.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('업적 업데이트 실패');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 모든 업적 업데이트
  Future<List<Achievement>> updateAllUserAchievements({
    required int userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/achievements/update-all'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'userData': userData}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> achievementsData = responseData['achievements'];
        return achievementsData.map((json) {
          print('Processing achievement data: $json');
          return Achievement.fromMap(json);
        }).toList();
      } else {
        throw Exception(
          '업적 업데이트 실패패: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error updating achievements: $e');
      throw Exception('업적 업데이트 실패: $e');
    }
  }
}
