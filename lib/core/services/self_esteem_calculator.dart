import 'dart:convert';
import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../repositories/journal_repository.dart';
import '../repositories/self_esteem_repository.dart';
import '../repositories/task_repository.dart';

/// 自己肯定感スコア計算サービス
class SelfEsteemCalculator {
  // AI対話頻度

  SelfEsteemCalculator(
    this._taskRepository,
    this._journalRepository,
    this._scoreRepository,
  );
  final TaskRepository _taskRepository;
  final JournalRepository _journalRepository;
  final SelfEsteemRepository _scoreRepository;

  // デフォルト重み係数（設計書の仕様通り）
  static const double completionWeight = 0.3; // タスク完了率
  static const double emotionWeight = 0.4; // ポジティブ感情比率
  static const double streakWeight = 0.2; // 継続日数
  static const double engagementWeight = 0.1;

  /// 自己肯定感スコアを計算
  Future<SelfEsteemScore> calculateScore(String userUuid) async {
    final recentData = await _getRecentData(userUuid, days: 7);

    // 1. タスク完了率（0.0 ~ 1.0）
    final completionRate = recentData.totalTasks > 0
        ? recentData.completedTasks / recentData.totalTasks
        : 0.5; // デフォルト値

    // 2. ポジティブ感情比率（0.0 ~ 1.0）
    final positiveEmotions = [EmotionType.happy, EmotionType.neutral];
    final positiveCount =
        recentData.emotions.where(positiveEmotions.contains).length;
    final positiveRatio = recentData.emotions.isNotEmpty
        ? positiveCount / recentData.emotions.length
        : 0.5; // デフォルト値

    // 3. 継続日数スコア（0.0 ~ 1.0）
    final streakScore = math.min(recentData.consecutiveDays / 7, 1.0);

    // 4. AI対話頻度スコア（0.0 ~ 1.0）
    final engagementScore = math.min(recentData.journalEntries / 7, 1.0);

    // 重み付き合計
    final score = (completionRate * completionWeight) +
        (positiveRatio * emotionWeight) +
        (streakScore * streakWeight) +
        (engagementScore * engagementWeight);

    // 0.0-1.0の範囲に制限
    final finalScore = math.max(0.0, math.min(1.0, score));

    // 算出根拠データを作成
    final calculationBasis = {
      'completionRate': completionRate,
      'positiveRatio': positiveRatio,
      'streakScore': streakScore,
      'engagementScore': engagementScore,
      'weights': {
        'completion': completionWeight,
        'emotion': emotionWeight,
        'streak': streakWeight,
        'engagement': engagementWeight,
      },
      'rawData': {
        'totalTasks': recentData.totalTasks,
        'completedTasks': recentData.completedTasks,
        'totalEmotions': recentData.emotions.length,
        'positiveEmotions': positiveCount,
        'consecutiveDays': recentData.consecutiveDays,
        'journalEntries': recentData.journalEntries,
      },
      'calculatedAt': DateTime.now().toIso8601String(),
    };

    // スコアオブジェクトを作成
    final scoreObject = SelfEsteemScore.create(
      uuid: const Uuid().v4(),
      userUuid: userUuid,
      score: finalScore,
      calculationBasisJson: jsonEncode(calculationBasis),
      completionRate: completionRate,
      positiveEmotionRatio: positiveRatio,
      streakScore: streakScore,
      engagementScore: engagementScore,
    );

    // データベースに保存
    return _scoreRepository.createScore(scoreObject);
  }

