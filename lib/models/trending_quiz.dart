class TrendingQuiz {
  final int id;
  final String question;
  final String difficulty;
  final int participants;
  final int trendingRank;
  final String category;
  final String newsTitle;
  final String newsImage;
  final String newsUrl;
  final List<String> options;

  const TrendingQuiz({
    required this.id,
    required this.question,
    required this.difficulty,
    required this.participants,
    required this.trendingRank,
    required this.category,
    required this.newsTitle,
    required this.newsImage,
    required this.newsUrl,
    required this.options,
  });
}
