import 'package:isar/isar.dart';

part 'honesty_score_record.g.dart';

/// 誠実性スコア記録モデル
@collection
class HonestyScoreRecord {
  /// 誠実性スコア記録を作成
  HonestyScoreRecord();

  /// 名前付きコンストラクタ
  HonestyScoreRecord.create({
    required this.userId,
    this.currentScore = 50,
    this.historyJson = '[]',
  }) {
    lastUpdated = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  late int currentScore;

  // スコア履歴（JSON）
  late String historyJson;

  late DateTime lastUpdated;

  /// スコアを増加
  void increaseScore(int amount, String reason) {
    final previousScore = currentScore;
    currentScore = (currentScore + amount).clamp(0, 100);
    lastUpdated = DateTime.now();
    _addToHistory(previousScore, currentScore, amount, reason);
  }

  /// スコアを減少
  void decreaseScore(int amount, String reason) {
    final previousScore = currentScore;
    currentScore = (currentScore - amount).clamp(0, 100);
    lastUpdated = DateTime.now();
    _addToHistory(previousScore, currentScore, -amount, reason);
  }

  /// ブースト率を計算
  double calculateBoostRate() {
    if (currentScore >= 81) return 0.15;
    if (currentScore >= 61) return 0.10;
    if (currentScore >= 31) return 0.05;
    return 0.0;
  }

  /// 次の閾値を取得
  int getNextThreshold() {
    if (currentScore < 31) return 31;
    if (currentScore < 61) return 61;
    if (currentScore < 81) return 81;
    return 100;
  }

  /// 履歴に追加（内部メソッド）
  void _addToHistory(
      int previousScore, int newScore, int delta, String reason) {
    // 簡易的なJSON追加（実際の実装ではjson_serializableを使用）
    // ここでは文字列操作で対応
    final entry =
        '{"previousScore":$previousScore,"newScore":$newScore,"delta":$delta,"reason":"$reason","timestamp":"${DateTime.now().toIso8601String()}"}';

    if (historyJson == '[]') {
      historyJson = '[$entry]';
    } else {
      historyJson =
          historyJson.substring(0, historyJson.length - 1) + ',$entry]';
    }
  }

  @override
  String toString() =>
      'HonestyScoreRecord{userId: $userId, currentScore: $currentScore, boostRate: ${calculateBoostRate()}}';
}
