import '../models/task.dart';
import '../repositories/task_repository.dart';

/// 生産的時間帯予測サービス
class ProductiveHourPredictor {
  ProductiveHourPredictor(this._taskRepository);

  final TaskRepository _taskRepository;

  /// 過去30日間のデータから生産的時間帯を予測
  Future<int> predictOptimalTime(String userUuid, Task task) async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // 過去30日間の完了タスクを取得
    final completedTasks = await _getCompletedTasksInRange(
      userUuid,
      thirtyDaysAgo,
      now,
    );

    if (completedTasks.isEmpty) {
      // データがない場合はデフォルトの時間帯を返す（午前10時）
      return 10;
    }

    // 時間帯別の完了率を計算
    final hourlyCompletionRates = _calculateHourlyCompletionRates(
      completedTasks,
    );

    // 最も完了率の高い時間帯を返す
    return _findOptimalHour(hourlyCompletionRates);
  }

  /// 時間帯別の完了率を取得
  Future<Map<int, double>> getHourlyCompletionRates(String userUuid) async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final completedTasks = await _getCompletedTasksInRange(
      userUuid,
      thirtyDaysAgo,
      now,
    );

    return _calculateHourlyCompletionRates(completedTasks);
  }

  /// 指定期間内の完了タスクを取得
  Future<List<Task>> _getCompletedTasksInRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final allTasks = await _taskRepository.getTasksByDateRange(
      userUuid,
      start,
      end,
    );

    return allTasks
        .where((task) =>
            task.isCompleted &&
            task.completedAt != null &&
            task.completedAt!.isAfter(start) &&
            task.completedAt!.isBefore(end))
        .toList();
  }

  /// 時間帯別の完了率を計算
  Map<int, double> _calculateHourlyCompletionRates(List<Task> completedTasks) {
    // 時間帯別の完了数をカウント
    final hourlyCompletions = <int, int>{};

    for (final task in completedTasks) {
      if (task.completedAt != null) {
        final hour = task.completedAt!.hour;
        hourlyCompletions[hour] = (hourlyCompletions[hour] ?? 0) + 1;
      }
    }

    // 完了率を計算（総完了数に対する割合）
    final totalCompletions = completedTasks.length;
    final hourlyRates = <int, double>{};

    for (final entry in hourlyCompletions.entries) {
      hourlyRates[entry.key] = entry.value / totalCompletions;
    }

    return hourlyRates;
  }

  /// 最も完了率の高い時間帯を見つける
  int _findOptimalHour(Map<int, double> hourlyRates) {
    if (hourlyRates.isEmpty) {
      return 10; // デフォルト: 午前10時
    }

    int optimalHour = 10;
    double maxRate = 0.0;

    for (final entry in hourlyRates.entries) {
      if (entry.value > maxRate) {
        maxRate = entry.value;
        optimalHour = entry.key;
      }
    }

    return optimalHour;
  }

  /// 次の最適な時刻を取得
  DateTime getNextOccurrence(int hour) {
    final now = DateTime.now();
    var nextOccurrence = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      0,
    );

    // 既に過ぎている場合は翌日にする
    if (nextOccurrence.isBefore(now)) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 1));
    }

    return nextOccurrence;
  }
}
