import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../repositories/journal_repository.dart';

/// 感情トレンド分析の詳細結果
class DetailedEmotionTrend {
  DetailedEmotionTrend({
    required this.trend,
    required this.recentAverageScore,
    required this.previousAverageScore,
    required this.changePercentage,
    required this.dominantEmotion,
    required this.emotionDistribution,
    required this.consecutivePositiveDays,
    required this.consecutiveNegativeDays,
  });

  final EmotionTrend trend;
  final double recentAverageScore; // 最近3日間の平均スコア
  final double previousAverageScore; // 過去4日間の平均スコア
  final double changePercentage; // 変化率（%）
  final EmotionType dominantEmotion; // 支配的な感情
  final Map<EmotionType, int> emotionDistribution; // 感情の分布
  final int consecutivePositiveDays; // 連続ポジティブ日数
  final int consecutiveNegativeDays; // 連続ネガティブ日数

  @override
  String toString() =>
      'DetailedEmotionTrend{trend: $trend, change: ${changePercentage.toStringAsFixed(1)}%, dominant: $dominantEmotion}';
}

/// 感情トレンド分析エンジン
/// 過去7日間の感情履歴を分析し、改善・悪化・安定の傾向を検出
class EmotionTrendAnalyzer {
  EmotionTrendAnalyzer({required this.journalRepository});

  final JournalRepository journalRepository;

  /// 詳細な感情トレンドを分析
  Future<DetailedEmotionTrend> analyzeDetailedTrend(String userUuid) async {
    // 過去7日間の感情履歴を取得
    final history = await _getEmotionHistory(userUuid, days: 7);

    if (history.isEmpty) {
      return _getDefaultTrend();
    }

    // 最近3日間と過去4日間に分割
    final recentEntries = history.take(3).toList();
    final previousEntries = history.skip(3).take(4).toList();

    // ポジティブ感情の比率を計算
    final positiveEmotions = [EmotionType.happy, EmotionType.neutral];
    final recentScore = _calculatePositiveRatio(
      recentEntries,
      positiveEmotions,
    );
    final previousScore = _calculatePositiveRatio(
      previousEntries,
      positiveEmotions,
    );

    // 変化率を計算
    final changePercentage = previousScore > 0
        ? ((recentScore - previousScore) / previousScore) * 100
        : 0.0;

    // トレンドを判定
    final trend = _determineTrend(recentScore, previousScore);

    // 支配的な感情を特定
    final dominantEmotion = _findDominantEmotion(history);

    // 感情の分布を計算
    final distribution = _calculateEmotionDistribution(history);

    // 連続日数を計算
    final consecutivePositive = _calculateConsecutivePositiveDays(
      history,
      positiveEmotions,
    );
    final consecutiveNegative = _calculateConsecutiveNegativeDays(
      history,
      positiveEmotions,
    );

    return DetailedEmotionTrend(
      trend: trend,
      recentAverageScore: recentScore,
      previousAverageScore: previousScore,
      changePercentage: changePercentage,
      dominantEmotion: dominantEmotion,
      emotionDistribution: distribution,
      consecutivePositiveDays: consecutivePositive,
      consecutiveNegativeDays: consecutiveNegative,
    );
  }

  /// 簡易的な感情トレンドを分析
  Future<EmotionTrend> analyzeTrend(String userUuid) async {
    final detailed = await analyzeDetailedTrend(userUuid);
    return detailed.trend;
  }

  /// 過去の感情履歴を取得
  Future<List<JournalEntry>> _getEmotionHistory(
    String userUuid, {
    required int days,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final entries = await journalRepository.getEntriesByDateRange(
      userUuid,
      startDate,
      DateTime.now(),
    );

    // 日付順にソート（新しい順）
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  /// トレンドを判定
  EmotionTrend _determineTrend(double recentScore, double previousScore) {
    final difference = recentScore - previousScore;
    const threshold = 0.1; // 10%の変化で有意とみなす

    final isImproving = difference > threshold;
    final isDecreasing = difference < -threshold;
    final isStable = !isImproving && !isDecreasing;

    return EmotionTrend(
      isImproving: isImproving,
      isDecreasing: isDecreasing,
      isStable: isStable,
      averageScore: recentScore,
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

  /// 支配的な感情を特定
  EmotionType _findDominantEmotion(List<JournalEntry> entries) {
    if (entries.isEmpty) return EmotionType.neutral;

    final distribution = _calculateEmotionDistribution(entries);

    EmotionType dominant = EmotionType.neutral;
    var maxCount = 0;

    for (final entry in distribution.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominant = entry.key;
      }
    }

    return dominant;
  }

  /// 感情の分布を計算
  Map<EmotionType, int> _calculateEmotionDistribution(
    List<JournalEntry> entries,
  ) {
    final distribution = <EmotionType, int>{
      EmotionType.happy: 0,
      EmotionType.sad: 0,
      EmotionType.angry: 0,
      EmotionType.anxious: 0,
      EmotionType.tired: 0,
      EmotionType.neutral: 0,
    };

    for (final entry in entries) {
      if (entry.emotionDetected != null) {
        distribution[entry.emotionDetected!] =
            (distribution[entry.emotionDetected!] ?? 0) + 1;
      }
    }

    return distribution;
  }

  /// 連続ポジティブ日数を計算
  int _calculateConsecutivePositiveDays(
    List<JournalEntry> entries,
    List<EmotionType> positiveEmotions,
  ) {
    var consecutiveDays = 0;
    final entriesByDay = _groupEntriesByDay(entries);

    for (final dayEntries in entriesByDay) {
      final hasPositive = dayEntries.any((e) =>
          e.emotionDetected != null &&
          positiveEmotions.contains(e.emotionDetected));

      if (hasPositive) {
        consecutiveDays++;
      } else {
        break;
      }
    }

    return consecutiveDays;
  }

  /// 連続ネガティブ日数を計算
  int _calculateConsecutiveNegativeDays(
    List<JournalEntry> entries,
    List<EmotionType> positiveEmotions,
  ) {
    var consecutiveDays = 0;
    final entriesByDay = _groupEntriesByDay(entries);

    for (final dayEntries in entriesByDay) {
      final hasNegative = dayEntries.any((e) =>
          e.emotionDetected != null &&
          !positiveEmotions.contains(e.emotionDetected));

      if (hasNegative) {
        consecutiveDays++;
      } else {
        break;
      }
    }

    return consecutiveDays;
  }

  /// エントリを日ごとにグループ化
  List<List<JournalEntry>> _groupEntriesByDay(List<JournalEntry> entries) {
    final grouped = <String, List<JournalEntry>>{};

    for (final entry in entries) {
      final dateKey = _getDateKey(entry.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    // 日付順にソート（新しい順）
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedKeys.map((key) => grouped[key]!).toList();
  }

  /// 日付キーを生成
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// デフォルトのトレンドを返す
  DetailedEmotionTrend _getDefaultTrend() {
    return DetailedEmotionTrend(
      trend: EmotionTrend(
        isImproving: false,
        isDecreasing: false,
        isStable: true,
        averageScore: 0.5,
      ),
      recentAverageScore: 0.5,
      previousAverageScore: 0.5,
      changePercentage: 0.0,
      dominantEmotion: EmotionType.neutral,
      emotionDistribution: {
        EmotionType.happy: 0,
        EmotionType.sad: 0,
        EmotionType.angry: 0,
        EmotionType.anxious: 0,
        EmotionType.tired: 0,
        EmotionType.neutral: 0,
      },
      consecutivePositiveDays: 0,
      consecutiveNegativeDays: 0,
    );
  }
}
