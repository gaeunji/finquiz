import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class WrongQuestionService {
  Future<List<Map<String, dynamic>>> fetchWrongQuestions(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/wrong-questions/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('틀린 문제를 불러오는 데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> createReviewSession(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/quizzes/review/wrong'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('복습 세션 생성에 실패했습니다.');
    }
  }
}
