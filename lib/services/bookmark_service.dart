import 'dart:convert';
import 'package:http/http.dart' as http;

class BookmarkService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  // 특정 문제에 대해 북마크 상태 확인
  static Future<bool> isBookmarked(int userId, int questionId) async {
    final url = Uri.parse(
      '$baseUrl/user-bookmarks/$userId/bookmarks/$questionId',
    );
    final response = await http.get(url);
    return response.statusCode == 200;
  }

  // 북마크 추가
  static Future<bool> addBookmark(int userId, int questionId) async {
    final url = Uri.parse('$baseUrl/user-bookmarks/$userId/bookmarks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'questionId': questionId}),
    );
    return response.statusCode == 201;
  }

  // 북마크 제거
  static Future<bool> removeBookmark(int userId, int questionId) async {
    final url = Uri.parse(
      '$baseUrl/user-bookmarks/$userId/bookmarks/$questionId',
    );
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  // 사용자의 모든 북마크 조회
  static Future<List<dynamic>> getAllBookmarks(int userId) async {
    final url = Uri.parse('$baseUrl/user-bookmarks/$userId/bookmarks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('북마크를 불러오는 데 실패했습니다.'); // 이 부분에서 예외 발생 가능
    }
  }
}
