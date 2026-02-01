import 'journal_entry.dart';

/// 感情分析結果
class Emotion {
  Emotion({
    required this.type,
    required this.confidence,
    required this.scores,
    this.isNegative = false,
  });

  /// 感情スコアから感情を生成
  factory Emotion.fromScores(Map<EmotionType, double> scores) {
    // 最も高いスコアの感情を選択
    EmotionType? maxType;
    double maxScore = 0.0;

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        maxType = entry.key;
      }
    }

    final type = maxType ?? EmotionType.neutral;
    final isNegative = _isNegativeEmotion(type);

    return Emotion(
      type: type,
      confidence: maxScore,
      scores: scores,
      isNegative: isNegative,
    );
  }

  final EmotionType type;
  final double confidence;
  final Map<EmotionType, double> scores;
  final bool isNegative;

  static bool _isNegativeEmotion(EmotionType type) {
    return type == EmotionType.sad ||
        type == EmotionType.angry ||
        type == EmotionType.anxious ||
        type == EmotionType.tired;
  }

  @override
  String toString() =>
      'Emotion{type: $type, confidence: $confidence, isNegative: $isNegative}';
}

/// 感情トレンド
class EmotionTrend {
  EmotionTrend({
    required this.isImproving,
    required this.isDecreasing,
    required this.isStable,
    required this.averageScore,
  });

  final bool isImproving;
  final bool isDecreasing;
  final bool isStable;
  final double averageScore;

  @override
  String toString() =>
      'EmotionTrend{improving: $isImproving, decreasing: $isDecreasing, stable: $isStable}';
}
