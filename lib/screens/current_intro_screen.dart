import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz_session_screen.dart';

class CurrentIntroScreen extends StatefulWidget {
  const CurrentIntroScreen({super.key});

  @override
  State<CurrentIntroScreen> createState() => _CurrentIntroScreenState();
}

class _CurrentIntroScreenState extends State<CurrentIntroScreen> {
  late String name; // 카테고리 이름
  String description = '';
  List<String> keywords = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    name = ModalRoute.of(context)!.settings.arguments as String;
    fetchCategoryIntro();
  }

  Future<void> fetchCategoryIntro() async {
    final encodedName = Uri.encodeComponent(name);
    final url = Uri.parse('http://10.0.2.2:5000/categories/name/$encodedName'); // 실제 IP로 변경 가능

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          description = data['description'] ?? '';
          keywords = List<String>.from(data['keywords'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          description = '카테고리 정보를 불러올 수 없습니다.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        description = '네트워크 오류가 발생했습니다.';
        isLoading = false;
      });
    }
  }

  Future<void> createQuizSession() async {
    final categoryMap = {
      '거시경제학': 1,
      '국제경제·무역': 2,
      '금융·투자': 3,
      '기초 경제 개념': 4,
      '미시경제학': 5,
      '시사 상식': 6,
      '행동경제학': 7,
    };

    final userId = 123; // TODO: 실제 유저 ID로 대체
    final categoryId = categoryMap[name];

    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효하지 않은 카테고리입니다.')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5000/quizzes/session');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'categoryId': categoryId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final sessionId = data['sessionId'];
      final quizIds = List<int>.from(data['quizIds']); // quiz_id List<int>로 받음
      Navigator.pushNamed(context, '/quiz', arguments: {
        'sessionId': sessionId,
        'quizIds': quizIds,
      });
    } else {
      final error = json.decode(response.body)['error'] ?? '알 수 없는 오류';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('퀴즈 세션 생성 실패: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 아이콘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Icon(Icons.bookmark_border, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff727272),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      "이런 내용을 다뤄요!",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (keywords.isNotEmpty)
                      Column(
                        children: keywords.map((k) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: SizedBox(
                              width: 334,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffEAF2FF),
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                k,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                     }).toList(),
                    ),

                    const SizedBox(height: 60), // 버튼과의 여백 확보
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              await createQuizSession();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff006FFD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '시작하기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
