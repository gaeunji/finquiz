import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_quiz.dart';

class QuizService {
  final String baseUrl;

  QuizService({required this.baseUrl});

  Future<List<TrendingQuiz>> getTrendingQuizzes() async {
    try {
      final response = await http.get(
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
}
