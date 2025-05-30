import 'dart:convert';
import 'package:http/http.dart' as http;

class WrongQuestionService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<List<Map<String, dynamic>>> fetchWrongQuestions(int userId) async {
    final url = Uri.parse('$baseUrl/wrong-questions/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('틀린 문제 불러오기 실패');
    }
  }
}
