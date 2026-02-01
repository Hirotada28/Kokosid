import 'emotion.dart';

/// ユーザーコンテキスト
class UserContext {
  UserContext({
    required this.userId,
    required this.emotionTrend,
    required this.motivationLevel,
    required this.recentEmotions,
    required this.dialogueHistory,
    this.lastDialogueAt,
  });

  final String userId;
  final EmotionTrend emotionTrend;
  final double motivationLevel; // 0.0 ~ 1.0
  final List<Emotion> recentEmotions;
  final List<String> dialogueHistory;
  final DateTime? lastDialogueAt;

  @override
  String toString() =>
      'UserContext{userId: $userId, motivationLevel: $motivationLevel}';
}
