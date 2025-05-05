import 'package:flutter/material.dart';
import '../models/category.dart';

const List<Category> allCategories = [
  Category(icon: Icons.school, label: '기초 경제 개념', color: Color(0xFFE4F0FF)),
  Category(icon: Icons.attach_money, label: '금융·투자', color: Color(0xFFF3E5F5)),
  Category(icon: Icons.pie_chart, label: '미시경제학', color: Color(0xFFFFF9C4)),
  Category(icon: Icons.bar_chart, label: '거시경제학', color: Color(0xFFFFECB3)),
  Category(icon: Icons.public, label: '국제경제·무역', color: Color(0xFFB2EBF2)),
  Category(icon: Icons.history_edu, label: '경제사', color: Color(0xFFD7CCC8)),
  Category(icon: Icons.lightbulb, label: '시사 상식', color: Color(0xFFC8E6C9)),
  Category(icon: Icons.person, label: '행동경제학', color: Color(0xFFFFCDD2)),
];
