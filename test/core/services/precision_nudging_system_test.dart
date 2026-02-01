import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/emotion.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/notification_tone.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/models/user_context.dart';
import 'package:kokosid/core/repositories/journal_repository.dart';
import 'package:kokosid/core/services/notification_service.dart';
import 'package:kokosid/core/services/precision_nudging_system.dart';
import 'package:kokosid/core/services/productive_hour_predictor.dart';
import 'package:kokosid/core/services/user_context_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'precision_nudging_system_test.mocks.dart';

@GenerateMocks([
  ProductiveHourPredictor,
  NotificationService,
  UserContextService,
  JournalRepository,
])
void main() {
  group('PrecisionNudgingSystem', () {
    late MockProductiveHourPredictor mockHourPredictor;
    late MockNotificationService mockNotificationService;
    late MockUserContextService mockContextService;
    late MockJournalRepository mockJournalRepository;
    late PrecisionNudgingSystem system;

    setUp(() {
      mockHourPredictor = MockProductiveHourPredictor();
      mockNotificationService = MockNotificationService();
      mockContextService = MockUserContextService();
      mockJournalRepository = MockJournalRepository();
      system = PrecisionNudgingSystem(
        hourPredictor: mockHourPredictor,
        notificationService: mockNotificationService,
        contextService: mockContextService,
        journalRepository: mockJournalRepository,
      );
    });

    group('scheduleOptimalNotification', () {
      test('不安状態のユーザーには優しいトーンで通知する', () async {
        // Given: 不安状態のユーザー
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'レポートを書く',
        );

        final context = UserContext(
          userId: 'user-1',
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: true,
            isStable: false,
            averageScore: 0.3,
          ),
          motivationLevel: 0.3,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final anxiousEntry = JournalEntry.create(
          uuid: 'entry-1',
          userUuid: 'user-1',
          emotionDetected: EmotionType.anxious,
          emotionConfidence: 0.8,
        );

        when(mockContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          'user-1',
          any,
          any,
        )).thenAnswer((_) async => [anxiousEntry]);
        when(mockHourPredictor.predictOptimalTime('user-1', task))
            .thenAnswer((_) async => 14);
        when(mockHourPredictor.getNextOccurrence(14))
            .thenReturn(DateTime.now().add(const Duration(hours: 1)));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 優しいトーンで通知される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(message.tone, equals(NotificationTone.gentle));
        expect(retryStrategy.delayMinutes, equals(30));
      });

      test('ポジティブ状態のユーザーには励ましトーンで通知する', () async {
        // Given: ポジティブ状態のユーザー
        final task = Task.create(
          uuid: 'task-2',
          userUuid: 'user-2',
          title: 'プレゼン準備',
        );

        final context = UserContext(
          userId: 'user-2',
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.8,
          ),
          motivationLevel: 0.8,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final happyEntry = JournalEntry.create(
          uuid: 'entry-2',
          userUuid: 'user-2',
          emotionDetected: EmotionType.happy,
          emotionConfidence: 0.9,
        );

        when(mockContextService.getUserContext('user-2'))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          'user-2',
          any,
          any,
        )).thenAnswer((_) async => [happyEntry]);
        when(mockHourPredictor.predictOptimalTime('user-2', task))
            .thenAnswer((_) async => 10);
        when(mockHourPredictor.getNextOccurrence(10))
            .thenReturn(DateTime.now().add(const Duration(hours: 1)));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 励ましトーンで通知される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(message.tone, equals(NotificationTone.encouraging));
        expect(retryStrategy.delayMinutes, equals(0));
      });

      test('疲労状態のユーザーには優しいトーンで通知する', () async {
        // Given: 疲労状態のユーザー
        final task = Task.create(
          uuid: 'task-3',
          userUuid: 'user-3',
          title: 'メール返信',
        );

        final context = UserContext(
          userId: 'user-3',
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.4,
          ),
          motivationLevel: 0.4,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final tiredEntry = JournalEntry.create(
          uuid: 'entry-3',
          userUuid: 'user-3',
          emotionDetected: EmotionType.tired,
          emotionConfidence: 0.7,
        );

        when(mockContextService.getUserContext('user-3'))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          'user-3',
          any,
          any,
        )).thenAnswer((_) async => [tiredEntry]);
        when(mockHourPredictor.predictOptimalTime('user-3', task))
            .thenAnswer((_) async => 16);
        when(mockHourPredictor.getNextOccurrence(16))
            .thenReturn(DateTime.now().add(const Duration(hours: 2)));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 優しいトーンで通知される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(message.tone, equals(NotificationTone.gentle));
        expect(retryStrategy.delayMinutes, equals(30));
      });
    });
  });

  // **Feature: act-based-self-management, Property 7: 心理状態適応型通知システム**
  // **Validates: Requirements 4.2, 4.3, 4.4**
  group('Property-Based Tests: 心理状態適応型通知システム', () {
    late MockProductiveHourPredictor mockHourPredictor;
    late MockNotificationService mockNotificationService;
    late MockUserContextService mockContextService;
    late MockJournalRepository mockJournalRepository;
    late PrecisionNudgingSystem system;

    setUp(() {
      mockHourPredictor = MockProductiveHourPredictor();
      mockNotificationService = MockNotificationService();
      mockContextService = MockUserContextService();
      mockJournalRepository = MockJournalRepository();
      system = PrecisionNudgingSystem(
        hourPredictor: mockHourPredictor,
        notificationService: mockNotificationService,
        contextService: mockContextService,
        journalRepository: mockJournalRepository,
      );
    });

    /// ランダムなタスクを生成
    Task generateRandomTask(Random random, String userUuid) {
      final titles = [
        'レポートを書く',
        'プレゼン準備',
        'メール返信',
        '会議資料作成',
        'コードレビュー',
        'データ分析',
        '企画書作成',
        '部屋の掃除',
        '買い物',
        '運動する',
      ];

      return Task.create(
        uuid: 'task-${random.nextInt(10000)}',
        userUuid: userUuid,
        title: titles[random.nextInt(titles.length)],
        estimatedMinutes: 5 + random.nextInt(55),
      );
    }

    /// ランダムな感情タイプを生成
    EmotionType generateRandomEmotion(Random random) {
      final emotions = EmotionType.values;
      return emotions[random.nextInt(emotions.length)];
    }

    /// ランダムなジャーナルエントリを生成
    JournalEntry generateRandomJournalEntry(
      Random random,
      String userUuid,
      EmotionType emotion,
    ) {
      return JournalEntry.create(
        uuid: 'entry-${random.nextInt(10000)}',
        userUuid: userUuid,
        emotionDetected: emotion,
        emotionConfidence: 0.5 + random.nextDouble() * 0.5,
      );
    }

    /// 感情がネガティブかどうか判定
    bool isNegativeEmotion(EmotionType type) {
      return type == EmotionType.sad ||
          type == EmotionType.angry ||
          type == EmotionType.anxious ||
          type == EmotionType.tired;
    }

    /// 期待されるトーンを取得
    NotificationTone getExpectedTone(EmotionType? emotion) {
      if (emotion == null) return NotificationTone.neutral;

      switch (emotion) {
        case EmotionType.anxious:
        case EmotionType.tired:
          return NotificationTone.gentle;
        case EmotionType.happy:
          return NotificationTone.encouraging;
        default:
          return NotificationTone.neutral;
      }
    }

    /// 期待される再送遅延時間を取得
    int getExpectedDelayMinutes(NotificationTone tone) {
      switch (tone) {
        case NotificationTone.gentle:
          return 30;
        case NotificationTone.encouraging:
          return 0;
        case NotificationTone.neutral:
          return 15;
      }
    }

    test('プロパティ7: 全ての心理状態に対して適切なトーンが選択される（100回反復）', () async {
      final random = Random(42);
      const iterations = 100;
      int successCount = 0;

      for (int i = 0; i < iterations; i++) {
        // Given: ランダムな心理状態のユーザー
        final userUuid = 'user-$i';
        final task = generateRandomTask(random, userUuid);
        final emotion = generateRandomEmotion(random);
        final entry = generateRandomJournalEntry(random, userUuid, emotion);

        final context = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: random.nextBool(),
            isDecreasing: random.nextBool(),
            isStable: random.nextBool(),
            averageScore: random.nextDouble(),
          ),
          motivationLevel: random.nextDouble(),
          recentEmotions: [],
          dialogueHistory: [],
        );

        when(mockContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          userUuid,
          any,
          any,
        )).thenAnswer((_) async => [entry]);
        when(mockHourPredictor.predictOptimalTime(userUuid, task))
            .thenAnswer((_) async => random.nextInt(24));
        when(mockHourPredictor.getNextOccurrence(any)).thenReturn(
            DateTime.now().add(Duration(hours: random.nextInt(12))));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        try {
          // When: 通知をスケジュール
          await system.scheduleOptimalNotification(task);

          // Then: 心理状態に応じた適切なトーンが選択される
          final captured = verify(mockNotificationService.schedule(
            message: captureAnyNamed('message'),
            scheduledTime: anyNamed('scheduledTime'),
            retryStrategy: captureAnyNamed('retryStrategy'),
          )).captured;

          final message = captured[0] as NotificationMessage;
          final retryStrategy = captured[1] as RetryStrategy;

          // 要件 4.2: 心理状態に応じたトーン調整
          final expectedTone = getExpectedTone(emotion);
          expect(
            message.tone,
            equals(expectedTone),
            reason:
                'Iteration $i: 感情 $emotion に対して期待されるトーン $expectedTone が選択されていません',
          );

          // 要件 4.3, 4.4: トーンに応じた再送戦略
          final expectedDelay = getExpectedDelayMinutes(expectedTone);
          expect(
            retryStrategy.delayMinutes,
            equals(expectedDelay),
            reason:
                'Iteration $i: トーン $expectedTone に対して期待される遅延時間 $expectedDelay が設定されていません',
          );

          successCount++;
        } catch (e) {
          print('Iteration $i failed: $e');
        }

        // モックをリセット
        reset(mockContextService);
        reset(mockJournalRepository);
        reset(mockHourPredictor);
        reset(mockNotificationService);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ7: 不安/疲労状態では常に優しいトーンと30分後再送が適用される', () async {
      final random = Random(123);
      const iterations = 50;

      for (int i = 0; i < iterations; i++) {
        // Given: 不安または疲労状態のユーザー
        final userUuid = 'user-$i';
        final task = generateRandomTask(random, userUuid);
        final emotion =
            random.nextBool() ? EmotionType.anxious : EmotionType.tired;
        final entry = generateRandomJournalEntry(random, userUuid, emotion);

        final context = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: true,
            isStable: false,
            averageScore: 0.3,
          ),
          motivationLevel: 0.3,
          recentEmotions: [],
          dialogueHistory: [],
        );

        when(mockContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          userUuid,
          any,
          any,
        )).thenAnswer((_) async => [entry]);
        when(mockHourPredictor.predictOptimalTime(userUuid, task))
            .thenAnswer((_) async => random.nextInt(24));
        when(mockHourPredictor.getNextOccurrence(any)).thenReturn(
            DateTime.now().add(Duration(hours: random.nextInt(12))));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 優しいトーンと30分後再送が適用される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(
          message.tone,
          equals(NotificationTone.gentle),
          reason: 'Iteration $i: 感情 $emotion に対して優しいトーンが選択されていません',
        );
        expect(
          retryStrategy.delayMinutes,
          equals(30),
          reason: 'Iteration $i: 30分後再送が設定されていません',
        );

        // モックをリセット
        reset(mockContextService);
        reset(mockJournalRepository);
        reset(mockHourPredictor);
        reset(mockNotificationService);
      }
    });

    test('プロパティ7: ポジティブ状態では常に励ましトーンと即時送信が適用される', () async {
      final random = Random(456);
      const iterations = 50;

      for (int i = 0; i < iterations; i++) {
        // Given: ポジティブ状態のユーザー
        final userUuid = 'user-$i';
        final task = generateRandomTask(random, userUuid);
        final emotion = EmotionType.happy;
        final entry = generateRandomJournalEntry(random, userUuid, emotion);

        final context = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.8,
          ),
          motivationLevel: 0.8,
          recentEmotions: [],
          dialogueHistory: [],
        );

        when(mockContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          userUuid,
          any,
          any,
        )).thenAnswer((_) async => [entry]);
        when(mockHourPredictor.predictOptimalTime(userUuid, task))
            .thenAnswer((_) async => random.nextInt(24));
        when(mockHourPredictor.getNextOccurrence(any)).thenReturn(
            DateTime.now().add(Duration(hours: random.nextInt(12))));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 励ましトーンと即時送信が適用される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(
          message.tone,
          equals(NotificationTone.encouraging),
          reason: 'Iteration $i: 感情 $emotion に対して励ましトーンが選択されていません',
        );
        expect(
          retryStrategy.delayMinutes,
          equals(0),
          reason: 'Iteration $i: 即時送信（0分遅延）が設定されていません',
        );

        // モックをリセット
        reset(mockContextService);
        reset(mockJournalRepository);
        reset(mockHourPredictor);
        reset(mockNotificationService);
      }
    });

    test('プロパティ7: 感情データがない場合は中立トーンが適用される', () async {
      final random = Random(789);
      const iterations = 30;

      for (int i = 0; i < iterations; i++) {
        // Given: 感情データがないユーザー
        final userUuid = 'user-$i';
        final task = generateRandomTask(random, userUuid);

        final context = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.5,
          ),
          motivationLevel: 0.5,
          recentEmotions: [],
          dialogueHistory: [],
        );

        when(mockContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          userUuid,
          any,
          any,
        )).thenAnswer((_) async => []); // 感情データなし
        when(mockHourPredictor.predictOptimalTime(userUuid, task))
            .thenAnswer((_) async => random.nextInt(24));
        when(mockHourPredictor.getNextOccurrence(any)).thenReturn(
            DateTime.now().add(Duration(hours: random.nextInt(12))));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: 中立トーンが適用される
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: captureAnyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;
        final retryStrategy = captured[1] as RetryStrategy;

        expect(
          message.tone,
          equals(NotificationTone.neutral),
          reason: 'Iteration $i: 感情データがない場合に中立トーンが選択されていません',
        );
        expect(
          retryStrategy.delayMinutes,
          equals(15),
          reason: 'Iteration $i: 中立トーンに対して15分遅延が設定されていません',
        );

        // モックをリセット
        reset(mockContextService);
        reset(mockJournalRepository);
        reset(mockHourPredictor);
        reset(mockNotificationService);
      }
    });

    test('プロパティ7: 通知メッセージにタスク情報が含まれる', () async {
      final random = Random(101);
      const iterations = 30;

      for (int i = 0; i < iterations; i++) {
        // Given: ランダムなタスクとユーザー状態
        final userUuid = 'user-$i';
        final task = generateRandomTask(random, userUuid);
        final emotion = generateRandomEmotion(random);
        final entry = generateRandomJournalEntry(random, userUuid, emotion);

        final context = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: random.nextBool(),
            isDecreasing: random.nextBool(),
            isStable: random.nextBool(),
            averageScore: random.nextDouble(),
          ),
          motivationLevel: random.nextDouble(),
          recentEmotions: [],
          dialogueHistory: [],
        );

        when(mockContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockJournalRepository.getEntriesByDateRange(
          userUuid,
          any,
          any,
        )).thenAnswer((_) async => [entry]);
        when(mockHourPredictor.predictOptimalTime(userUuid, task))
            .thenAnswer((_) async => random.nextInt(24));
        when(mockHourPredictor.getNextOccurrence(any)).thenReturn(
            DateTime.now().add(Duration(hours: random.nextInt(12))));
        when(mockNotificationService.schedule(
          message: anyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).thenAnswer((_) async {});

        // When: 通知をスケジュール
        await system.scheduleOptimalNotification(task);

        // Then: メッセージにタスク情報が含まれる
        final captured = verify(mockNotificationService.schedule(
          message: captureAnyNamed('message'),
          scheduledTime: anyNamed('scheduledTime'),
          retryStrategy: anyNamed('retryStrategy'),
        )).captured;

        final message = captured[0] as NotificationMessage;

        expect(
          message.taskUuid,
          equals(task.uuid),
          reason: 'Iteration $i: メッセージにタスクUUIDが含まれていません',
        );
        expect(
          message.title.isNotEmpty,
          isTrue,
          reason: 'Iteration $i: メッセージタイトルが空です',
        );
        expect(
          message.body.isNotEmpty,
          isTrue,
          reason: 'Iteration $i: メッセージ本文が空です',
        );

        // モックをリセット
        reset(mockContextService);
        reset(mockJournalRepository);
        reset(mockHourPredictor);
        reset(mockNotificationService);
      }
    });
  });
}
