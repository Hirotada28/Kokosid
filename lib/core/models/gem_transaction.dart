import 'package:isar/isar.dart';

part 'gem_transaction.g.dart';

/// ジェムトランザクションモデル
@collection
class GemTransaction {
  /// ジェムトランザクションを作成
  GemTransaction();

  /// 名前付きコンストラクタ
  GemTransaction.create({
    required this.userId,
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.source,
    this.reason,
    this.relatedEntityId,
    this.expiryDate,
  }) {
    timestamp = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  late String transactionId;

  @Enumerated(EnumType.name)
  late GemTransactionType type;

  late int amount; // 正: 付与、負: 消費

  @Enumerated(EnumType.name)
  late GemSource source;

  String? reason; // 消費理由（例: "AI Report", "Stake Task"）
  String? relatedEntityId; // 関連タスクID等

  @Index()
  DateTime? expiryDate; // null = 無期限

  @Index()
  late DateTime timestamp;

  /// 期限切れかチェック
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// 7日以内に期限切れかチェック
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(now).inDays;
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 7;
  }

  @override
  String toString() =>
      'GemTransaction{userId: $userId, type: $type, amount: $amount, source: $source}';
}

/// ジェムトランザクションタイプ
enum GemTransactionType {
  grant, // 付与
  consume, // 消費
  stake, // ステーク（保留）
  return_, // ステーク返却
  forfeit, // ステーク没収
  expire, // 有効期限切れ
}

/// ジェムソース
enum GemSource {
  purchase, // 単発購入
  subscription, // Proプラン月次付与
  promotion, // プロモーション
  refund, // 返金
}
