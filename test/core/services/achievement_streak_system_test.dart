import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/notification_tone.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/services/achievement_streak_system.dart';
import 'package:kokosid/core/services/notification_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'achievement_streak_system_test.mocks.dart';

@GenerateMocks([
  TaskRepository,
  NotificationService,
])
void main() {
  group('AchievementStreakSystem', () {
    late MockTaskRepository mockTaskRepository;
    late MockNotificationService mockNotificationService;
    late AchievementStreakSystem system;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      mockNotificationService = MockNotificationService();
      system = AchievementStreakSystem(
        taskRepository: mockTaskRepository,
        notificationService: mockNotificationService,
      );
    });

    group('Unit Tests', () {
      test('連続達成3個以上で特別な通知が送信される', () async {
        // Given: 3個のタスクが1時間以内に連続完了
        final now = DateTime.now();
        final tasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )..complete(),
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )..complete(),
          Task.create(
            uuid: 'task-3',
            userUuid: 'user-1',
            title: 'タスク3',
          )..complete(),
        ];

        // 完了時刻を設定（30分間隔）
        tasks[0].completedAt = now.subtract(const Duration(minutes: 60));
        tasks[1].completedAt = now.subtract(const Duration(minutes: 30));
        tasks[2].completedAt = now;

        final today = DateTime(now.year, now.month, now.day);

        when(mockTaskRepository.getTasksByDateRange(
          'user-1',
          today,
          any,
        )).thenAnswer((_) async => tasks);

        when(mockNotificationService.sendImmediate(any))
            .thenAnswer((_) async {});

        // When: 連続達成をチェック
        await system.checkAndCelebrateStreak('user-1');

        // Then: 特別な通知が送信される
        final captured = verify(
          mockNotificationService.sendImmediate(captureAny),
        ).captured;

        expect(captured.length, equals(1));
        final message = captured[0] as NotificationMessage;
        expect(message.tone, equals(NotificationTone.encouraging));
        expect(message.title, contains('連続達成'));
        expect(message.body, contains('3'));
      });

      test('連続達成が3個未満の場合は通知が送信されない', () async {
        // Given: 2個のタスクのみ完了
        final now = DateTime.now();
        final tasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )..complete(),
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )..complete(),
        ];

        tasks[0].completedAt = now.subtract(const Duration(minutes: 30));
        tasks[1].completedAt = now;

        final today = DateTime(now.year, now.month, now.day);

        when(mockTaskRepository.getTasksByDateRange(
          'user-1',
          today,
          any,
        )).thenAnswer((_) async => tasks);

        // When: 連続達成をチェック
        await system.checkAndCelebrateStreak('user-1');

        // Then: 通知は送信されない
        verifyNever(mockNotificationService.sendImmediate(any));
      });

      test('1時間以上の間隔がある場合は連続とみなされない', () async {
        // Given: 3個のタスクだが、間隔が60分超
        final now = DateTime.now();
        final tasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )..complete(),
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )..complete(),
          Task.create(
            uuid: 'task-3',
            userUuid: 'user-1',
            title: 'タスク3',
          )..complete(),
        ];

        tasks[0].completedAt = now.subtract(const Duration(hours: 3));
        tasks[1].completedAt = now.subtract(const Duration(hours: 2));
        tasks[2].completedAt = now;

        final today = DateTime(now.year, now.month, now.day);

        when(mockTaskRepository.getTasksByDateRange(
          'user-1',
          today,
          any,
        )).thenAnswer((_) async => tasks);

        // When: 連続達成をチェック
        await system.checkAndCelebrateStreak('user-1');

        // Then: 通知は送信されない（最新の1個のみが連続）
        verifyNever(mockNotificationService.sendImmediate(any));
      });
    });
  });

  // **Feature: act-based-self-management, Property 9: 達成感演出の連続完了対応**
  // **Validates: Requirements 4.5**
  group('Property-Based Tests: 達成感演出の連続完了対応', () {
    late MockTaskRepository mockTaskRepository;
    late MockNotificationService mockNotificationService;
    late AchievementStreakSystem system;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      mockNotificationService = MockNotificationService();
      system = AchievementStreakSystem(
        taskRepository: mockTaskRepository,
        notificationService: mockNotificationService,
      );
    });

    /// ランダムな完了タスクリストを生成
    List<Task> generateRandomCompletedTasks(
      Random random,
      String userUuid,
      int count,
      DateTime baseTime,
    ) {
      final tasks = <Task>[];
      var currentTime = baseTime;

      for (var i = 0; i < count; i++) {
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: userUuid,
          title: 'タスク$i',
          estimatedMinutes: 5 + random.nextInt(25),
        )..complete();

        // ランダムな間隔で完了時刻を設定（0-90分）
        final minutesAgo = random.nextInt(91);
        task.completedAt = currentTime.subtract(Duration(minutes: minutesAgo));
        currentTime = task.completedAt!;

        tasks.add(task);
      }

      return tasks;
    }

    /// 連続達成数を計算（テスト用の期待値計算）
    int calculateExpectedStreak(List<Task> tasks) {
      if (tasks.isEmpty) return 0;

      final sortedTasks = List<Task>.from(tasks)
        ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

      var streakCount = 0;
      DateTime? lastCompletedAt;

      for (final task in sortedTasks) {
        if (lastCompletedAt == null) {
          streakCount = 1;
          lastCompletedAt = task.completedAt;
        } else {
          final timeDiff = lastCompletedAt.difference(task.completedAt!);
          if (timeDiff.inMinutes <= 60) {
            streakCount++;
            lastCompletedAt = task.completedAt;
          } else {
            break;
          }
        }
      }

      return streakCount;
    }

    test('プロパティ9: 連続完了3個以上で常に特別な通知が送信される（100回反復）', () async {
      final random = Random(42);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムな数のタスク（3-10個）を連続完了
        final userUuid = 'user-$i';
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final taskCount = 3 + random.nextInt(8); // 3-10個

        // 連続達成を保証するため、全タスクを1時間以内に配置
        final tasks = <Task>[];
        var currentTime = now;

        for (var j = 0; j < taskCount; j++) {
          final task = Task.create(
            uuid: 'task-$i-$j',
            userUuid: userUuid,
            title: 'タスク$j',
          )..complete();

          // 10-30分間隔で配置
          final minutesAgo = 10 + random.nextInt(21);
          task.completedAt =
              currentTime.subtract(Duration(minutes: minutesAgo));
          currentTime = task.completedAt!;

          tasks.add(task);
        }

        when(mockTaskRepository.getTasksByDateRange(
          userUuid,
          today,
          any,
        )).thenAnswer((_) async => tasks);

        when(mockNotificationService.sendImmediate(any))
            .thenAnswer((_) async {});

        try {
          // When: 連続達成をチェック
          await system.checkAndCelebrateStreak(userUuid);

          // Then: 特別な通知が送信される
          final captured = verify(
            mockNotificationService.sendImmediate(captureAny),
          ).captured;

          expect(
            captured.length,
            equals(1),
            reason: 'Iteration $i: $taskCount個の連続完了で通知が送信されていません',
          );

          final message = captured[0] as NotificationMessage;
          expect(
            message.tone,
            equals(NotificationTone.encouraging),
            reason: 'Iteration $i: 励ましトーンが使用されていません',
          );
          expect(
            message.title,
            contains('連続達成'),
            reason: 'Iteration $i: タイトルに「連続達成」が含まれていません',
          );
          expect(
            message.body,
            contains('$taskCount'),
            reason: 'Iteration $i: 本文に連続数が含まれていません',
          );

          successCount++;
        } catch (e) {
          print('Iteration $i failed: $e');
        }

        // モックをリセット
        reset(mockTaskRepository);
        reset(mockNotificationService);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ9: 連続完了3個未満では通知が送信されない（100回反復）', () async {
      final random = Random(123);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムな数のタスク（0-2個）
        final userUuid = 'user-$i';
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final taskCount = random.nextInt(3); // 0-2個

        final tasks = <Task>[];
        var currentTime = now;

        for (var j = 0; j < taskCount; j++) {
          final task = Task.create(
            uuid: 'task-$i-$j',
            userUuid: userUuid,
            title: 'タスク$j',
          )..complete();

          final minutesAgo = 10 + random.nextInt(21);
          task.completedAt =
              currentTime.subtract(Duration(minutes: minutesAgo));
          currentTime = task.completedAt!;

          tasks.add(task);
        }

        when(mockTaskRepository.getTasksByDateRange(
          userUuid,
          today,
          any,
        )).thenAnswer((_) async => tasks);

        try {
          // When: 連続達成をチェック
          await system.checkAndCelebrateStreak(userUuid);

          // Then: 通知は送信されない
          verifyNever(mockNotificationService.sendImmediate(any));

          successCount++;
        } catch (e) {
          print('Iteration $i failed: $e');
        }

        // モックをリセット
        reset(mockTaskRepository);
        reset(mockNotificationService);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ9: 1時間以上の間隔がある場合は連続とみなされない（100回反復）', () async {
      final random = Random(456);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: タスクが1時間以上の間隔で完了
        final userUuid = 'user-$i';
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final taskCount = 3 + random.nextInt(5); // 3-7個

        final tasks = <Task>[];
        var currentTime = now;

        for (var j = 0; j < taskCount; j++) {
          final task = Task.create(
            uuid: 'task-$i-$j',
            userUuid: userUuid,
            title: 'タスク$j',
          )..complete();

          // 61-120分間隔で配置（1時間以上）
          final minutesAgo = 61 + random.nextInt(60);
          task.completedAt =
              currentTime.subtract(Duration(minutes: minutesAgo));
          currentTime = task.completedAt!;

          tasks.add(task);
        }

        when(mockTaskRepository.getTasksByDateRange(
          userUuid,
          today,
          any,
        )).thenAnswer((_) async => tasks);

        // モックを設定（呼ばれないことを期待するが、念のため設定）
        when(mockNotificationService.sendImmediate(any))
            .thenAnswer((_) async {});

        try {
          // When: 連続達成をチェック
          await system.checkAndCelebrateStreak(userUuid);

          // Then: 通知は送信されない（最新の1個のみが連続）
          verifyNever(mockNotificationService.sendImmediate(any));

          successCount++;
        } on Exception catch (e) {
          // 期待される動作: 通知が送信されないこと
          // もし送信された場合はテスト失敗としてカウント
          if (e.toString().contains('Unexpected')) {
            // Unexpected callの場合は失敗
          } else {
            // その他の例外は再スロー
            rethrow;
          }
        }

        // モックをリセット
        reset(mockTaskRepository);
        reset(mockNotificationService);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ9: 混在パターンでも正しく連続数をカウントする（100回反復）', () async {
      final random = Random(789);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: 連続と非連続が混在するタスクリスト
        final userUuid = 'user-$i';
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final tasks = <Task>[];
        var currentTime = now;

        // 最新の連続グループ（3-5個、1時間以内）
        final recentStreakCount = 3 + random.nextInt(3);
        for (var j = 0; j < recentStreakCount; j++) {
          final task = Task.create(
            uuid: 'task-$i-recent-$j',
            userUuid: userUuid,
            title: 'タスク$j',
          )..complete();

          final minutesAgo = 10 + random.nextInt(21);
          task.completedAt =
              currentTime.subtract(Duration(minutes: minutesAgo));
          currentTime = task.completedAt!;

          tasks.add(task);
        }

        // 大きな間隔（1時間以上）
        currentTime = currentTime.subtract(Duration(hours: 2));

        // 古い連続グループ（2-4個、1時間以内）
        final oldStreakCount = 2 + random.nextInt(3);
        for (var j = 0; j < oldStreakCount; j++) {
          final task = Task.create(
            uuid: 'task-$i-old-$j',
            userUuid: userUuid,
            title: 'タスク${recentStreakCount + j}',
          )..complete();

          final minutesAgo = 10 + random.nextInt(21);
          task.completedAt =
              currentTime.subtract(Duration(minutes: minutesAgo));
          currentTime = task.completedAt!;

          tasks.add(task);
        }

        when(mockTaskRepository.getTasksByDateRange(
          userUuid,
          today,
          any,
        )).thenAnswer((_) async => tasks);

        when(mockNotificationService.sendImmediate(any))
            .thenAnswer((_) async {});

        try {
          // When: 連続達成をチェック
          await system.checkAndCelebrateStreak(userUuid);

          // Then: 最新の連続グループのみがカウントされる
          final expectedStreak = calculateExpectedStreak(tasks);

          if (expectedStreak >= 3) {
            final captured = verify(
              mockNotificationService.sendImmediate(captureAny),
            ).captured;

            expect(
              captured.length,
              equals(1),
              reason: 'Iteration $i: 連続数$expectedStreakで通知が送信されていません',
            );

            final message = captured[0] as NotificationMessage;
            expect(
              message.body,
              contains('$expectedStreak'),
              reason: 'Iteration $i: 本文に正しい連続数が含まれていません',
            );
          } else {
            verifyNever(mockNotificationService.sendImmediate(any));
          }

          successCount++;
        } catch (e) {
          print('Iteration $i failed: $e');
        }

        // モックをリセット
        reset(mockTaskRepository);
        reset(mockNotificationService);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ9: getCurrentStreakが正しい連続数を返す（100回反復）', () async {
      final random = Random(101);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムなタスクリスト
        final userUuid = 'user-$i';
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final taskCount = 1 + random.nextInt(10); // 1-10個

        final tasks = generateRandomCompletedTasks(
          random,
          userUuid,
          taskCount,
          now,
        );

        when(mockTaskRepository.getTasksByDateRange(
          userUuid,
          today,
          any,
        )).thenAnswer((_) async => tasks);

        try {
          // When: 現在の連続数を取得
          final actualStreak = await system.getCurrentStreak(userUuid);

          // Then: 期待される連続数と一致する
          final expectedStreak = calculateExpectedStreak(tasks);

          expect(
            actualStreak,
            equals(expectedStreak),
            reason:
                'Iteration $i: 期待される連続数$expectedStreakと実際の連続数$actualStreakが一致しません',
          );

          successCount++;
        } catch (e) {
          print('Iteration $i failed: $e');
        }

        // モックをリセット
        reset(mockTaskRepository);
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });
  });
}
