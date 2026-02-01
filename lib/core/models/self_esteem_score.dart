import 'package:isar/isar.dart';

part 'self_esteem_score.g.dart';

/// 自己肯定感スコアモデル
@collection
class SelfEsteemScore {
  /// 自己肯定感スコアを作成
  SelfEsteemScore();

  /// 名前付きコンストラクタ
  SelfEsteemScore.create({
    required this.uuid,
    required this.userUuid,
    required this.score,
    this.calculationBasisJson,
    this.completionRate,
    this.positiveEmotionRatio,
    this.streakScore,
    this.engagementScore,
  }) {
    measuredAt = DateTime.now();
  }
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String userUuid;

  late double score; // 0.0 ~ 1.0
  String? calculationBasisJson; // スコア算出の根拠データ（JSON）

  // スコア構成要素
  double? completionRate; // タスク完了率
  double? positiveEmotionRatio; // ポジティブ感情比率
  double? streakScore; // 継続日数スコア
  double? engagementScore; // AI対話頻度スコア

  @Index()
  DateTime measuredAt = DateTime.now();

  /// スコア構成要素を設定
  void setComponents({
    required double completion,
    required double positiveEmotion,
    required double streak,
    required double engagement,
  }) {
    completionRate = completion;
    positiveEmotionRatio = positiveEmotion;
    streakScore = streak;
    engagementScore = engagement;
  }

  /// スコアレベルを取得（計算プロパティ）
  ScoreLevel getLevel() {
    if (score >= 0.8) {
      return ScoreLevel.excellent;
    }
    if (score >= 0.6) {
      return ScoreLevel.good;
    }
    if (score >= 0.4) {
      return ScoreLevel.fair;
    }
    if (score >= 0.2) {
      return ScoreLevel.poor;
    }
    return ScoreLevel.veryPoor;
  }

  /// スコアレベルの説明を取得
  String get levelDescription {
    switch (getLevel()) {
      case ScoreLevel.excellent:
        return '素晴らしい状態です';
      case ScoreLevel.good:
        return '良い調子です';
      case ScoreLevel.fair:
        return '普通の状態です';
      case ScoreLevel.poor:
        return '少し疲れ気味です';
      case ScoreLevel.veryPoor:
        return '休息が必要です';
    }
  }

  /// 今日のスコアかチェック
  bool get isToday {
    final now = DateTime.now();
    return measuredAt.year == now.year &&
        measuredAt.month == now.month &&
        measuredAt.day == now.day;
  }

  @override
  String toString() =>
      'SelfEsteemScore{uuid: $uuid, score: $score, level: ${getLevel()}}';
}

/// スコアレベル
enum ScoreLevel {
  veryPoor, // 0.0-0.2
  poor, // 0.2-0.4
  fair, // 0.4-0.6
  good, // 0.6-0.8
  excellent, // 0.8-1.0
}
