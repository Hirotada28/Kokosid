import '../models/task.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';

/// タスクデータリポジトリ
class TaskRepository {
  TaskRepository(this._databaseService);
  final DatabaseService _databaseService;

  /// ストレージサービスを取得
  LocalStorageService get _storage => _databaseService.storage;

  /// タスクを作成
  Future<Task> createTask(Task task) async {
    await _storage.putTask(task);
    return task;
  }

  /// UUIDでタスクを取得
  Future<Task?> getTaskByUuid(String uuid) async =>
      _storage.getTaskByUuid(uuid);

  /// ユーザーの全タスクを取得
  Future<List<Task>> getTasksByUser(String userUuid) async =>
      _storage.getTasksByUserUuid(userUuid);

  /// ユーザーの未完了タスクを取得
  Future<List<Task>> getPendingTasksByUser(String userUuid) async =>
      _storage.getPendingTasksByUserUuid(userUuid);

  /// ユーザーの完了済みタスクを取得
  Future<List<Task>> getCompletedTasksByUser(String userUuid) async =>
      _storage.getCompletedTasksByUserUuid(userUuid);

  /// 今日のタスクを取得
  Future<List<Task>> getTodayTasks(String userUuid) async =>
      _storage.getTodayTasksByUserUuid(userUuid);

  /// マイクロタスクを取得
  Future<List<Task>> getMicroTasks(String originalTaskUuid) async =>
      _storage.getMicroTasksByOriginalUuid(originalTaskUuid);

  /// タスクを更新
  Future<Task> updateTask(Task task) async {
    await _storage.putTask(task);
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
  Future<bool> deleteTask(String uuid) async => _storage.deleteTaskByUuid(uuid);

  /// 期間内の完了タスク数を取得
  Future<int> getCompletedTaskCount(
          String userUuid, DateTime start, DateTime end) async =>
      _storage.getCompletedTaskCountByUserUuidAndDateRange(
          userUuid, start, end);

  /// 期間内の総タスク数を取得
  Future<int> getTotalTaskCount(
          String userUuid, DateTime start, DateTime end) async =>
      _storage.getTotalTaskCountByUserUuidAndDateRange(userUuid, start, end);

  /// 期間内のタスクを取得
  Future<List<Task>> getTasksByDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _storage.getTasksByUserUuidAndDateRange(userUuid, start, end);
}
