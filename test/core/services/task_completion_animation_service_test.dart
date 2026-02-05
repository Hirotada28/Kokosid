import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/services/achievement_streak_system.dart';
import 'package:kokosid/core/services/task_completion_animation_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_completion_animation_service_test.mocks.dart';

@GenerateMocks([AchievementStreakSystem])
void main() {
  group('TaskCompletionAnimationService', () {
    late MockAchievementStreakSystem mockStreakSystem;
    late TaskCompletionAnimationService service;

    setUp(() {
      mockStreakSystem = MockAchievementStreakSystem();
      service = TaskCompletionAnimationService(
        achievementStreakSystem: mockStreakSystem,
      );
    });

    group('selectAnimation', () {
      test('5分タスクにはキラキラ星アニメーションを選択', () async {
        // Given: 5分タスク、連続達成なし
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '短いタスク',
          estimatedMinutes: 5,
        );

        when(mockStreakSystem.getCurrentStreak('user-1'))
            .thenAnswer((_) async => 1);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-1');

        // Then: キラキラ星アニメーション、1秒
        expect(config.type, equals(CompletionAnimationType.sparkle));
        expect(config.duration, equals(const Duration(seconds: 1)));
        expect(config.isLoop, isFalse);
      });

      test('15分タスクには紙吹雪アニメーションを選択', () async {
        // Given: 15分タスク、連続達成なし
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '中程度のタスク',
          estimatedMinutes: 15,
        );

        when(mockStreakSystem.getCurrentStreak('user-1'))
            .thenAnswer((_) async => 2);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-1');

        // Then: 紙吹雪アニメーション、1.5秒
        expect(config.type, equals(CompletionAnimationType.confetti));
        expect(config.duration, equals(const Duration(milliseconds: 1500)));
        expect(config.isLoop, isFalse);
      });

      test('連続達成3個以上にはストリーク炎アニメーションを選択', () async {
        // Given: 任意のタスク、連続達成3個
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'タスク',
          estimatedMinutes: 10,
        );

        when(mockStreakSystem.getCurrentStreak('user-1'))
            .thenAnswer((_) async => 3);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-1');

        // Then: ストリーク炎アニメーション、ループ
        expect(config.type, equals(CompletionAnimationType.streakFlame));
        expect(config.duration, isNull);
        expect(config.isLoop, isTrue);
        expect(config.streakCount, equals(3));
      });

      test('連続達成が優先される', () async {
        // Given: 5分タスクだが連続達成5個
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '短いタスク',
          estimatedMinutes: 5,
        );

        when(mockStreakSystem.getCurrentStreak('user-1'))
            .thenAnswer((_) async => 5);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-1');

        // Then: ストリーク炎アニメーションが選択される
        expect(config.type, equals(CompletionAnimationType.streakFlame));
        expect(config.streakCount, equals(5));
      });

      test('推定時間がnullの場合は紙吹雪アニメーション', () async {
        // Given: 推定時間なしのタスク
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'タスク',
        );

        when(mockStreakSystem.getCurrentStreak('user-1'))
            .thenAnswer((_) async => 1);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-1');

        // Then: 紙吹雪アニメーション（デフォルト）
        expect(config.type, equals(CompletionAnimationType.confetti));
      });
    });

    group('getAnimationAssetPath', () {
      test('各アニメーションタイプに対応するパスを返す', () {
        expect(
          service.getAnimationAssetPath(CompletionAnimationType.sparkle),
          equals('assets/animations/sparkle_star.json'),
        );
        expect(
          service.getAnimationAssetPath(CompletionAnimationType.confetti),
          equals('assets/animations/confetti.json'),
        );
        expect(
          service.getAnimationAssetPath(CompletionAnimationType.streakFlame),
          equals('assets/animations/streak_flame.json'),
        );
      });
    });

    group('getAnimationDescription', () {
      test('各アニメーションタイプに対応する説明を返す', () {
        const sparkleConfig = CompletionAnimationConfig(
          type: CompletionAnimationType.sparkle,
          duration: const Duration(seconds: 1),
        );
        expect(
          service.getAnimationDescription(sparkleConfig),
          equals('タスク完了！'),
        );

        const confettiConfig = CompletionAnimationConfig(
          type: CompletionAnimationType.confetti,
          duration: const Duration(milliseconds: 1500),
        );
        expect(
          service.getAnimationDescription(confettiConfig),
          equals('素晴らしい！'),
        );

        const streakConfig = CompletionAnimationConfig(
          type: CompletionAnimationType.streakFlame,
          duration: null,
          streakCount: 5,
        );
        expect(
          service.getAnimationDescription(streakConfig),
          equals('🔥 5連続達成！'),
        );
      });
    });
  });

  // **Feature: act-based-self-management, Property 15: タスク完了時のアニメーション表示**
  // **Validates: Requirements 7.1, 7.2, 7.3, 7.4**
  group('Property-Based Tests: タスク完了時のアニメーション表示', () {
    late MockAchievementStreakSystem mockStreakSystem;
    late TaskCompletionAnimationService service;

    setUp(() {
      mockStreakSystem = MockAchievementStreakSystem();
      service = TaskCompletionAnimationService(
        achievementStreakSystem: mockStreakSystem,
      );
    });

    /// ランダムなタスクを生成
    Task generateRandomTask(Random random) {
      final titles = [
        'メールを返信する',
        '資料を読む',
        'コードをレビューする',
        '会議に参加する',
        'レポートを書く',
        'データを分析する',
        'プレゼンを準備する',
        'テストを実行する',
        'ドキュメントを更新する',
        'バグを修正する',
      ];

      // 推定時間: 1-30分、またはnull
      final estimatedMinutes =
          random.nextBool() ? 1 + random.nextInt(30) : null;

      return Task.create(
        uuid: 'task-${random.nextInt(10000)}',
        userUuid: 'user-${random.nextInt(100)}',
        title: titles[random.nextInt(titles.length)],
        estimatedMinutes: estimatedMinutes,
      );
    }

    test('プロパティ15: 5分タスクは常にキラキラ星アニメーション（1秒）', () async {
      final random = Random(42);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 1-5分のタスク、連続達成なし
        final estimatedMinutes = 1 + random.nextInt(5); // 1-5分
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: estimatedMinutes,
        );

        final streakCount = random.nextInt(3); // 0-2（閾値未満）
        when(mockStreakSystem.getCurrentStreak('user-$i'))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-$i');

        // Then: 要件 7.1 - キラキラ星アニメーション、1秒
        expect(
          config.type,
          equals(CompletionAnimationType.sparkle),
          reason: 'Iteration $i: 5分タスクはキラキラ星アニメーションであるべき',
        );
        expect(
          config.duration,
          equals(const Duration(seconds: 1)),
          reason: 'Iteration $i: キラキラ星アニメーションは1秒であるべき',
        );
        expect(
          config.isLoop,
          isFalse,
          reason: 'Iteration $i: キラキラ星アニメーションはループしない',
        );
      }
    });

    test('プロパティ15: 15分タスクは常に紙吹雪アニメーション（1.5秒）', () async {
      final random = Random(123);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 6-30分のタスク、連続達成なし
        final estimatedMinutes = 6 + random.nextInt(25); // 6-30分
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: estimatedMinutes,
        );

        final streakCount = random.nextInt(3); // 0-2（閾値未満）
        when(mockStreakSystem.getCurrentStreak('user-$i'))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-$i');

        // Then: 要件 7.2 - 紙吹雪アニメーション、1.5秒
        expect(
          config.type,
          equals(CompletionAnimationType.confetti),
          reason: 'Iteration $i: 15分タスクは紙吹雪アニメーションであるべき',
        );
        expect(
          config.duration,
          equals(const Duration(milliseconds: 1500)),
          reason: 'Iteration $i: 紙吹雪アニメーションは1.5秒であるべき',
        );
        expect(
          config.isLoop,
          isFalse,
          reason: 'Iteration $i: 紙吹雪アニメーションはループしない',
        );
      }
    });

    test('プロパティ15: 連続達成3個以上は常にストリーク炎アニメーション（ループ）', () async {
      final random = Random(456);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 任意のタスク、連続達成3個以上
        final task = generateRandomTask(random);
        final streakCount = 3 + random.nextInt(10); // 3-12連続

        when(mockStreakSystem.getCurrentStreak(task.userUuid))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, task.userUuid);

        // Then: 要件 7.3 - ストリーク炎アニメーション、ループ
        expect(
          config.type,
          equals(CompletionAnimationType.streakFlame),
          reason: 'Iteration $i: 連続達成はストリーク炎アニメーションであるべき',
        );
        expect(
          config.duration,
          isNull,
          reason: 'Iteration $i: ストリーク炎アニメーションはdurationがnull',
        );
        expect(
          config.isLoop,
          isTrue,
          reason: 'Iteration $i: ストリーク炎アニメーションはループする',
        );
        expect(
          config.streakCount,
          equals(streakCount),
          reason: 'Iteration $i: 連続達成数が正しく設定されている',
        );
      }
    });

    test('プロパティ15: 連続達成が常に優先される', () async {
      final random = Random(789);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムなタスク、連続達成3個以上
        final task = generateRandomTask(random);
        final streakCount = 3 + random.nextInt(20); // 3-22連続

        when(mockStreakSystem.getCurrentStreak(task.userUuid))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, task.userUuid);

        // Then: タスク規模に関わらずストリーク炎アニメーション
        expect(
          config.type,
          equals(CompletionAnimationType.streakFlame),
          reason:
              'Iteration $i: 連続達成時は常にストリーク炎（タスク時間: ${task.estimatedMinutes}分）',
        );
        expect(config.streakCount, equals(streakCount));
      }
    });

    test('プロパティ15: アニメーション設定の一貫性', () async {
      final random = Random(101112);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムなタスクと連続達成数
        final task = generateRandomTask(random);
        final streakCount = random.nextInt(10); // 0-9連続

        when(mockStreakSystem.getCurrentStreak(task.userUuid))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, task.userUuid);

        // Then: 設定の一貫性を検証
        if (streakCount >= 3) {
          // 連続達成の場合
          expect(config.type, equals(CompletionAnimationType.streakFlame));
          expect(config.isLoop, isTrue);
          expect(config.duration, isNull);
          expect(config.streakCount, isNotNull);
        } else if (task.estimatedMinutes != null &&
            task.estimatedMinutes! <= 5) {
          // 5分タスクの場合
          expect(config.type, equals(CompletionAnimationType.sparkle));
          expect(config.isLoop, isFalse);
          expect(config.duration, equals(const Duration(seconds: 1)));
        } else {
          // それ以外（15分タスク）
          expect(config.type, equals(CompletionAnimationType.confetti));
          expect(config.isLoop, isFalse);
          expect(config.duration, equals(const Duration(milliseconds: 1500)));
        }

        // アセットパスが取得できる
        final assetPath = service.getAnimationAssetPath(config.type);
        expect(assetPath, isNotEmpty);
        expect(assetPath, contains('assets/animations/'));
        expect(assetPath, endsWith('.json'));

        // 説明テキストが取得できる
        final description = service.getAnimationDescription(config);
        expect(description, isNotEmpty);
      }
    });

    test('プロパティ15: 境界値での正しい動作', () async {
      // Given: 境界値のテストケース
      final testCases = [
        {
          'minutes': 1,
          'streak': 0,
          'expected': CompletionAnimationType.sparkle
        },
        {
          'minutes': 5,
          'streak': 0,
          'expected': CompletionAnimationType.sparkle
        },
        {
          'minutes': 6,
          'streak': 0,
          'expected': CompletionAnimationType.confetti
        },
        {
          'minutes': 15,
          'streak': 0,
          'expected': CompletionAnimationType.confetti
        },
        {
          'minutes': 1,
          'streak': 2,
          'expected': CompletionAnimationType.sparkle
        },
        {
          'minutes': 1,
          'streak': 3,
          'expected': CompletionAnimationType.streakFlame
        },
        {
          'minutes': 5,
          'streak': 3,
          'expected': CompletionAnimationType.streakFlame
        },
        {
          'minutes': 15,
          'streak': 3,
          'expected': CompletionAnimationType.streakFlame
        },
        {
          'minutes': 30,
          'streak': 5,
          'expected': CompletionAnimationType.streakFlame
        },
      ];

      for (var i = 0; i < testCases.length; i++) {
        final testCase = testCases[i];
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: testCase['minutes'] as int,
        );

        when(mockStreakSystem.getCurrentStreak('user-$i'))
            .thenAnswer((_) async => testCase['streak'] as int);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, 'user-$i');

        // Then: 期待されるアニメーションタイプ
        expect(
          config.type,
          equals(testCase['expected']),
          reason:
              'Case $i: ${testCase['minutes']}分, ${testCase['streak']}連続 -> ${testCase['expected']}',
        );
      }
    });

    test('プロパティ15: パーソナライズされた賞賛メッセージの生成', () async {
      final random = Random(131415);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムなタスクと連続達成
        final task = generateRandomTask(random);
        final streakCount = random.nextInt(10);

        when(mockStreakSystem.getCurrentStreak(task.userUuid))
            .thenAnswer((_) async => streakCount);

        // When: アニメーションを選択
        final config = await service.selectAnimation(task, task.userUuid);

        // Then: 要件 7.4 - 説明テキストが生成される
        final description = service.getAnimationDescription(config);
        expect(
          description,
          isNotEmpty,
          reason: 'Iteration $i: 説明テキストが空ではない',
        );

        // ストリークの場合は連続数が含まれる
        if (config.type == CompletionAnimationType.streakFlame) {
          expect(
            description,
            contains('$streakCount'),
            reason: 'Iteration $i: ストリーク数が説明に含まれる',
          );
          expect(
            description,
            contains('連続'),
            reason: 'Iteration $i: 「連続」という文字が含まれる',
          );
        }
      }
    });
  });
}
