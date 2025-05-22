import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// 북마크 타입 분기: 문제 vs 카테고리
enum BookmarkType { question, category }

// 북마크 아이콘 위젯
class BookmarkIcon extends StatefulWidget {
  final int userId;
  final int targetId; // questionId 또는 categoryId
  final BookmarkType type;
  final VoidCallback? onChanged;

  const BookmarkIcon({
    super.key,
    required this.userId,
    required this.targetId,
    required this.type,
    this.onChanged,
  });


  @override
  State<BookmarkIcon> createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  bool isBookmarked = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBookmarkStatus();
  }

  String get baseUrl {
    switch (widget.type) {
      case BookmarkType.question:
        return 'http://10.0.2.2:5000/user-bookmarks/${widget.userId}/bookmarks';
      case BookmarkType.category:
        return 'http://10.0.2.2:5000/user-categories/${widget.userId}/categories';
    }
  }

  // 해당 문제/카테고리가 북마크되어 있는지 확인하는 함수
  Future<void> fetchBookmarkStatus() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List<dynamic> bookmarks = json.decode(res.body);
        setState(() {
          isBookmarked = bookmarks.any((item) =>
          (widget.type == BookmarkType.question ? item['questionId'] : item['categoryId']) == widget.targetId);
        });
      }
    } catch (e) {
      print("북마크 상태 조회 오류: $e");
    }
  }

  // 북마크 상태 토글하는 함수 (추가 <-> 삭제)
  Future<void> toggleBookmark() async {
    setState(() => isLoading = true);

    final isDeleting = isBookmarked;
    final uri = Uri.parse(
        '$baseUrl/${isDeleting ? widget.targetId : ''}'.replaceAll(RegExp(r'\/+$'), ''));

    try {
      final res = isDeleting
          ? await http.delete(uri)
          : await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          widget.type == BookmarkType.question
              ? 'questionId'
              : 'categoryId': widget.targetId,
        }),
      );
      print("북마크 응답 코드: ${res.statusCode}");
      print("응답 내용: ${res.body}");

      if ([200, 201, 204].contains(res.statusCode)) {
        setState(() => isBookmarked = !isBookmarked);
        widget.onChanged?.call();
      } else {
        print("북마크 실패: ${res.statusCode}, ${res.body}");
      }
    } catch (e) {
      print("북마크 토글 오류: $e");
    } finally {
      setState(() => isLoading = false);
    }


  }

  // 북마크 여부에 따라 UI 변경
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isBookmarked
          ? const Icon(Icons.bookmark, color: Colors.grey)
          : const Icon(Icons.bookmark_border, color: Colors.grey),
      onPressed: isLoading ? null : toggleBookmark,
    );
  }
}
