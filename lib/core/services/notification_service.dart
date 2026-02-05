import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/notification_tone.dart';

/// 通知サービス
/// flutter_local_notificationsを使用した通知機能の実装
class NotificationService {
  NotificationService._();

  static NotificationService? _instance;
  static NotificationService get instance =>
      _instance ??= NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  int _notificationIdCounter = 0;

  // taskUuid -> notificationId のマッピング
  final Map<String, int> _taskNotificationIds = {};

  /// サービスを初期化
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    // タイムゾーンの初期化
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    // Android設定
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS設定
    final iosSettings = DarwinInitializationSettings(
      requestBadgePermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // macOS設定
    const macOSSettings = DarwinInitializationSettings(
      requestBadgePermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOSSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // 通知権限をリクエスト（Android 13以上）
    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }

    _isInitialized = true;
  }

  /// Android通知権限をリクエスト
  Future<void> _requestAndroidPermission() async {
    final androidPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  /// iOS旧式コールバック
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // iOS 10以前の通知受信処理
  }

  /// 通知タップ時のコールバック
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // タスクUUIDがpayloadに含まれている場合の処理
      // 将来的にはタスク詳細画面への遷移などを実装
    }
  }

  /// 通知をスケジュール
  Future<void> schedule({
    required NotificationMessage message,
    required DateTime scheduledTime,
    required RetryStrategy retryStrategy,
  }) async {
    await _ensureInitialized();

    final notificationId = _generateNotificationId();
    if (message.taskUuid != null) {
      _taskNotificationIds[message.taskUuid!] = notificationId;
    }

    final androidDetails = _getAndroidNotificationDetails(message.tone);
    final iosDetails = _getIOSNotificationDetails(message.tone);

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      message.title,
      message.body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: message.taskUuid,
    );
  }

  /// 即時通知を送信
  Future<void> sendImmediate(NotificationMessage message) async {
    await _ensureInitialized();

    final notificationId = _generateNotificationId();
    if (message.taskUuid != null) {
      _taskNotificationIds[message.taskUuid!] = notificationId;
    }

    final androidDetails = _getAndroidNotificationDetails(message.tone);
    final iosDetails = _getIOSNotificationDetails(message.tone);

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      message.title,
      message.body,
      notificationDetails,
      payload: message.taskUuid,
    );
  }

  /// 通知をキャンセル
  Future<void> cancel(String taskUuid) async {
    await _ensureInitialized();

    final notificationId = _taskNotificationIds[taskUuid];
    if (notificationId != null) {
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
      _taskNotificationIds.remove(taskUuid);
    }
  }

  /// 全通知をキャンセル
  Future<void> cancelAll() async {
    await _ensureInitialized();

    await _flutterLocalNotificationsPlugin.cancelAll();
    _taskNotificationIds.clear();
  }

  /// 保留中の通知を取得
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    await _ensureInitialized();
    return _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// トーンに基づくAndroid通知詳細を取得
  AndroidNotificationDetails _getAndroidNotificationDetails(
    NotificationTone tone,
  ) {
    String channelId;
    String channelName;
    String channelDescription;
    Importance importance;

    switch (tone) {
      case NotificationTone.gentle:
        channelId = 'kokosid_gentle';
        channelName = '優しい通知';
        channelDescription = '不安や疲労時に表示される優しいトーンの通知';
        importance = Importance.defaultImportance;
      case NotificationTone.encouraging:
        channelId = 'kokosid_encouraging';
        channelName = '励まし通知';
        channelDescription = 'ポジティブな状態で表示される励ましトーンの通知';
        importance = Importance.high;
      case NotificationTone.neutral:
        channelId = 'kokosid_neutral';
        channelName = '標準通知';
        channelDescription = '標準のトーンの通知';
        importance = Importance.defaultImportance;
    }

    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: tone == NotificationTone.encouraging
          ? Priority.high
          : Priority.defaultPriority,
      ticker: 'Kokosid',
      category: AndroidNotificationCategory.reminder,
    );
  }

  /// トーンに基づくiOS通知詳細を取得
  DarwinNotificationDetails _getIOSNotificationDetails(
    NotificationTone tone,
  ) =>
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: tone == NotificationTone.gentle
            ? InterruptionLevel.passive
            : InterruptionLevel.active,
      );

  /// 通知IDを生成
  int _generateNotificationId() => _notificationIdCounter++;

  /// 初期化を確認
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// テスト用: インスタンスをリセット
  static void resetForTesting() {
    _instance = null;
  }
}
