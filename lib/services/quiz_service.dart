import 'dart:convert';
import '../models/trending_quiz.dart';
import 'http_client.dart';

class QuizService {
  final String baseUrl;
  final LoggingHttpClient _client = LoggingHttpClient();

  QuizService({required this.baseUrl});

  Future<List<TrendingQuiz>> getTrendingQuizzes() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/trending-quizzes'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TrendingQuiz.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending quizzes');
      }
    } catch (e) {
      throw Exception('Error fetching trending quizzes: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
