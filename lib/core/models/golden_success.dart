import 'package:isar/isar.dart';

part 'golden_success.g.dart';

/// 黄金の成功体験モデル
@collection
class GoldenSuccess {
  /// 黄金の成功体験を作成
  GoldenSuccess();

  /// 名前付きコンストラクタ
  GoldenSuccess.create({
    required this.userId,
    required this.taskId,
    required this.taskTitle,
    this.taskDescription,
    required this.achievementScore,
    this.emotionAtCompletion,
    this.encryptedCompanionLog,
    this.encryptedReflection,
  }) {
    stakedGems = 5; // 常に5
    achievedAt = DateTime.now();
    createdAt = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  late String taskId;
  late String taskTitle;
  String? taskDescription;

  late int stakedGems; // 常に5
  late double achievementScore;

  // 感情状態
  String? emotionAtCompletion;

  // AI伴走ログ（暗号化）
  String? encryptedCompanionLog;

  // ユーザーの振り返り（暗号化）
  String? encryptedReflection;

  @Index()
  late DateTime achievedAt;
  late DateTime createdAt;

  /// 振り返りを設定
  void setReflection(String encryptedReflection) {
    this.encryptedReflection = encryptedReflection;
  }

  /// 今日達成されたかチェック
  bool get isAchievedToday {
    final now = DateTime.now();
    return achievedAt.year == now.year &&
        achievedAt.month == now.month &&
        achievedAt.day == now.day;
  }

  /// 今週達成されたかチェック
  bool get isAchievedThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return achievedAt.isAfter(weekStart);
  }

  @override
  String toString() =>
      'GoldenSuccess{userId: $userId, taskTitle: $taskTitle, achievedAt: $achievedAt}';
}
