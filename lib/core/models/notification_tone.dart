/// 通知のトーン
enum NotificationTone {
  /// 優しいトーン（不安・疲労時）
  gentle,

  /// 励ましトーン（ポジティブ時）
  encouraging,

  /// 中立トーン
  neutral,
}

/// 通知の再送戦略
class RetryStrategy {
  const RetryStrategy({
    required this.delayMinutes,
    required this.maxRetries,
  });

  final int delayMinutes;
  final int maxRetries;

  /// 優しいトーン用の再送戦略（30分後）
  static const gentle = RetryStrategy(
    delayMinutes: 30,
    maxRetries: 2,
  );

  /// 励ましトーン用の再送戦略（即時）
  static const encouraging = RetryStrategy(
    delayMinutes: 0,
    maxRetries: 1,
  );

  /// 中立トーン用の再送戦略（15分後）
  static const neutral = RetryStrategy(
    delayMinutes: 15,
    maxRetries: 2,
  );
}

/// 通知メッセージ
class NotificationMessage {
  const NotificationMessage({
    required this.title,
    required this.body,
    required this.tone,
    this.taskUuid,
  });

  final String title;
  final String body;
  final NotificationTone tone;
  final String? taskUuid;
}
