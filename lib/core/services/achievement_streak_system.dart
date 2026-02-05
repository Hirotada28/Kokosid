import '../models/notification_tone.dart';
import '../repositories/task_repository.dart';
import 'notification_service.dart';

/// 連続達成演出システム
class AchievementStreakSystem {
  AchievementStreakSystem({
    required TaskRepository taskRepository,
    required NotificationService notificationService,
  })  : _taskRepository = taskRepository,
        _notificationService = notificationService;

  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  /// 連続達成の閾値
  static const int streakThreshold = 3;

  /// タスク完了時に連続達成をチェックして演出
  Future<void> checkAndCelebrateStreak(String userUuid) async {
    final streakCount = await getCurrentStreak(userUuid);

    if (streakCount >= streakThreshold) {
      await _sendStreakCelebration(streakCount);
    }
  }

  /// 現在の連続達成数を取得
  Future<int> getCurrentStreak(String userUuid) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 今日完了したタスクを取得
    final todayTasks = await _taskRepository.getTasksByDateRange(
      userUuid,
      today,
      now,
    );

    // 完了したタスクのみをフィルタリングし、完了時刻でソート
    final completedToday = todayTasks
        .where((task) => task.isCompleted && task.completedAt != null)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    if (completedToday.isEmpty) {
      return 0;
    }

    // 最新の完了タスクから遡って連続数をカウント
    var streakCount = 0;
    DateTime? lastCompletedAt;

    for (final task in completedToday) {
      if (lastCompletedAt == null) {
        // 最初のタスク
        streakCount = 1;
        lastCompletedAt = task.completedAt;
      } else {
        // 前のタスクとの時間差をチェック（60分以内なら連続とみなす）
        final timeDiff = lastCompletedAt.difference(task.completedAt!);
        if (timeDiff.inMinutes <= 60) {
          streakCount++;
          lastCompletedAt = task.completedAt;
        } else {
          // 連続が途切れた
          break;
        }
      }
    }

    return streakCount;
  }

  /// 連続達成のお祝い通知を送信
  Future<void> _sendStreakCelebration(int streakCount) async {
    final message = NotificationMessage(
      title: '🔥 連続達成！',
      body: '$streakCount個のタスクを連続で完了しました！素晴らしいです！',
      tone: NotificationTone.encouraging,
    );

    await _notificationService.sendImmediate(message);
  }

  /// 今日の連続達成記録を取得
  Future<List<StreakRecord>> getTodayStreakRecords(String userUuid) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayTasks = await _taskRepository.getTasksByDateRange(
      userUuid,
      today,
      now,
    );

    final completedToday = todayTasks
        .where((task) => task.isCompleted && task.completedAt != null)
        .toList()
      ..sort((a, b) => a.completedAt!.compareTo(b.completedAt!));

    final records = <StreakRecord>[];
    var currentStreak = 0;
    DateTime? streakStartTime;
    DateTime? lastCompletedAt;

    for (final task in completedToday) {
      if (lastCompletedAt == null) {
        // 最初のタスク
        currentStreak = 1;
        streakStartTime = task.completedAt;
        lastCompletedAt = task.completedAt;
      } else {
        final timeDiff = task.completedAt!.difference(lastCompletedAt);
        if (timeDiff.inMinutes <= 60) {
          // 連続継続
          currentStreak++;
          lastCompletedAt = task.completedAt;
        } else {
          // 連続が途切れた - 前の記録を保存
          if (currentStreak >= streakThreshold) {
            records.add(
              StreakRecord(
                count: currentStreak,
                startTime: streakStartTime!,
                endTime: lastCompletedAt,
              ),
            );
          }
          // 新しい連続を開始
          currentStreak = 1;
          streakStartTime = task.completedAt;
          lastCompletedAt = task.completedAt;
        }
      }
    }

    // 最後の連続を記録
    if (currentStreak >= streakThreshold && streakStartTime != null) {
      records.add(
        StreakRecord(
          count: currentStreak,
          startTime: streakStartTime,
          endTime: lastCompletedAt!,
        ),
      );
    }

    return records;
  }

  /// 週間の連続達成統計を取得
  Future<StreakStats> getWeeklyStreakStats(String userUuid) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekTasks = await _taskRepository.getTasksByDateRange(
      userUuid,
      weekAgo,
      now,
    );

    final completedTasks = weekTasks
        .where((task) => task.isCompleted && task.completedAt != null)
        .toList();

    // 日別の連続達成をカウント
    var totalStreaks = 0;
    var maxStreak = 0;

    for (var i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayTasks = completedTasks
          .where((task) =>
              task.completedAt!.isAfter(dayStart) &&
              task.completedAt!.isBefore(dayEnd))
          .toList()
        ..sort((a, b) => a.completedAt!.compareTo(b.completedAt!));

      var dayStreak = 0;
      DateTime? lastCompleted;

      for (final task in dayTasks) {
        if (lastCompleted == null) {
          dayStreak = 1;
        } else {
          final diff = task.completedAt!.difference(lastCompleted);
          if (diff.inMinutes <= 60) {
            dayStreak++;
          } else {
            if (dayStreak >= streakThreshold) {
              totalStreaks++;
            }
            dayStreak = 1;
          }
        }
        lastCompleted = task.completedAt;
      }

      if (dayStreak >= streakThreshold) {
        totalStreaks++;
      }

      if (dayStreak > maxStreak) {
        maxStreak = dayStreak;
      }
    }

    return StreakStats(
      totalStreaks: totalStreaks,
      maxStreak: maxStreak,
      averagePerDay: totalStreaks / 7,
    );
  }
}

/// 連続達成記録
class StreakRecord {
  const StreakRecord({
    required this.count,
    required this.startTime,
    required this.endTime,
  });

  final int count;
  final DateTime startTime;
  final DateTime endTime;

  Duration get duration => endTime.difference(startTime);
}

/// 連続達成統計
class StreakStats {
  const StreakStats({
    required this.totalStreaks,
    required this.maxStreak,
    required this.averagePerDay,
  });

  final int totalStreaks;
  final int maxStreak;
  final double averagePerDay;
}
