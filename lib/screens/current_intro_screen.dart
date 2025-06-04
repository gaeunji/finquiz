import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/bookmark_icon.dart';

class CurrentIntroScreen extends StatefulWidget {
  const CurrentIntroScreen({super.key});

  @override
  State<CurrentIntroScreen> createState() => _CurrentIntroScreenState();
}

class _CurrentIntroScreenState extends State<CurrentIntroScreen> {
  final int userId = 123; // TODO: 실제 사용자 ID로 교체 필요

  int? categoryId;
  Map<String, dynamic>? categoryData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || args['id'] == null) {
      setState(() {
        errorMessage = '카테고리 ID가 전달되지 않았습니다.';
        isLoading = false;
      });
      return;
    }

    categoryId = args['id'];
    fetchCategoryDetail(categoryId!);
  }

  Future<void> fetchCategoryDetail(int id) async {
    final url = Uri.parse('http://10.0.2.2:5000/categories/$id');
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        setState(() {
          categoryData = json.decode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '카테고리 정보를 불러오지 못했습니다.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '서버 통신 오류: $e';
        isLoading = false;
      });
    }
  }

  Future<void> createQuizSession() async {
    final url = Uri.parse('http://10.0.2.2:5000/quizzes/session');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'categoryId': categoryId, 'userId': userId}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final sessionId = data['sessionId'];
        final quizIds = List<int>.from(data['quizIds']);
        Navigator.pushNamed(
          context,
          '/quiz',
          arguments: {'sessionId': sessionId, 'quizIds': quizIds},
        );
      } else {
        final error = json.decode(response.body)['error'] ?? '알 수 없는 오류';
        showSnackBar('퀴즈 세션 생성 실패: $error');
      }
    } catch (e) {
      showSnackBar('서버 통신 실패: $e');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
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
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                BookmarkIcon(
                                  userId: userId,
                                  targetId: categoryId!,
                                  type: BookmarkType.category,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              categoryData!['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoryData!['description'] ?? '',
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
                            ...List.generate(
                              (categoryData!['keywords'] as List).length,
                              (index) {
                                final keyword =
                                    categoryData!['keywords'][index].toString();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: SizedBox(
                                    width: 334,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xffEAF2FF,
                                        ),
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        alignment: Alignment.centerLeft,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        keyword,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar:
          isLoading || errorMessage != null
              ? null
              : Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: createQuizSession,
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