  /// 過去7日間のデータを取得
  Future<_RecentData> _getRecentData(String userUuid,
      {required int days}) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));

    // タスクデータを取得
    final totalTasks =
        await _taskRepository.getTotalTaskCount(userUuid, start, end);
    final completedTasks =
        await _taskRepository.getCompletedTaskCount(userUuid, start, end);

    // 感情データを取得
    final journalEntries =
        await _journalRepository.getEntriesByDateRange(userUuid, start, end);
    final emotions = journalEntries
        .where((entry) => entry.emotionDetected != null)
        .map((entry) => entry.emotionDetected!)
        .toList();

    // 継続日数を計算
    final consecutiveDays = await _calculateConsecutiveDays(userUuid);

    return _RecentData(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      emotions: emotions,
      consecutiveDays: consecutiveDays,
      journalEntries: journalEntries.length,
    );
  }

  /// 継続日数を計算
  Future<int> _calculateConsecutiveDays(String userUuid) async {
    final today = DateTime.now();
    var consecutiveDays = 0;

    // 今日から遡って連続日数をカウント
    for (var i = 0; i < 30; i++) {
      // 最大30日まで
      final checkDate = today.subtract(Duration(days: i));
      final startOfDay =
          DateTime(checkDate.year, checkDate.month, checkDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // その日にタスクまたは日記エントリがあるかチェック
      final taskCount = await _taskRepository.getTotalTaskCount(
          userUuid, startOfDay, endOfDay);
      final journalCount = (await _journalRepository.getEntriesByDateRange(
              userUuid, startOfDay, endOfDay))
          .length;

      if (taskCount > 0 || journalCount > 0) {
        consecutiveDays++;
      } else {
        break; // 連続が途切れた
      }
    }

    return consecutiveDays;
  }

  /// スコア算出の根拠を取得
  Future<Map<String, dynamic>?> getCalculationBasis(String userUuid) async {
    final latestScore = await _scoreRepository.getLatestScore(userUuid);

    if (latestScore?.calculationBasisJson == null) return null;

    try {
      return jsonDecode(latestScore!.calculationBasisJson!)
          as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// 進歩を検出（0.05ポイント以上の向上）
  Future<bool> detectProgress(String userUuid) async {
    final recentScores = await _scoreRepository.getRecentScores(userUuid, 7);

    if (recentScores.length < 2) return false;

    final latest = recentScores.first.score;
    final previous = recentScores[1].score;

    return latest > previous + 0.05; // 5%以上の向上
  }

  /// 承認メッセージを生成
  Future<String?> generateApprovalMessage(String userUuid) async {
    final hasProgress = await detectProgress(userUuid);

    if (!hasProgress) return null;

    final latestScore = await _scoreRepository.getLatestScore(userUuid);
    if (latestScore == null) return null;

    final level = latestScore.getLevel();
    final messages = _getApprovalMessages(level);

    // ランダムにメッセージを選択
    final random = math.Random();
    return messages[random.nextInt(messages.length)];
  }

  /// レベル別承認メッセージ
  List<String> _getApprovalMessages(ScoreLevel level) {
    switch (level) {
      case ScoreLevel.excellent:
        return [
          '素晴らしい成長ですね！あなたの努力が実を結んでいます。',
          '今日も一歩前進しましたね。この調子で続けていきましょう。',
          'あなたの心の成長を感じます。とても誇らしいです。',
        ];
      case ScoreLevel.good:
        return [
          '良い調子ですね！小さな積み重ねが大きな変化を生んでいます。',
          '着実に前進していますね。あなたのペースを大切にしてください。',
          '今日の頑張りが明日の自信につながっています。',
        ];
      case ScoreLevel.fair:
        return [
          '今日も自分と向き合えましたね。それだけで十分素晴らしいことです。',
          '小さな一歩も大切な前進です。あなたのペースで大丈夫です。',
          '今日の経験が明日の糧になります。お疲れさまでした。',
        ];
      case ScoreLevel.poor:
        return [
          '今日は少し疲れているようですね。無理をせず、自分を労ってください。',
          'つらい時もありますが、あなたは一人ではありません。',
          '今日できたことに目を向けてみませんか。小さなことでも価値があります。',
        ];
      case ScoreLevel.veryPoor:
        return [
          '今はとても大変な時期ですね。休息も大切な自己ケアです。',
          'あなたの気持ちを大切にしてください。今日はゆっくり過ごしましょう。',
          '一歩ずつで大丈夫です。あなたのペースを尊重します。',
        ];
    }
  }
}

/// 過去データの集計結果
class _RecentData {
  _RecentData({
    required this.totalTasks,
    required this.completedTasks,
    required this.emotions,
    required this.consecutiveDays,
    required this.journalEntries,
  });
  final int totalTasks;
  final int completedTasks;
  final List<EmotionType> emotions;
  final int consecutiveDays;
  final int journalEntries;
}
