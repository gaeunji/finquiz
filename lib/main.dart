import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/current_intro_screen.dart';
import 'screens/all_categories_screen.dart';
import 'screens/quiz_session_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_review_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Economics Quiz App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/intro': (context) => const CurrentIntroScreen(),
        '/all-categories': (context) => const AllCategoriesScreen(),
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

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    Center(child: Text("Feed")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.view_list), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
