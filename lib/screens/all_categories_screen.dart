import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../data/categories.dart';
import '../models/category.dart';
import '../widgets/bookmark_icon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  late Future<List<dynamic>> _allCategories;

  @override
  void initState() {
    super.initState();
    _allCategories = fetchAllCategories();
  }

  Future<List<dynamic>> fetchAllCategories() async {
    final url = Uri.parse('http://10.0.2.2:5000/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body); // [{id: 1, label: "거시경제학"}, ...]
    } else {
      throw Exception('카테고리 목록 불러오기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카테고리 선택')),
      body: FutureBuilder<List<dynamic>>(
        future: _allCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          }

          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 30),
            child: Wrap(
              spacing: 24,
              runSpacing: 20,
              alignment: WrapAlignment.start,
              children:
                  categories.map((cat) {
                    final int id =
                        cat['id'] is String
                            ? int.tryParse(cat['id']) ?? 0
                            : cat['id'] as int;
                    final String label = cat['name']?.toString() ?? '이름 없음';

                    return CategoryCard(
                      categoryId: id,
                      label: label,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/intro',
                          arguments: {'id': id},
                        );
                      },
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
