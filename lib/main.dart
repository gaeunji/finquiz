import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/current_intro_screen.dart';
import 'screens/quiz_session_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_review_screen.dart';
import 'screens/learn/learn_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/categories_screen.dart';
import 'widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // 홈
    CategoriesTab(), // 카테고리
    ReviewScreen(), // 학습 + 북마크
    ProfileScreen(), // 마이페이지
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Economics Quiz App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      routes: {
        '/intro': (context) => const CurrentIntroScreen(),
        '/all-categories': (context) => const CategoriesTab(),
        '/quiz': (context) => const QuizSessionScreenWrapper(),
        '/review': (context) => const QuizReviewScreenWrapper(),
        '/result': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return QuizResultScreen(
            sessionId: args['sessionId'],
            score: args['score'],
            total: args['total'],
            xp: args['xp'],
            duration: Duration(seconds: args['duration']),
            results: args['results'],
          );
        },
      },
    );
  }
}
