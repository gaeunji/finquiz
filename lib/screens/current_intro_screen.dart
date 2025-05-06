import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final url = Uri.parse('http://localhost:5000/categories/name/$encodedName'); // 실제 IP로 변경 가능

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF7F9FC)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.arrow_back_ios, color: Colors.grey),
                      Icon(Icons.bookmark_border, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  if (keywords.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: keywords
                          .map((k) => Chip(label: Text(k)))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
