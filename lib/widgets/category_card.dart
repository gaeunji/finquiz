import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int categoryId;
  final String label;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryId,
    required this.label,
    required this.onTap,
  });

  // 아이콘 매핑 (카테고리 ID 기준)
  static const Map<int, IconData> _iconMap = {
    1: Icons.apartment,         // 거시경제학
    2: Icons.public,            // 국제경제·무역
    3: Icons.trending_up,       // 금융·투자
    4: Icons.school,            // 기초 경제 개념
    5: Icons.storefront,        // 미시경제학
    6: Icons.newspaper,         // 시사 상식
    7: Icons.psychology,        // 행동경제학
  };

  // 색상 매핑 (카테고리 ID 기준)
  static final Map<int, Color> _colorMap = {
    1: Colors.indigo.shade100,
    2: Colors.teal.shade100,
    3: Colors.green.shade200,
    4: Colors.orange.shade100,
    5: Colors.pink.shade100,
    6: Colors.grey.shade300,
    7: Colors.deepPurple.shade100,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _iconMap[categoryId] ?? Icons.category;
    final color = _colorMap[categoryId] ?? Colors.grey.shade200;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
