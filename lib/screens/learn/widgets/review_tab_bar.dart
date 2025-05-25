import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReviewTabBar extends StatelessWidget {
  final TabController tabController;
  final int activeIndex; // setState()로 관리

  const ReviewTabBar({
    super.key,
    required this.tabController,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      child: TabBar(
        controller: tabController,
        indicator: const BoxDecoration(), // 인디케이터 제거 (배경 스타일로 대체)
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelPadding: EdgeInsets.zero,
        tabs: [
          _buildGradientTab(
            icon: LucideIcons.xCircle,
            text: "틀린 문제",
            gradient: const LinearGradient(colors: [Colors.red, Colors.pink]),
            isActive: activeIndex == 0,
          ),
          _buildGradientTab(
            icon: LucideIcons.bookmark,
            text: "북마크",
            gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
            isActive: activeIndex == 1,
          ),
          _buildGradientTab(
            icon: LucideIcons.brain,
            text: "약점 영역",
            gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
            isActive: activeIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientTab({
    required IconData icon,
    required String text,
    required Gradient gradient,
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isActive ? gradient : null,
        color: isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
                : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isActive ? Colors.white : Colors.grey),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
