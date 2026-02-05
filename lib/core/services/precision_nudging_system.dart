import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../models/notification_tone.dart';
import '../models/task.dart';
import '../models/user_context.dart';
import '../repositories/journal_repository.dart';
import 'notification_service.dart';
import 'productive_hour_predictor.dart';
import 'user_context_service.dart';

/// プレシジョン・ナッジング・システム
class PrecisionNudgingSystem {
  PrecisionNudgingSystem({
    required ProductiveHourPredictor hourPredictor,
    required NotificationService notificationService,
    required UserContextService contextService,
    required JournalRepository journalRepository,
  })  : _hourPredictor = hourPredictor,
        _notificationService = notificationService,
        _contextService = contextService,
        _journalRepository = journalRepository;

  final ProductiveHourPredictor _hourPredictor;
  final NotificationService _notificationService;
  final UserContextService _contextService;
  final JournalRepository _journalRepository;

  /// 最適なタイミングと内容で通知をスケジュール
  Future<void> scheduleOptimalNotification(Task task) async {
    // 1. ユーザー状態を取得
    final userState = await _getCurrentUserState(task.userUuid);

    // 2. 最適な時間を予測
    final optimalHour = await _hourPredictor.predictOptimalTime(
      task.userUuid,
      task,
    );

    // 3. 心理状態に応じたトーンを決定
    final tone = _determineTone(userState.recentEmotion);

    // 4. パーソナライズされたメッセージを生成
    final message = _generateMessage(task, tone, userState);

    // 5. 通知をスケジュール
    await _notificationService.schedule(
      message: message,
      scheduledTime: _hourPredictor.getNextOccurrence(optimalHour),
      retryStrategy: _getRetryStrategy(tone),
    );
  }

  /// 現在のユーザー状態を取得
  Future<_UserState> _getCurrentUserState(String userUuid) async {
    final context = await _contextService.getUserContext(userUuid);

    // 最新の感情を取得（過去1日以内）
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final recentEntries = await _journalRepository.getEntriesByDateRange(
      userUuid,
      yesterday,
      now,
    );

    Emotion? recentEmotion;
    if (recentEntries.isNotEmpty &&
        recentEntries.first.emotionDetected != null) {
      // 最新のエントリから感情を復元
      recentEmotion = Emotion(
        type: recentEntries.first.emotionDetected!,
        confidence: recentEntries.first.emotionConfidence ?? 0.5,
        scores: {},
        isNegative: _isNegativeEmotion(recentEntries.first.emotionDetected!),
      );
    }

    return _UserState(
      userUuid: userUuid,
      recentEmotion: recentEmotion,
      context: context,
    );
  }

  /// 心理状態に応じたトーンを決定
  NotificationTone _determineTone(Emotion? recentEmotion) {
    if (recentEmotion == null) {
      return NotificationTone.neutral;
    }

    switch (recentEmotion.type) {
      case EmotionType.anxious:
      case EmotionType.tired:
        return NotificationTone.gentle;
      case EmotionType.happy:
        return NotificationTone.encouraging;
      default:
        return NotificationTone.neutral;
    }
  }

  /// パーソナライズされたメッセージを生成
  NotificationMessage _generateMessage(
    Task task,
    NotificationTone tone,
    _UserState userState,
  ) {
    final String title;
    final String body;

    switch (tone) {
      case NotificationTone.gentle:
        title = '無理せず、少しずつ';
        body = '「${task.title}」に取り組んでみませんか？';
        break;
      case NotificationTone.encouraging:
        title = '調子が良さそうですね！';
        body = '「${task.title}」をやってみましょう！';
        break;
      case NotificationTone.neutral:
        title = 'タスクのリマインダー';
        body = '「${task.title}」の時間です';
        break;
    }

    return NotificationMessage(
      title: title,
      body: body,
      tone: tone,
      taskUuid: task.uuid,
    );
  }

  /// 再送戦略を取得
  RetryStrategy _getRetryStrategy(NotificationTone tone) {
    switch (tone) {
      case NotificationTone.gentle:
        return RetryStrategy.gentle;
      case NotificationTone.encouraging:
        return RetryStrategy.encouraging;
      case NotificationTone.neutral:
        return RetryStrategy.neutral;
    }
  }

  /// 感情がネガティブかどうか判定
  bool _isNegativeEmotion(EmotionType type) =>
      type == EmotionType.sad ||
      type == EmotionType.angry ||
      type == EmotionType.anxious ||
      type == EmotionType.tired;
}

/// ユーザー状態（内部用）
class _UserState {
  const _UserState({
    required this.userUuid,
    required this.recentEmotion,
    required this.context,
  });

  final String userUuid;
  final Emotion? recentEmotion;
  final UserContext context;
}
