class UserInfo {
  final int userId;
  final String username;
  final int xp;
  final int level;
  final int currentLevelXp;
  final int xpToNextLevel;
  final int progressPercent;
  final int bookmarks;
  final int categories;

  UserInfo({
    required this.userId,
    required this.username,
    required this.xp,
    required this.level,
    required this.currentLevelXp,
    required this.xpToNextLevel,
    required this.progressPercent,
    required this.bookmarks,
    required this.categories,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? json['user_id'],
      username: json['username'],
      xp: json['xp'],
      level: json['level'],
      currentLevelXp: json['currentLevelXp'],
      xpToNextLevel: json['xpToNextLevel'],
      progressPercent: json['progressPercent'],
      bookmarks: json['bookmarks'],
      categories: json['categories'],
    );
  }
}
