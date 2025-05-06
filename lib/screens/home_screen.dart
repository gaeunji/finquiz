import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../models/category.dart';
import '../data/categories.dart';

final List<int> xpData = [40, 30, 60, 20, 70, 50, 80];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> selectedCategories = allCategories.sublist(0, 3);

  void addCategory(Category category) {
    if (!selectedCategories.any((c) => c.label == category.label)) {
      setState(() {
        selectedCategories.add(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(40, 90, 35, 20),
              height: 210,
              width: double.infinity,
              color: const Color(0xFF005eff),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Johnny',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Great to see you again!',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ],
              ),
            ),

            // My Level Card (overlap effect using Transform.translate)
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                width: 334,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFF344BFD)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '419 / 1500 XP',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 419 / 1500,
                            color: Color(0XFF344BFD),
                            backgroundColor: Colors.grey[300],
                            strokeWidth: 5,
                          ),
                          const Center(
                            child: Text(
                              '29',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),

            // XP Earned
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 334,

                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:
                            xpData.map((xp) {
                              double height = (xp / 100) * 60;
                              return Container(
                                width: 8,
                                height: height,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF344BFD),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${xpData.reduce((a, b) => a + b)} XP',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Last 7 days',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 연속 학습 일수
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 334,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Color(0xFF344BFD)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('연속 학습 일수', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      '188',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF344BFD)
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 카테고리
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  const Text(
                    'My Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/all-categories',
                      );
                      if (result is Category) {
                        addCategory(result);
                      }
                    },
                  ),
                ],
              ),
            ),

            Column(
              children: selectedCategories.map((cat) {
                return CategoryCard(
                  icon: cat.icon,
                  label: cat.label,
                  color: cat.color,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/intro',
                      arguments: cat.label,
                    );
                  },
                ),
              }).toList(),
            ),


            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
