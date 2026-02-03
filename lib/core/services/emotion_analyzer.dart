import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../repositories/journal_repository.dart';
import 'text_emotion_classifier.dart';

/// 感情分析結果
class EmotionResult {
  EmotionResult({
    required this.primaryEmotion,
    required this.confidence,
    required this.trend,
    required this.text,
    this.textEmotion,
  });

  final Emotion primaryEmotion;
  final double confidence;
  final EmotionTrend trend;
  final String text;
  final TextEmotion? textEmotion;

  @override
  String toString() =>
      'EmotionResult{emotion: $primaryEmotion, confidence: $confidence, trend: $trend}';
}

/// テキストベース感情分析システム
/// Layer 1: テキスト言語分析
/// Layer 2: コンテキスト統合分析
class EmotionAnalyzer {
  EmotionAnalyzer({
    required this.textClassifier,
    required this.journalRepository,
  });

  final TextEmotionClassifier textClassifier;
  final JournalRepository journalRepository;

  /// テキストから感情分析を実行
  Future<EmotionResult> analyzeText(String text, String userUuid) async {
    // Layer 1: テキスト分析
    final textEmotion = await textClassifier.classify(text);

    // Layer 2: コンテキスト統合分析
    final history = await _getEmotionHistory(userUuid, days: 7);
    final trend = _analyzeTrend(history);

    // テキストのみの場合は100%の重み
    final emotion = Emotion.fromScores(textEmotion.emotionScores);

    return EmotionResult(
      primaryEmotion: emotion,
      confidence: textEmotion.confidence,
      trend: trend,
      text: text,
      textEmotion: textEmotion,
    );
  }

  /// 過去の感情履歴を取得
  Future<List<JournalEntry>> _getEmotionHistory(
    String userUuid, {
    required int days,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    return journalRepository.getEntriesByDateRange(
      userUuid,
      startDate,
      DateTime.now(),
    );
  }

  /// 感情トレンドを分析
  EmotionTrend _analyzeTrend(List<JournalEntry> history) {
    if (history.isEmpty) {
      return EmotionTrend(
        isImproving: false,
        isDecreasing: false,
        isStable: true,
        averageScore: 0.5,
      );
    }

    // ポジティブ感情の比率を計算
    final positiveEmotions = [EmotionType.happy, EmotionType.neutral];
    final recentEntries = history.take(3).toList();
    final olderEntries = history.skip(3).take(4).toList();

    final recentPositiveRatio = _calculatePositiveRatio(
      recentEntries,
      positiveEmotions,
    );
    final olderPositiveRatio = _calculatePositiveRatio(
      olderEntries,
      positiveEmotions,
    );

    // トレンドを判定
    final difference = recentPositiveRatio - olderPositiveRatio;
    const threshold = 0.1; // 10%の変化で有意とみなす

    final isImproving = difference > threshold;
    final isDecreasing = difference < -threshold;
    final isStable = !isImproving && !isDecreasing;

    return EmotionTrend(
      isImproving: isImproving,
      isDecreasing: isDecreasing,
      isStable: isStable,
      averageScore: recentPositiveRatio,
    );
  }

  /// ポジティブ感情の比率を計算
  double _calculatePositiveRatio(
    List<JournalEntry> entries,
    List<EmotionType> positiveEmotions,
  ) {
    if (entries.isEmpty) return 0.5;

    final positiveCount = entries
        .where((e) =>
            e.emotionDetected != null &&
            positiveEmotions.contains(e.emotionDetected))
        .length;

    return positiveCount / entries.length;
  }
}
