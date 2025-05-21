import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 북마크 아이콘 위젯
class BookmarkIcon extends StatefulWidget {
  final int userId;
  final int questionId;

  const BookmarkIcon({
    super.key,
    required this.userId,
    required this.questionId,
  });

  @override
  State<BookmarkIcon> createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  bool isBookmarked = false; // 현재 북마크 상태
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBookmarkStatus(); // 컴포넌트가 생성될 때 서버에서 북마크 여부 확인하는 용도
  }

  // 현재 이 문제가 북마크되어 있는지 확인하는 함수
  Future<void> fetchBookmarkStatus() async {
    final url =
    Uri.parse('http://10.0.2.2:5000/users/${widget.userId}/bookmarks');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> bookmarks = json.decode(res.body);
        setState(() {
          isBookmarked = bookmarks
              .any((item) => item['questionId'] == widget.questionId);
        });
      }
    } catch (e) {
      print("fetch error: $e");
    }
  }

  // 북마크 상태 토글하는 함수 (추가 <-> 삭제)
  Future<void> toggleBookmark() async {
    setState(() => isLoading = true);
    final url = isBookmarked
        ? Uri.parse(
        'http://10.0.2.2:5000/users/${widget.userId}/bookmarks/${widget.questionId}')
        : Uri.parse(
        'http://10.0.2.2:5000/users/${widget.userId}/bookmarks');

    try {
      final res = isBookmarked
          ? await http.delete(url)
          : await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'questionId': widget.questionId}));

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          isBookmarked = !isBookmarked;
        });
      }
    } catch (e) {
      print("error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 북마크 여부에 따라 UI 변경
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isBookmarked
          ? const Icon(Icons.bookmark, color: Colors.blue)
          : const Icon(Icons.bookmark_border, color: Colors.grey),
      onPressed: isLoading ? null : toggleBookmark,
    );
  }
}
