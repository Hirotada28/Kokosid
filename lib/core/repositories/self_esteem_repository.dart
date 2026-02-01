import 'package:isar/isar.dart';
import '../models/self_esteem_score.dart';
import '../services/database_service.dart';

/// 自己肯定感スコアデータリポジトリ
class SelfEsteemRepository {
  SelfEsteemRepository(this._databaseService);
  final DatabaseService _databaseService;

  /// スコアを作成
  Future<SelfEsteemScore> createScore(SelfEsteemScore score) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.selfEsteemScores.put(score);
    });

    return score;
  }

  /// UUIDでスコアを取得
  Future<SelfEsteemScore?> getScoreByUuid(String uuid) async {
    final isar = _databaseService.isar;

    return isar.selfEsteemScores.filter().uuidEqualTo(uuid).findFirst();
  }

  /// ユーザーの全スコアを取得
  Future<List<SelfEsteemScore>> getScoresByUser(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.selfEsteemScores
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByMeasuredAtDesc()
        .findAll();
  }

  /// ユーザーの最新スコアを取得
  Future<SelfEsteemScore?> getLatestScore(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.selfEsteemScores
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByMeasuredAtDesc()
        .findFirst();
  }

  /// 今日のスコアを取得
  Future<SelfEsteemScore?> getTodayScore(String userUuid) async {
    final isar = _databaseService.isar;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return isar.selfEsteemScores
        .filter()
        .userUuidEqualTo(userUuid)
        .measuredAtBetween(startOfDay, endOfDay)
        .findFirst();
  }

  /// 期間内のスコアを取得
  Future<List<SelfEsteemScore>> getScoresByDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final isar = _databaseService.isar;

    return isar.selfEsteemScores
        .filter()
        .userUuidEqualTo(userUuid)
        .measuredAtBetween(start, end)
        .sortByMeasuredAt()
        .findAll();
  }

  /// 過去N日間のスコアを取得
  Future<List<SelfEsteemScore>> getRecentScores(
      String userUuid, int days) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));

    return getScoresByDateRange(userUuid, start, end);
  }

  /// スコアを更新
  Future<SelfEsteemScore> updateScore(SelfEsteemScore score) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.selfEsteemScores.put(score);
    });

    return score;
  }

  /// スコアを削除
  Future<bool> deleteScore(String uuid) async {
    final isar = _databaseService.isar;

    return isar.writeTxn(() async =>
        isar.selfEsteemScores.filter().uuidEqualTo(uuid).deleteFirst());
  }

  /// 平均スコアを計算
  Future<double?> getAverageScore(String userUuid, int days) async {
    final scores = await getRecentScores(userUuid, days);

    if (scores.isEmpty) return null;

    final sum = scores.fold<double>(0.0, (sum, score) => sum + score.score);
    return sum / scores.length;
  }

  /// スコアトレンドを分析
  Future<ScoreTrend> getScoreTrend(String userUuid, int days) async {
    final scores = await getRecentScores(userUuid, days);

    if (scores.length < 2) return ScoreTrend.stable;

    final recent = scores.takeLast(3).toList();
    final older = scores.take(scores.length - 3).toList();

    if (recent.isEmpty || older.isEmpty) return ScoreTrend.stable;

    final recentAvg =
        recent.fold<double>(0.0, (sum, s) => sum + s.score) / recent.length;
    final olderAvg =
        older.fold<double>(0.0, (sum, s) => sum + s.score) / older.length;

    const threshold = 0.05; // 5%の変化を有意とする

    if (recentAvg > olderAvg + threshold) {
      return ScoreTrend.improving;
    } else if (recentAvg < olderAvg - threshold) {
      return ScoreTrend.declining;
    } else {
      return ScoreTrend.stable;
    }
  }

  /// 月間統計を取得
  Future<MonthlyScoreStats> getMonthlyStats(
      String userUuid, DateTime month) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);

    final scores = await getScoresByDateRange(userUuid, start, end);

    if (scores.isEmpty) {
      return MonthlyScoreStats(
        month: month,
        averageScore: 0.0,
        highestScore: 0.0,
        lowestScore: 0.0,
        totalEntries: 0,
        trend: ScoreTrend.stable,
      );
    }

    final scoreValues = scores.map((s) => s.score).toList();
    final average = scoreValues.reduce((a, b) => a + b) / scoreValues.length;
    final highest = scoreValues.reduce((a, b) => a > b ? a : b);
    final lowest = scoreValues.reduce((a, b) => a < b ? a : b);

    return MonthlyScoreStats(
      month: month,
      averageScore: average,
      highestScore: highest,
      lowestScore: lowest,
      totalEntries: scores.length,
      trend: await getScoreTrend(userUuid, 30),
    );
  }
}

/// スコアトレンド
enum ScoreTrend {
  improving, // 改善
  declining, // 悪化
  stable, // 安定
}

/// 月間スコア統計
class MonthlyScoreStats {
  MonthlyScoreStats({
    required this.month,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.totalEntries,
    required this.trend,
  });
  final DateTime month;
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final int totalEntries;
  final ScoreTrend trend;
}

extension ListExtension<T> on List<T> {
  List<T> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }
}
