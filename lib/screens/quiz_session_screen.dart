// quiz_session_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizSessionScreen extends StatefulWidget {
  final int sessionId;
  final List<String> quizIds;

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
  Map<int, String> userAnswers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllQuizzes();
  }

  Future<void> fetchAllQuizzes() async {
    for (var id in widget.quizIds) {
      final url = Uri.parse('http://10.0.2.2:5000/quizzes/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        quizData.add(json.decode(response.body));
      }
    }
    setState(() => isLoading = false);
  }

  void submitAll() async {
    final url = Uri.parse('http://10.0.2.2:5000/quizzes/session/${widget.sessionId}/complete');
    final answers = quizData.map((q) => {
      'questionId': q['id'],
      'selectedAnswer': userAnswers[q['id']] ?? '',
    }).toList();

    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'answers': answers}),
    );


    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      // 결과 화면 이동
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

    return Scaffold(
      appBar: AppBar(
        title: Text('문제 ${currentIndex + 1} / ${quizData.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...options.map((opt) => RadioListTile<String>(
              title: Text(opt),
              value: opt,
              groupValue: userAnswers[quiz['id']],
              onChanged: (val) {
                setState(() {
                  userAnswers[quiz['id']] = val!;
                });
              },
            )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentIndex > 0
                      ? () => setState(() => currentIndex--)
                      : null,
                  child: const Text('이전'),
                ),
                currentIndex < quizData.length - 1
                    ? ElevatedButton(
                  onPressed: () => setState(() => currentIndex++),
                  child: const Text('다음'),
                )
                    : ElevatedButton(
                  onPressed: submitAll,
                  child: const Text('제출'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

class QuizSessionScreenWrapper extends StatelessWidget {
  const QuizSessionScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final sessionId = args['sessionId'] as int;
    final quizIds = List<String>.from(args['quizIds']);

    return QuizSessionScreen(
      sessionId: sessionId,
      quizIds: quizIds,
    );
  }
}


