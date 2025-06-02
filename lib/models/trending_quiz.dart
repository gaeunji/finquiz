import 'package:flutter/foundation.dart';

class TrendingQuiz {
  final int id;
  final String question;
  final List<String> options;
  final int? categoryId;
  final String newsTitle;
  final String newsImage;
  final String difficulty;
  final int? participants;
  final int? trendingRank;
  final String? hintUrl;

  TrendingQuiz({
    required this.id,
    required this.question,
    required this.options,
    this.categoryId,
    required this.newsTitle,
    required this.newsImage,
    required this.difficulty,
    this.participants,
    this.trendingRank,
    this.hintUrl,
  });

  factory TrendingQuiz.fromJson(Map<String, dynamic> json) {
    debugPrint('Converting JSON to TrendingQuiz: $json');
    try {
      final quiz = TrendingQuiz(
        id: json['id'],
        question: json['question'],
        options: List<String>.from(json['options']),
        categoryId: json['categoryId'],
        newsTitle: json['newsTitle'],
        newsImage: json['newsImage'],
        difficulty: json['difficulty'],
        participants: json['participants'],
        trendingRank: json['trendingRank'],
        hintUrl: json['hintUrl'],
      );
      debugPrint('Successfully created TrendingQuiz: $quiz');
      return quiz;
    } catch (e, stackTrace) {
      debugPrint('Error creating TrendingQuiz: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
