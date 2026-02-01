import 'package:isar/isar.dart';

part 'task.g.dart';

/// タスクモデル
@collection
class Task {
  /// タスクを作成
  Task();

  /// 名前付きコンストラクタ
  Task.create({
    required this.uuid,
    required this.userUuid,
    required this.title,
    this.description,
    this.originalTaskUuid,
    this.isMicroTask = false,
    this.estimatedMinutes,
    this.context,
    this.dueDate,
    this.priority = TaskPriority.medium,
  }) {
    createdAt = DateTime.now();
    status = TaskStatus.pending;
  }
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String userUuid;

  late String title;
  String? description;
  String? originalTaskUuid; // 親タスクID（マイクロタスクの場合）
  bool isMicroTask = false;
  int? estimatedMinutes;
  String? context;
  DateTime? completedAt;
  DateTime createdAt = DateTime.now();
  DateTime? dueDate;

  @Enumerated(EnumType.name)
  TaskPriority priority = TaskPriority.medium;

  @Enumerated(EnumType.name)
  TaskStatus status = TaskStatus.pending;

  /// タスクを完了
  void complete() {
    completedAt = DateTime.now();
    status = TaskStatus.completed;
  }

  /// タスクを開始
  void start() {
    status = TaskStatus.inProgress;
  }

  /// タスクをキャンセル
  void cancel() {
    status = TaskStatus.cancelled;
  }

  /// 完了済みかチェック
  bool get isCompleted => completedAt != null && status == TaskStatus.completed;

  /// 期限切れかチェック
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// 今日が期限かチェック
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year && now.month == due.month && now.day == due.day;
  }

  @override
  String toString() =>
      'Task{uuid: $uuid, title: $title, isMicroTask: $isMicroTask, status: $status}';
}

/// タスクの優先度
enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

/// タスクのステータス
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}
