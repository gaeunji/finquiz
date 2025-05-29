import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'widgets/stat_dashboard.dart';
import 'widgets/review_tab_bar.dart';
import 'tabs/wrong_quiz_tab.dart';
import 'tabs/bookmarks_tab.dart';
import '/services/bookmark_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  int _activeIndex = 0;
  final int userId = 123;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _activeIndex = _tabController.index;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 여기에 헤더 추가?
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 92, 20, 30),
            color: const Color(0xFF005eff), // 파란 배경색
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '복습 센터',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  '약점을 보완하고 실력을 향상시키세요.',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),

          // 나머지 콘텐츠
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // const StatDashboard(),
                  // const SizedBox(height: 24),

                  // 탬 바
                  ReviewTabBar(
                    tabController: _tabController,
                    activeIndex: _activeIndex,
                  ),
                  const SizedBox(height: 5),

                  // 탭 뷰
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        WrongQuizTab(),
                        BookmarksTab(userId: userId),
                        Center(
                          child: Text("업데이트 예정"),
                        ), // // 추후 WeakAreasTab()로 구현하기
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
