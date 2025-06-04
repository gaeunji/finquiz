import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';
import '../../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  final int userId;

  const AchievementsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late final AchievementService _achievementService;
  List<Achievement> _achievements = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _achievementService = AchievementService(baseUrl: 'http://10.0.2.2:5000');
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('Loading achievements for user ${widget.userId}');
      final userAchievements = await _achievementService.getUserAchievements(
        widget.userId,
      );

      print('Loaded ${userAchievements.length} achievements');
      setState(() {
        _achievements = userAchievements.map((ua) => ua.achievement).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading achievements: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAchievements() async {
    try {
      // 사용자 데이터 예시
      final userData = {
        'totalQuizCount': 50,
        'perfectScores': 15,
        'consecutiveDays': 5,
        'categoryQuizCounts': {
          3: 80, // 금융 카테고리
          6: 60, // 시사 상식 카테고리
        },
        'bookmarkCount': 15,
        'xpAmount': 2500,
      };

      final updatedAchievements = await _achievementService
          .updateAllUserAchievements(userId: widget.userId, userData: userData);

      setState(() {
        _achievements = updatedAchievements;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('업적이 업데이트되었습니다')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('업적 업데이트 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('업적을 불러오는 중...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "🏆 업적",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                '업적을 불러오는데 실패했습니다',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadAchievements,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "🏆 업적",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateAchievements,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: GridView.builder(
          itemCount: _achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final achievement = _achievements[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    achievement.unlocked ?? false
                        ? Colors.white
                        : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      achievement.unlocked ?? false
                          ? const Color(0xFF007AFF)
                          : const Color(0xFFF0F0F0),
                  width: achievement.unlocked ?? false ? 2 : 1,
                ),
                boxShadow: [
                  if (achievement.unlocked ?? false)
                    const BoxShadow(
                      color: Color(0x29007AFF),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  if (!(achievement.unlocked ?? false))
                    const BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            achievement.unlocked ?? false
                                ? const Color(0xFF34C759)
                                : const Color(0xFFF0F0F0),
                      ),
                      child: Center(
                        child: Text(
                          achievement.unlocked ?? false ? "✓" : "🔒",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                achievement.unlocked ?? false
                                    ? Colors.white
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          achievement.unlocked ?? false
                              ? Colors.white
                              : const Color(0xFFE0E0E0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      achievement.icon ?? '🏆',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          achievement.unlocked ?? false
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFF999999),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          achievement.unlocked ?? false
                              ? const Color(0xFF666666)
                              : const Color(0xFFAAAAAA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (achievement.progress != null &&
                          achievement.progress! > 0)
                        FractionallySizedBox(
                          widthFactor: achievement.progress! / 100,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient:
                                  achievement.unlocked ?? false
                                      ? const LinearGradient(
                                        colors: [
                                          Color(0xFF007AFF),
                                          Color(0xFF34C759),
                                        ],
                                      )
                                      : const LinearGradient(
                                        colors: [
                                          Color(0xFFDDDDDD),
                                          Color(0xFFDDDDDD),
                                        ],
                                      ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
