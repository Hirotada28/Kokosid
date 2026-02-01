import '../models/notification_tone.dart';

/// 通知サービス
class NotificationService {
  /// 通知をスケジュール
  Future<void> schedule({
    required NotificationMessage message,
    required DateTime scheduledTime,
    required RetryStrategy retryStrategy,
  }) async {
    // TODO: 実際の通知実装（flutter_local_notificationsなど）
    // 現在はログ出力のみ
    print(
      'Notification scheduled: ${message.title} at $scheduledTime with tone ${message.tone}',
    );
  }

  /// 即時通知を送信
  Future<void> sendImmediate(NotificationMessage message) async {
    // TODO: 実際の通知実装
    print('Immediate notification: ${message.title} (${message.tone})');
  }

  /// 通知をキャンセル
  Future<void> cancel(String taskUuid) async {
    // TODO: 実際の通知キャンセル実装
    print('Notification cancelled for task: $taskUuid');
  }

  /// 全通知をキャンセル
  Future<void> cancelAll() async {
    // TODO: 実際の通知キャンセル実装
    print('All notifications cancelled');
  }
}
