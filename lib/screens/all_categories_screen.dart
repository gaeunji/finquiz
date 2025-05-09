import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../data/categories.dart';
import '../models/category.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카테고리 선택')),
      body: ListView(
        children: allCategories
            .map((cat) => CategoryCard(
          icon: cat.icon,
          label: cat.label,
          color: cat.color,
          onTap: () {
            Navigator.pop(context, cat);
          },
        ))
            .toList(),
      ),
    );
  }
}
