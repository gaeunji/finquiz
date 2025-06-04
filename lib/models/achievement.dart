class Achievement {
  final int id;
  final String title;
  final String description;
  final String targetType;
  final int targetValue;
  final String? icon;
  final String? color;
  final int? categoryId;
  final int? progress;
  final bool? unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.targetType,
    required this.targetValue,
    this.icon,
    this.color,
    this.categoryId,
    this.progress,
    this.unlocked,
    this.unlockedAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      targetType: map['targetType'] as String,
      targetValue: map['targetValue'] as int,
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      categoryId: map['categoryId'] as int?,
      progress: map['progress'] as int?,
      unlocked: map['unlocked'] as bool?,
      unlockedAt:
          map['unlockedAt'] != null
              ? DateTime.parse(map['unlockedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetType': targetType,
      'targetValue': targetValue,
      'icon': icon,
      'color': color,
      'categoryId': categoryId,
      'progress': progress,
      'unlocked': unlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}
