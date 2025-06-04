import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/bookmark_service.dart';

class BookmarksTab extends StatefulWidget {
  final int userId;
  final String searchQuery;

  const BookmarksTab({super.key, required this.userId, this.searchQuery = ''});

  @override
  State<BookmarksTab> createState() => _BookmarksTabState();
}

class _BookmarksTabState extends State<BookmarksTab> {
  late Future<List<dynamic>> _bookmarksFuture;
  List<dynamic> _allBookmarks = [];
  List<dynamic> _filteredBookmarks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = BookmarkService.getAllBookmarks(widget.userId).then((
      bookmarks,
    ) {
      _allBookmarks = bookmarks;
      _filteredBookmarks = List.from(bookmarks);
      return bookmarks;
    });
  }

  @override
  void didUpdateWidget(BookmarksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterBookmarks(widget.searchQuery);
    }
  }

  void _filterBookmarks(String keyword) {
    final query = keyword.trim();
    final queryLower = query.toLowerCase();
    setState(() {
      _filteredBookmarks =
          _allBookmarks.where((q) {
            final questionText = q['question'].toString();
            final questionTextLower = questionText.toLowerCase();
            final categoryLabel = getCategoryLabel(q['categoryId'] ?? 0);
            final categoryLabelLower = categoryLabel.toLowerCase();

            return questionText.contains(query) ||
                questionTextLower.contains(queryLower) ||
                categoryLabel.contains(query) ||
                categoryLabelLower.contains(queryLower);
          }).toList();
    });
  }

  Color _getDifficultyColor(String level) {
    switch (level) {
      case '고급':
        return Colors.purple;
      case '중급':
        return Colors.orange;
      case '초급':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String getCategoryLabel(int id) {
    const categories = {
      1: '거시경제학',
      2: '국제경제·무역',
      3: '금융·투자',
      4: '기초 경제 개념',
      5: '미시경제학',
      6: '시사 상식',
      7: '행동경제학',
    };
    return categories[id] ?? '경제학';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _bookmarksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('북마크된 문제가 없습니다.'));
        }

        return ListView(
          padding: const EdgeInsets.all(4),
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildStudySessionCard(),
            const SizedBox(height: 28),
            ..._filteredBookmarks.map((q) => _buildBookmarkCard(q)).toList(),
          ],
        );
      },
    );
  }

  // 검색 바 UI (Row + Expanded + Container)
  Widget _buildSearchBar() {
    return Row(
      children: [
        // 검색 입력창
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _filterBookmarks,
            decoration: InputDecoration(
              hintText: '북마크 검색...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 40,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(width: 12),
        // 필터 버튼
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt, size: 20),
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // 북마크 quick session 카드 (학습 세션) !!!!!
  Widget _buildStudySessionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '학습 세션',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '북마크한 문제를 복습해보세요',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {}, // // 북마크 기반 세션 생성 로직 구현 예정
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('학습 시작'),
            ),
          ],
        ),
      ),
    );
  }

  // 문제별 카드
  Widget _buildBookmarkCard(Map<String, dynamic> question) {
    final String questionText = question['question'] ?? '문제 없음';
    final String bookmarkedDate =
        (question['bookmarkedAt']?.toString().split('T').first) ?? '날짜 없음';
    final int categoryId = question['categoryId'] ?? 0;
    final String categoryLabel = getCategoryLabel(categoryId);

    return InkWell(
      onTap: () {}, // 퀴즈 상세 보기 구현 예정
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 16, 18),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 + 난이도 (가로 정렬)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 난이도 + 카테고리
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: Text(
                        categoryLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const Icon(LucideIcons.chevronRight, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 4),

            // 질문 텍스트
            Text(
              questionText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 8),

            // 북마크 날짜
            Row(
              children: [
                const Icon(LucideIcons.tag, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '북마크: $bookmarkedDate',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
