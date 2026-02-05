import 'package:isar/isar.dart';

part 'subscription.g.dart';

/// サブスクリプションモデル
@collection
class Subscription {
  /// サブスクリプションを作成
  Subscription();

  /// 名前付きコンストラクタ
  Subscription.create({
    required this.userId,
    required this.plan,
    required this.status,
    required this.startDate,
    this.endDate,
    this.nextRenewalDate,
    this.cancelledAt,
    this.gracePeriodEnd,
    this.platformProductId,
    this.platformTransactionId,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  @Enumerated(EnumType.name)
  late SubscriptionPlan plan;

  @Enumerated(EnumType.name)
  late SubscriptionStatus status;

  late DateTime startDate;
  DateTime? endDate;
  DateTime? nextRenewalDate;
  DateTime? cancelledAt;

  // 猶予期間
  DateTime? gracePeriodEnd;

  // プラットフォーム固有情報
  String? platformProductId;
  String? platformTransactionId;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// サブスクリプションをキャンセル
  void cancel() {
    status = SubscriptionStatus.cancelled;
    cancelledAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// サブスクリプションを更新
  void renew(DateTime newRenewalDate) {
    status = SubscriptionStatus.active;
    nextRenewalDate = newRenewalDate;
    updatedAt = DateTime.now();
  }

  /// 猶予期間を設定
  void setGracePeriod(DateTime gracePeriodEnd) {
    status = SubscriptionStatus.gracePeriod;
    this.gracePeriodEnd = gracePeriodEnd;
    updatedAt = DateTime.now();
  }

  /// サブスクリプションを期限切れにする
  void expire() {
    status = SubscriptionStatus.expired;
    updatedAt = DateTime.now();
  }

  /// アクティブかチェック
  bool get isActive => status == SubscriptionStatus.active;

  /// 猶予期間中かチェック
  bool get isInGracePeriod => status == SubscriptionStatus.gracePeriod;

  @override
  String toString() =>
      'Subscription{userId: $userId, plan: $plan, status: $status}';
}

/// サブスクリプションプラン
enum SubscriptionPlan {
  free,
  pro,
}

/// サブスクリプションステータス
enum SubscriptionStatus {
  none, // サブスクリプションなし
  active, // アクティブ
  cancelled, // キャンセル済み（期間終了まで有効）
  expired, // 期限切れ
  gracePeriod, // 猶予期間中
}
