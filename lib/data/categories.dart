import 'package:flutter/material.dart';
import '../models/category.dart';

const List<Category> allCategories = [
  Category(id:1, icon: Icons.school, label: '기초 경제 개념', color: Color(0xFFE4F0FF)),
  Category(id: 2, icon: Icons.attach_money, label: '금융·투자', color: Color(0xFFF3E5F5)),
  Category(id: 3, icon: Icons.pie_chart, label: '미시경제학', color: Color(0xFFFFF9C4)),
  Category(id: 4, icon: Icons.bar_chart, label: '거시경제학', color: Color(0xFFFFECB3)),
  Category(id:5, icon: Icons.public, label: '국제경제·무역', color: Color(0xFFB2EBF2)),
  Category(id:6, icon: Icons.lightbulb, label: '시사 상식', color: Color(0xFFC8E6C9)),
  Category(id:7, icon: Icons.person, label: '행동경제학', color: Color(0xFFFFCDD2)),
];
