import 'package:isar/isar.dart';

part 'salvage_session_record.g.dart';

/// サルベージセッション記録モデル
@collection
class SalvageSessionRecord {
  /// サルベージセッション記録を作成
  SalvageSessionRecord();

  /// 名前付きコンストラクタ
  SalvageSessionRecord.create({
    required this.sessionId,
    required this.userId,
    required this.taskId,
    required this.encryptedContent,
  }) {
    status = SalvageStatus.inProgress;
    startedAt = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String sessionId;

  @Index()
  late String userId;

  late String taskId;

  // セッション内容（暗号化JSON）
  late String encryptedContent;

  @Enumerated(EnumType.name)
  late SalvageStatus status;

  @Index()
  late DateTime startedAt;
  DateTime? completedAt;

  /// セッションを完了
  void complete() {
    status = SalvageStatus.completed;
    completedAt = DateTime.now();
  }

  /// セッションを放棄
  void abandon() {
    status = SalvageStatus.abandoned;
    completedAt = DateTime.now();
  }

  /// 進行中かチェック
  bool get isInProgress => status == SalvageStatus.inProgress;

  /// 完了済みかチェック
  bool get isCompleted => status == SalvageStatus.completed;

  /// 今月のセッションかチェック
  bool get isThisMonth {
    final now = DateTime.now();
    return startedAt.year == now.year && startedAt.month == now.month;
  }

  @override
  String toString() =>
      'SalvageSessionRecord{sessionId: $sessionId, userId: $userId, status: $status}';
}

/// サルベージステータス
enum SalvageStatus {
  inProgress,
  completed,
  abandoned,
}
