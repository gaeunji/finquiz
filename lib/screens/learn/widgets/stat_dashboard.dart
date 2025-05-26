import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart'; // 아이콘 예시

class StatDashboard extends StatelessWidget {
  const StatDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // childAspectRatio: 0.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _StatCard(
          icon: LucideIcons.alertCircle,
          trailing: Text("!", style: TextStyle(fontWeight: FontWeight.bold)),
          value: "23",
          label: "틀린 문제",
          gradient: LinearGradient(colors: [Color(0xfffa4872), Color(0xffeb5967)]),
        ),
        _StatCard(
          icon: LucideIcons.bookmark,
          trailingIcon: LucideIcons.star,
          value: "12",
          label: "북마크",
          gradient: LinearGradient(colors: [Colors.blue, Colors.cyan]),
        ),
        _StatCard(
          icon: LucideIcons.trendingDown,
          trailingIcon: LucideIcons.target,
          value: "3",
          label: "약점 영역",
          gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Widget? trailing;
  final IconData? trailingIcon;
  final String value;
  final String label;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    this.trailing,
    this.trailingIcon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Container( // 틀린 문제, 북마크, 약점 영역
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // overflow 방지
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 12, color: Colors.white),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child:
                        trailing ??
                            Icon(trailingIcon, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 4,
            right: 5,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
