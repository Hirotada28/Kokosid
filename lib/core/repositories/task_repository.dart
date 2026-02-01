import 'package:isar/isar.dart';
import '../models/task.dart';
import '../services/database_service.dart';

/// タスクデータリポジトリ
class TaskRepository {
  TaskRepository(this._databaseService);
  final DatabaseService _databaseService;

  /// タスクを作成
  Future<Task> createTask(Task task) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });

    return task;
  }

  /// UUIDでタスクを取得
  Future<Task?> getTaskByUuid(String uuid) async {
    final isar = _databaseService.isar;

    return isar.tasks.filter().uuidEqualTo(uuid).findFirst();
  }

  /// ユーザーの全タスクを取得
  Future<List<Task>> getTasksByUser(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// ユーザーの未完了タスクを取得
  Future<List<Task>> getPendingTasksByUser(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .statusEqualTo(TaskStatus.pending)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// ユーザーの完了済みタスクを取得
  Future<List<Task>> getCompletedTasksByUser(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .statusEqualTo(TaskStatus.completed)
        .sortByCompletedAtDesc()
        .findAll();
  }

  /// 今日のタスクを取得
  Future<List<Task>> getTodayTasks(String userUuid) async {
    final isar = _databaseService.isar;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(startOfDay, endOfDay)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// マイクロタスクを取得
  Future<List<Task>> getMicroTasks(String originalTaskUuid) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .originalTaskUuidEqualTo(originalTaskUuid)
        .isMicroTaskEqualTo(true)
        .sortByCreatedAt()
        .findAll();
  }

  /// タスクを更新
  Future<Task> updateTask(Task task) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });

    return task;
  }

  /// タスクを完了
  Future<Task> completeTask(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) {
      throw Exception('タスクが見つかりません: $uuid');
    }

    task.complete();
    return updateTask(task);
  }

  /// タスクを開始
  Future<Task> startTask(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) {
      throw Exception('タスクが見つかりません: $uuid');
    }

    task.start();
    return updateTask(task);
  }

  /// タスクを削除
  Future<bool> deleteTask(String uuid) async {
    final isar = _databaseService.isar;

    return isar.writeTxn(
        () async => isar.tasks.filter().uuidEqualTo(uuid).deleteFirst());
  }

  /// 期間内の完了タスク数を取得
  Future<int> getCompletedTaskCount(
      String userUuid, DateTime start, DateTime end) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .statusEqualTo(TaskStatus.completed)
        .completedAtBetween(start, end)
        .count();
  }

  /// 期間内の総タスク数を取得
  Future<int> getTotalTaskCount(
      String userUuid, DateTime start, DateTime end) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(start, end)
        .count();
  }

  /// 期間内のタスクを取得
  Future<List<Task>> getTasksByDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final isar = _databaseService.isar;

    return isar.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(start, end)
        .sortByCreatedAtDesc()
        .findAll();
  }
}
