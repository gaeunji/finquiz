// quiz_session_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizSessionScreen extends StatefulWidget {
  final int sessionId;
  final List<int> quizIds;

  const QuizSessionScreen({
    super.key,
    required this.sessionId,
    required this.quizIds,
  });

  @override
  State<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends State<QuizSessionScreen> {
  int currentIndex = 0;
  List<Map<String, dynamic>> quizData = [];
  Map<int, int> selectedAnswerIndex = {}; // questionId -> index

  bool isLoading = true;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    fetchAllQuizzes();
  }

  Future<void> fetchAllQuizzes() async {
    for (var id in widget.quizIds) {
      final url = Uri.parse('http://10.0.2.2:5000/quizzes/$id');
      final response = await http.get(url);
      // print('응답 상태: ${response.statusCode}'); \
      // print('문제 내용: ${response.body}');

      if (response.statusCode == 200) {
        quizData.add(json.decode(response.body));
      }
    }
    setState(() => isLoading = false);
  }

  void submitAll() async {
    final endTime = DateTime.now();
    final quizDuration = endTime.difference(startTime);

    final url = Uri.parse('http://10.0.2.2:5000/quizzes/session/${widget.sessionId}/complete');
    final answers = quizData.map((q) => {
      'questionId': q['id'],
      'selectedAnswer': q['options'][selectedAnswerIndex[q['id']] ?? 0],
    }).toList();

    // print('정답 제출 요청 URL: $url');
    // print('제출 데이터: ${json.encode({'answers': answers})}');


    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'answers': answers}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      Navigator.pushReplacementNamed(context, '/result', arguments: {
        'sessionId': widget.sessionId,
        'score': result['score'],
        'total': result['total'],
        'xp': result['score'] * 10,
        'duration': quizDuration.inSeconds,
        'results': result['results'],
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final quiz = quizData[currentIndex];
    final options = List<String>.from(quiz['options']);
    final questionId = quiz['id'] is int ? quiz['id'] : int.tryParse(quiz['id'].toString());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / quizData.length,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff006FFD)),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Q. ${quiz['question']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '정답을 선택하세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ...List.generate(options.length, (index) {
                return Column(
                  children: [
                    AnswerOption(
                      text: options[index],
                      isSelected: selectedAnswerIndex[questionId] == index,
                      onTap: () {
                        setState(() {
                          selectedAnswerIndex[questionId] = index;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: currentIndex < quizData.length - 1
                          ? () => setState(() => currentIndex++)
                          : submitAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff006FFD),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        currentIndex < quizData.length - 1 ? '다음' : '제출',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? const Color(0xffEAF2FF): Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class QuizSessionScreenWrapper extends StatelessWidget {
  const QuizSessionScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('arguments: $args');
    if (args == null || args['sessionId'] == null || args['quizIds'] == null) {
      return const Scaffold(
        body: Center(child: Text('잘못된 접근입니다.')),
      );
    }

    final int sessionId = args['sessionId'] is String
        ? int.tryParse(args['sessionId'].toString()) ?? -1
        : args['sessionId'] as int;

    final List<int> quizIds = List<int>.from(args['quizIds']);

    return QuizSessionScreen(
      sessionId: sessionId,
      quizIds: quizIds,
    );
  }
}