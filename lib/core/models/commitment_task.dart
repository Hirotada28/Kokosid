import 'package:isar/isar.dart';

part 'commitment_task.g.dart';

/// 本気モードタスクモデル
@collection
class CommitmentTask {
  /// 本気モードタスクを作成
  CommitmentTask();

  /// 名前付きコンストラクタ
  CommitmentTask.create({
    required this.taskId,
    required this.userId,
    required this.stakedGems,
    required this.companionLevel,
    this.preExecutionSupportAt,
    this.midExecutionSupportAt,
    this.postExecutionSupportAt,
  }) {
    status = CommitmentStatus.pending;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index()
  late String taskId; // Task.uuid への参照

  @Index()
  late String userId;

  late int stakedGems;

  @Enumerated(EnumType.name)
  late AICompanionLevel companionLevel;

  @Enumerated(EnumType.name)
  late CommitmentStatus status;

  // AI伴走スケジュール
  DateTime? preExecutionSupportAt;
  DateTime? midExecutionSupportAt;
  DateTime? postExecutionSupportAt;

  // 完了情報
  DateTime? completedAt;
  double? achievementScore;
  double? scoreMultiplier;
  double? honestyBonus;

  // 失敗情報
  DateTime? failedAt;
  bool wasHonestFailure = false;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// タスクを完了
  void complete({
    required double achievementScore,
    required double scoreMultiplier,
    double? honestyBonus,
  }) {
    status = CommitmentStatus.completed;
    completedAt = DateTime.now();
    this.achievementScore = achievementScore;
    this.scoreMultiplier = scoreMultiplier;
    this.honestyBonus = honestyBonus;
    updatedAt = DateTime.now();
  }

  /// タスクを失敗
  void fail({required bool wasHonest}) {
    status = CommitmentStatus.failed;
    failedAt = DateTime.now();
    wasHonestFailure = wasHonest;
    updatedAt = DateTime.now();
  }

  /// タスクを進行中に設定
  void startProgress() {
    status = CommitmentStatus.inProgress;
    updatedAt = DateTime.now();
  }

  /// 完了済みかチェック
  bool get isCompleted => status == CommitmentStatus.completed;

  /// 失敗済みかチェック
  bool get isFailed => status == CommitmentStatus.failed;

  /// 黄金の成功体験かチェック
  bool get isGoldenSuccess => isCompleted && stakedGems == 5;

  @override
  String toString() =>
      'CommitmentTask{taskId: $taskId, stakedGems: $stakedGems, status: $status}';
}

/// AI伴走レベル
enum AICompanionLevel {
  none, // 0 Gems: 明示的な質問にのみ応答
  quiet, // 1 Gem: 静かに見守る
  moderate, // 3 Gems: 期限前に1回リマインド
  intensive, // 5 Gems: 3段階サポート + 優先応答
}

/// 本気モードステータス
enum CommitmentStatus {
  pending,
  inProgress,
  completed,
  failed,
}
