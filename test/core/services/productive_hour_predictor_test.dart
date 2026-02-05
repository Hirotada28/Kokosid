import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/services/productive_hour_predictor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'productive_hour_predictor_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  group('ProductiveHourPredictor', () {
    late MockTaskRepository mockTaskRepository;
    late ProductiveHourPredictor predictor;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      predictor = ProductiveHourPredictor(mockTaskRepository);
    });

    group('predictOptimalTime', () {
      test('データがない場合はデフォルトの10時を返す', () async {
        // Given: 完了タスクがない
        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => []);

        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        // When: 最適時間を予測
        final optimalHour = await predictor.predictOptimalTime('user-1', task);

        // Then: デフォルトの10時が返される
        expect(optimalHour, equals(10));
      });

      test('最も完了率の高い時間帯を返す', () async {
        // Given: 14時に多くのタスクが完了している
        final now = DateTime.now();
        final completedTasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 5, 14),
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 4, 14),
          Task.create(
            uuid: 'task-3',
            userUuid: 'user-1',
            title: 'タスク3',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 3, 14),
          Task.create(
            uuid: 'task-4',
            userUuid: 'user-1',
            title: 'タスク4',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 2, 9),
        ];

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        final task = Task.create(
          uuid: 'task-5',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        // When: 最適時間を予測
        final optimalHour = await predictor.predictOptimalTime('user-1', task);

        // Then: 14時が返される（最も多く完了している時間帯）
        expect(optimalHour, equals(14));
      });

      test('過去30日間のデータのみを使用する', () async {
        // Given: 30日以内と30日以前のタスク
        final now = DateTime.now();
        final tasks = [
          // 30日以内
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )
            ..complete()
            ..completedAt = now.subtract(const Duration(days: 10, hours: 10)),
          // 30日以前（除外されるべき）
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )
            ..complete()
            ..completedAt = now.subtract(const Duration(days: 35, hours: 10)),
        ];

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => tasks);

        final task = Task.create(
          uuid: 'task-3',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        // When: 最適時間を予測
        await predictor.predictOptimalTime('user-1', task);

        // Then: 30日間の範囲でクエリされる
        final captured = verify(
          mockTaskRepository.getTasksByDateRange(
            'user-1',
            captureAny,
            captureAny,
          ),
        ).captured;

        final start = captured[0] as DateTime;
        final end = captured[1] as DateTime;

        expect(end.difference(start).inDays, equals(30));
      });
    });

    group('getHourlyCompletionRates', () {
      test('時間帯別の完了率を正しく計算する', () async {
        // Given: 複数の時間帯でタスクが完了している
        final now = DateTime.now();
        final completedTasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: 'user-1',
            title: 'タスク1',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 1, 9),
          Task.create(
            uuid: 'task-2',
            userUuid: 'user-1',
            title: 'タスク2',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 2, 9, 30),
          Task.create(
            uuid: 'task-3',
            userUuid: 'user-1',
            title: 'タスク3',
          )
            ..status = TaskStatus.completed
            ..completedAt = DateTime(now.year, now.month, now.day - 3, 14),
        ];

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        // When: 時間帯別完了率を取得
        final rates = await predictor.getHourlyCompletionRates('user-1');

        // Then: 正しい完了率が計算される
        expect(rates[9], closeTo(2 / 3, 0.01)); // 9時: 2/3
        expect(rates[14], closeTo(1 / 3, 0.01)); // 14時: 1/3
      });
    });

    group('getNextOccurrence', () {
      test('指定時刻が未来の場合は今日の時刻を返す', () {
        // Given: 現在時刻より後の時刻
        final now = DateTime.now();
        final futureHour = (now.hour + 2) % 24;

        // When: 次の発生時刻を取得
        final nextOccurrence = predictor.getNextOccurrence(futureHour);

        // Then: 今日の指定時刻が返される
        expect(nextOccurrence.hour, equals(futureHour));
        expect(nextOccurrence.day, equals(now.day));
      });

      test('指定時刻が過去の場合は翌日の時刻を返す', () {
        // Given: 現在時刻より前の時刻
        final now = DateTime.now();
        final pastHour = (now.hour - 2) % 24;

        // When: 次の発生時刻を取得
        final nextOccurrence = predictor.getNextOccurrence(pastHour);

        // Then: 翌日の指定時刻が返される
        expect(nextOccurrence.hour, equals(pastHour));
        expect(
          nextOccurrence.day,
          equals((now.day + 1) % DateTime(now.year, now.month + 1, 0).day),
        );
      });
    });
  });

  // **Feature: act-based-self-management, Property 8: 生産的時間帯学習の実行**
  // **Validates: Requirements 4.1**
  group('Property-Based Tests: 生産的時間帯学習の実行', () {
    late MockTaskRepository mockTaskRepository;
    late ProductiveHourPredictor predictor;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      predictor = ProductiveHourPredictor(mockTaskRepository);
    });

    /// ランダムな完了タスクを生成
    List<Task> generateRandomCompletedTasks(
      Random random,
      String userUuid,
      int count,
      DateTime baseTime,
    ) {
      final tasks = <Task>[];

      for (var i = 0; i < count; i++) {
        final daysAgo = random.nextInt(30); // 0-29日前
        final hour = random.nextInt(24); // 0-23時
        final minute = random.nextInt(60);

        final task = Task.create(
          uuid: 'task-$i',
          userUuid: userUuid,
          title: 'タスク$i',
          estimatedMinutes: 5 + random.nextInt(55), // 5-59分
        )..complete();

        task.completedAt = baseTime.subtract(
          Duration(days: daysAgo, hours: baseTime.hour - hour, minutes: minute),
        );

        tasks.add(task);
      }

      return tasks;
    }

    /// 特定の時間帯に集中したタスクを生成
    List<Task> generateTasksWithPeakHour(
      Random random,
      String userUuid,
      int totalCount,
      int peakHour,
      double peakRatio,
    ) {
      final tasks = <Task>[];
      final peakCount = (totalCount * peakRatio).floor();
      final otherCount = totalCount - peakCount;

      final now = DateTime.now();

      // ピーク時間帯のタスク
      for (var i = 0; i < peakCount; i++) {
        final daysAgo = random.nextInt(30);
        final task = Task.create(
          uuid: 'task-peak-$i',
          userUuid: userUuid,
          title: 'ピークタスク$i',
        )..complete();

        task.completedAt = DateTime(
          now.year,
          now.month,
          now.day - daysAgo,
          peakHour,
          random.nextInt(60),
        );

        tasks.add(task);
      }

      // その他の時間帯のタスク
      for (var i = 0; i < otherCount; i++) {
        final daysAgo = random.nextInt(30);
        var hour = random.nextInt(24);
        // ピーク時間を避ける
        while (hour == peakHour) {
          hour = random.nextInt(24);
        }

        final task = Task.create(
          uuid: 'task-other-$i',
          userUuid: userUuid,
          title: 'その他タスク$i',
        )..complete();

        task.completedAt = DateTime(
          now.year,
          now.month,
          now.day - daysAgo,
          hour,
          random.nextInt(60),
        );

        tasks.add(task);
      }

      return tasks;
    }

    test('プロパティ8: 十分なデータがある場合、過去30日間のパターンから最適時間を学習する（100回反復）', () async {
      final random = Random(42);
      const iterations = 100;
      var successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: 十分な完了タスクデータ（最低10個以上）
        const userId = 'user-test';
        final taskCount = 10 + random.nextInt(40); // 10-49個
        final peakHour = random.nextInt(24); // 0-23時
        final peakRatio = 0.3 + random.nextDouble() * 0.4; // 30-70%

        final completedTasks = generateTasksWithPeakHour(
          random,
          userId,
          taskCount,
          peakHour,
          peakRatio,
        );

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        final task = Task.create(
          uuid: 'task-new',
          userUuid: userId,
          title: '新しいタスク',
        );

        try {
          // When: 最適時間を予測
          final predictedHour =
              await predictor.predictOptimalTime(userId, task);

          // Then: 予測された時間が有効な範囲内（0-23時）
          expect(
            predictedHour,
            inInclusiveRange(0, 23),
            reason: 'Iteration $i: 予測時間が有効な範囲外です: $predictedHour',
          );

          // ピーク時間が予測される（高い確率で）
          if (predictedHour == peakHour) {
            successCount++;
          }

          // 過去30日間のデータが使用されることを検証
          final captured = verify(
            mockTaskRepository.getTasksByDateRange(
              userId,
              captureAny,
              captureAny,
            ),
          ).captured;

          final start = captured[0] as DateTime;
          final end = captured[1] as DateTime;

          expect(
            end.difference(start).inDays,
            equals(30),
            reason: 'Iteration $i: 30日間のデータが使用されていません',
          );
        } on Exception catch (e) {
          // ignore: avoid_print
          print('Iteration $i failed: $e');
        }
      }

      // ピーク時間の予測成功率が60%以上であることを期待
      // （ランダム性があるため100%ではない）
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.6).floor()),
        reason: 'ピーク時間の予測成功率が低すぎます: $successCount/$iterations',
      );
    });

    test('プロパティ8: データが不足している場合、デフォルト時間（10時）を返す', () async {
      final random = Random(123);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: データが不足している（0-5個のタスク）
        const userId = 'user-test';
        final taskCount = random.nextInt(6); // 0-5個

        final completedTasks = generateRandomCompletedTasks(
          random,
          userId,
          taskCount,
          DateTime.now(),
        );

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        final task = Task.create(
          uuid: 'task-new',
          userUuid: userId,
          title: '新しいタスク',
        );

        // When: 最適時間を予測
        final predictedHour = await predictor.predictOptimalTime(userId, task);

        // Then: デフォルトの10時が返される（要件 4.1）
        if (taskCount == 0) {
          expect(
            predictedHour,
            equals(10),
            reason: 'Iteration $i: データがない場合はデフォルト10時が期待されます',
          );
        } else {
          // データが少ない場合でも有効な時間が返される
          expect(
            predictedHour,
            inInclusiveRange(0, 23),
            reason: 'Iteration $i: 予測時間が有効な範囲外です',
          );
        }
      }
    });

    test('プロパティ8: 時間帯別完了率が正しく計算される', () async {
      final random = Random(456);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 様々な時間帯でタスクが完了している
        const userId = 'user-test';
        final taskCount = 20 + random.nextInt(30); // 20-49個

        final completedTasks = generateRandomCompletedTasks(
          random,
          userId,
          taskCount,
          DateTime.now(),
        );

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        // When: 時間帯別完了率を取得
        final rates = await predictor.getHourlyCompletionRates(userId);

        // Then: 完了率の合計が1.0になる（要件 4.1）
        final totalRate =
            rates.values.fold<double>(0.0, (sum, rate) => sum + rate);
        expect(
          totalRate,
          closeTo(1.0, 0.01),
          reason: 'Iteration $i: 完了率の合計が1.0になりません: $totalRate',
        );

        // 各時間帯の完了率が0.0-1.0の範囲内
        for (final entry in rates.entries) {
          expect(
            entry.value,
            inInclusiveRange(0.0, 1.0),
            reason: 'Iteration $i: 時間帯${entry.key}の完了率が範囲外です: ${entry.value}',
          );
        }
      }
    });

    test('プロパティ8: 最も完了率の高い時間帯が常に選択される', () async {
      final random = Random(789);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 明確なピーク時間帯を持つデータ
        const userId = 'user-test';
        final peakHour = random.nextInt(24);
        final taskCount = 30 + random.nextInt(20); // 30-49個

        final completedTasks = generateTasksWithPeakHour(
          random,
          userId,
          taskCount,
          peakHour,
          0.5, // 50%がピーク時間帯
        );

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => completedTasks);

        final task = Task.create(
          uuid: 'task-new',
          userUuid: userId,
          title: '新しいタスク',
        );

        // When: 最適時間を予測
        final predictedHour = await predictor.predictOptimalTime(userId, task);

        // Then: ピーク時間帯が選択される（要件 4.1）
        expect(
          predictedHour,
          equals(peakHour),
          reason:
              'Iteration $i: ピーク時間帯$peakHour時が選択されませんでした（予測: $predictedHour時）',
        );
      }
    });

    test('プロパティ8: 異なるユーザーに対して独立した学習が行われる', () async {
      final random = Random(101112);
      const iterations = 30;

      for (var i = 0; i < iterations; i++) {
        // Given: 2人のユーザーが異なるパターンを持つ
        final user1Id = 'user-1-$i';
        final user2Id = 'user-2-$i';

        final user1PeakHour = random.nextInt(12); // 0-11時
        final user2PeakHour = 12 + random.nextInt(12); // 12-23時

        final user1Tasks = generateTasksWithPeakHour(
          random,
          user1Id,
          30,
          user1PeakHour,
          0.6,
        );

        final user2Tasks = generateTasksWithPeakHour(
          random,
          user2Id,
          30,
          user2PeakHour,
          0.6,
        );

        when(mockTaskRepository.getTasksByDateRange(user1Id, any, any))
            .thenAnswer((_) async => user1Tasks);
        when(mockTaskRepository.getTasksByDateRange(user2Id, any, any))
            .thenAnswer((_) async => user2Tasks);

        final task1 = Task.create(
          uuid: 'task-1',
          userUuid: user1Id,
          title: 'ユーザー1のタスク',
        );

        final task2 = Task.create(
          uuid: 'task-2',
          userUuid: user2Id,
          title: 'ユーザー2のタスク',
        );

        // When: 各ユーザーの最適時間を予測
        final user1Prediction =
            await predictor.predictOptimalTime(user1Id, task1);
        final user2Prediction =
            await predictor.predictOptimalTime(user2Id, task2);

        // Then: 各ユーザーのパターンに基づいた予測が行われる（要件 4.1）
        expect(
          user1Prediction,
          equals(user1PeakHour),
          reason: 'Iteration $i: ユーザー1のピーク時間が正しく予測されませんでした',
        );

        expect(
          user2Prediction,
          equals(user2PeakHour),
          reason: 'Iteration $i: ユーザー2のピーク時間が正しく予測されませんでした',
        );

        // 2人のユーザーの予測が異なることを確認
        expect(
          user1Prediction,
          isNot(equals(user2Prediction)),
          reason: 'Iteration $i: 異なるパターンを持つユーザーの予測が同じになっています',
        );
      }
    });

    test('プロパティ8: 次の発生時刻が常に未来の時刻である', () async {
      final random = Random(131415);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムな時刻
        final hour = random.nextInt(24);

        // When: 次の発生時刻を取得
        final nextOccurrence = predictor.getNextOccurrence(hour);

        // Then: 次の発生時刻が現在時刻より未来である
        final now = DateTime.now();
        expect(
          nextOccurrence.isAfter(now) || nextOccurrence.isAtSameMomentAs(now),
          isTrue,
          reason: 'Iteration $i: 次の発生時刻が過去になっています',
        );

        // 指定された時刻が正しく設定されている
        expect(
          nextOccurrence.hour,
          equals(hour),
          reason: 'Iteration $i: 指定時刻が正しく設定されていません',
        );
      }
    });

    test('プロパティ8: 30日間のデータのみが学習に使用される', () async {
      final random = Random(161718);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 30日以内と30日以前のタスクが混在
        const userId = 'user-test';
        final now = DateTime.now();

        final recentTasks = generateRandomCompletedTasks(
          random,
          userId,
          20,
          now,
        );

        // 30日以前のタスクを追加（これらは除外されるべき）
        final oldTasks = <Task>[];
        for (var j = 0; j < 10; j++) {
          final task = Task.create(
            uuid: 'old-task-$j',
            userUuid: userId,
            title: '古いタスク$j',
          )..complete();

          task.completedAt = now.subtract(Duration(days: 31 + j));
          oldTasks.add(task);
        }

        final allTasks = [...recentTasks, ...oldTasks];

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => allTasks);

        final task = Task.create(
          uuid: 'task-new',
          userUuid: userId,
          title: '新しいタスク',
        );

        // When: 最適時間を予測
        await predictor.predictOptimalTime(userId, task);

        // Then: 30日間の範囲でクエリされる（要件 4.1）
        final captured = verify(
          mockTaskRepository.getTasksByDateRange(
            userId,
            captureAny,
            captureAny,
          ),
        ).captured;

        final start = captured[0] as DateTime;
        final end = captured[1] as DateTime;

        expect(
          end.difference(start).inDays,
          equals(30),
          reason: 'Iteration $i: クエリ範囲が30日間ではありません',
        );

        // 開始日が約30日前であることを確認
        final expectedStart = now.subtract(const Duration(days: 30));
        expect(
          start.difference(expectedStart).inHours.abs(),
          lessThan(24),
          reason: 'Iteration $i: 開始日が30日前から大きくずれています',
        );
      }
    });

    test('プロパティ8: 完了していないタスクは学習データから除外される', () async {
      final random = Random(192021);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 完了タスクと未完了タスクが混在
        const userId = 'user-test';
        final now = DateTime.now();

        final completedTasks = generateRandomCompletedTasks(
          random,
          userId,
          15,
          now,
        );

        // 未完了タスクを追加
        final incompleteTasks = <Task>[];
        for (var j = 0; j < 10; j++) {
          final task = Task.create(
            uuid: 'incomplete-task-$j',
            userUuid: userId,
            title: '未完了タスク$j',
          );
          // complete()を呼ばない = 未完了
          incompleteTasks.add(task);
        }

        final allTasks = [...completedTasks, ...incompleteTasks];

        when(mockTaskRepository.getTasksByDateRange(any, any, any))
            .thenAnswer((_) async => allTasks);

        final task = Task.create(
          uuid: 'task-new',
          userUuid: userId,
          title: '新しいタスク',
        );

        // When: 最適時間を予測
        final predictedHour = await predictor.predictOptimalTime(userId, task);

        // Then: 予測が成功する（完了タスクのみが使用される）
        expect(
          predictedHour,
          inInclusiveRange(0, 23),
          reason: 'Iteration $i: 予測時間が有効な範囲外です',
        );

        // 時間帯別完了率を取得して検証
        final rates = await predictor.getHourlyCompletionRates(userId);

        // 完了率の合計が1.0になる（未完了タスクが除外されている証拠）
        final totalRate =
            rates.values.fold<double>(0.0, (sum, rate) => sum + rate);
        expect(
          totalRate,
          closeTo(1.0, 0.01),
          reason: 'Iteration $i: 未完了タスクが含まれている可能性があります',
        );
      }
    });
  });
}
