class DailyXp {
  final String date;
  final int xp;

  DailyXp({required this.date, required this.xp});

  factory DailyXp.fromJson(Map<String, dynamic> json) {
    return DailyXp(date: json['date'], xp: json['xp']);
  }
}

class WeeklyXp {
  final int userId;
  final int totalXp;
  final List<DailyXp> dailyXp;

  WeeklyXp({
    required this.userId,
    required this.totalXp,
    required this.dailyXp,
  });

  factory WeeklyXp.fromJson(Map<String, dynamic> json) {
    return WeeklyXp(
      userId: json['userId'],
      totalXp: json['totalXp'],
      dailyXp:
          (json['dailyXp'] as List).map((xp) => DailyXp.fromJson(xp)).toList(),
    );
  }
}
