import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../models/user_context.dart';
import '../repositories/journal_repository.dart';
import '../repositories/task_repository.dart';

/// ユーザーコンテキストサービス
class UserContextService {
  UserContextService(this._journalRepository, this._taskRepository);

  final JournalRepository _journalRepository;
  final TaskRepository _taskRepository;

  /// ユーザーコンテキストを取得
  Future<UserContext> getUserContext(String userUuid) async {
    // 過去7日間のデータを取得
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final recentEntries = await _journalRepository.getEntriesByDateRange(
      userUuid,
      sevenDaysAgo,
      now,
    );

    // 感情トレンドを分析
    final emotionTrend = _analyzeEmotionTrend(recentEntries);

    // 最近の感情を抽出
    final recentEmotions = recentEntries
        .where((e) => e.emotionDetected != null)
        .map((e) => Emotion(
              type: e.emotionDetected!,
              confidence: e.emotionConfidence ?? 0.0,
              scores: {e.emotionDetected!: e.emotionConfidence ?? 0.0},
              isNegative: _isNegativeEmotion(e.emotionDetected!),
            ))
        .toList();

    // モチベーションレベルを計算
    final motivationLevel = await _calculateMotivationLevel(userUuid);

    // 対話履歴を取得（最新10件）
    final dialogueHistory = recentEntries
        .where((e) => e.aiReflection != null)
        .take(10)
        .map((e) => e.aiReflection!)
        .toList();

    // 最後の対話日時
    final lastDialogueAt =
        recentEntries.isNotEmpty ? recentEntries.first.createdAt : null;

    return UserContext(
      userId: userUuid,
      emotionTrend: emotionTrend,
      motivationLevel: motivationLevel,
      recentEmotions: recentEmotions,
      dialogueHistory: dialogueHistory,
      lastDialogueAt: lastDialogueAt,
    );
  }

  /// 感情トレンドを分析
  EmotionTrend _analyzeEmotionTrend(List<JournalEntry> entries) {
    if (entries.length < 2) {
      return EmotionTrend(
        isImproving: false,
        isDecreasing: false,
        isStable: true,
        averageScore: 0.5,
      );
    }

    // ポジティブ感情のスコアを計算
    final scores = entries
        .where((e) => e.emotionDetected != null)
        .map((e) => _getEmotionScore(e.emotionDetected!))
        .toList();

    if (scores.isEmpty) {
      return EmotionTrend(
        isImproving: false,
        isDecreasing: false,
        isStable: true,
        averageScore: 0.5,
      );
    }

    final averageScore = scores.reduce((a, b) => a + b) / scores.length;

    // 前半と後半を比較
    final midPoint = scores.length ~/ 2;
    final firstHalf = scores.sublist(0, midPoint);
    final secondHalf = scores.sublist(midPoint);

    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    final difference = secondAvg - firstAvg;

    return EmotionTrend(
      isImproving: difference > 0.1,
      isDecreasing: difference < -0.1,
      isStable: difference.abs() <= 0.1,
      averageScore: averageScore,
    );
  }

  /// 感情スコアを取得（ポジティブ: 1.0, ネガティブ: 0.0）
  double _getEmotionScore(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 1.0;
      case EmotionType.neutral:
        return 0.5;
      case EmotionType.sad:
      case EmotionType.angry:
      case EmotionType.anxious:
      case EmotionType.tired:
        return 0.0;
    }
  }

  /// ネガティブ感情かチェック
  bool _isNegativeEmotion(EmotionType type) =>
      type == EmotionType.sad ||
      type == EmotionType.angry ||
      type == EmotionType.anxious ||
      type == EmotionType.tired;

  /// モチベーションレベルを計算
  Future<double> _calculateMotivationLevel(String userUuid) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // タスク完了率を取得
    final tasks = await _taskRepository.getTasksByDateRange(
      userUuid,
      sevenDaysAgo,
      now,
    );

    if (tasks.isEmpty) {
      return 0.5; // デフォルト値
    }

    final completedTasks = tasks.where((t) => t.completedAt != null).length;
    final completionRate = completedTasks / tasks.length;

    // 感情統計を取得
    final emotionStats = await _journalRepository.getEmotionStatistics(
      userUuid,
      sevenDaysAgo,
      now,
    );

    final totalEmotions = emotionStats.values.reduce((a, b) => a + b);
    if (totalEmotions == 0) {
      return completionRate;
    }

    final positiveCount = (emotionStats[EmotionType.happy] ?? 0) +
        (emotionStats[EmotionType.neutral] ?? 0);
    final positiveRatio = positiveCount / totalEmotions;

    // 完了率50%、感情50%の重み付き平均
    return (completionRate * 0.5) + (positiveRatio * 0.5);
  }
}
