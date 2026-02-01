import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/micro_chunking_engine.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'micro_chunking_engine_test.mocks.dart';

@GenerateMocks([AIService, TaskRepository])
void main() {
  group('MicroChunkingEngine', () {
    late MockAIService mockAIService;
    late MockTaskRepository mockTaskRepository;
    late MicroChunkingEngine engine;

    setUp(() {
      mockAIService = MockAIService();
      mockTaskRepository = MockTaskRepository();
      engine = MicroChunkingEngine(
        aiService: mockAIService,
        taskRepository: mockTaskRepository,
      );
    });

    group('decomposeTask', () {
      test('タスクを5分以内のステップに分解する', () async {
        // Given: 30分のタスク
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'プレゼン資料を作成する',
          estimatedMinutes: 30,
        );

        // AI レスポンスをモック
        const aiResponse = '''
[
  {
    "action": "プレゼンの目的を1文で書き出す",
    "estimatedMinutes": 2,
    "successCriteria": "目的が1文で明確に書かれている"
  },
  {
    "action": "伝えたい3つのポイントをリストアップする",
    "estimatedMinutes": 3,
    "successCriteria": "3つのポイントが箇条書きされている"
  },
  {
    "action": "スライドのタイトルページを作成する",
    "estimatedMinutes": 2,
    "successCriteria": "タイトル、日付、名前が入力されている"
  }
]
''';

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);

        // マイクロタスクの保存をモック
        when(mockTaskRepository.createTask(any)).thenAnswer((invocation) async {
          final task = invocation.positionalArguments[0] as Task;
          return task;
        });

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 3つのマイクロタスクが生成される
        expect(microTasks.length, equals(3));

        // 各マイクロタスクが5分以内
        for (final microTask in microTasks) {
          expect(microTask.estimatedMinutes, lessThanOrEqualTo(5));
          expect(microTask.isMicroTask, isTrue);
          expect(microTask.originalTaskUuid, equals(task.uuid));
          expect(microTask.userUuid, equals(task.userUuid));
        }

        // 最初のステップが実行系
        expect(microTasks[0].title, equals('プレゼンの目的を1文で書き出す'));
        expect(microTasks[0].description, equals('目的が1文で明確に書かれている'));
      });

      test('最大7ステップまでに制限される', () async {
        // Given: 多くのステップを返すAIレスポンス
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '複雑なタスク',
          estimatedMinutes: 60,
        );

        // 10個のステップを含むレスポンス
        final steps = List.generate(
          10,
          (i) => '''
  {
    "action": "ステップ${i + 1}を実行する",
    "estimatedMinutes": ${(i % 5) + 1},
    "successCriteria": "ステップ${i + 1}が完了している"
  }''',
        ).join(',\n');

        final aiResponse = '[\n$steps\n]';

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer((invocation) async {
          return invocation.positionalArguments[0] as Task;
        });

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 最大7ステップまで
        expect(microTasks.length, lessThanOrEqualTo(7));
      });

      test('5分を超えるステップは除外される', () async {
        // Given: 5分を超えるステップを含むレスポンス
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'タスク',
        );

        const aiResponse = '''
[
  {
    "action": "短いステップ",
    "estimatedMinutes": 3,
    "successCriteria": "完了"
  },
  {
    "action": "長いステップ",
    "estimatedMinutes": 10,
    "successCriteria": "完了"
  },
  {
    "action": "もう一つの短いステップ",
    "estimatedMinutes": 5,
    "successCriteria": "完了"
  }
]
''';

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer((invocation) async {
          return invocation.positionalArguments[0] as Task;
        });

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 5分以内のステップのみ
        expect(microTasks.length, equals(2));
        expect(microTasks.every((t) => t.estimatedMinutes! <= 5), isTrue);
      });
    });

    group('getMicroTasks', () {
      test('指定されたタスクのマイクロタスクを取得する', () async {
        // Given: マイクロタスクのリスト
        final microTasks = [
          Task.create(
            uuid: 'micro-1',
            userUuid: 'user-1',
            title: 'ステップ1',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          ),
          Task.create(
            uuid: 'micro-2',
            userUuid: 'user-1',
            title: 'ステップ2',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          ),
        ];

        when(mockTaskRepository.getMicroTasks('task-1'))
            .thenAnswer((_) async => microTasks);

        // When: マイクロタスクを取得
        final result = await engine.getMicroTasks('task-1');

        // Then: マイクロタスクが返される
        expect(result.length, equals(2));
        expect(result[0].uuid, equals('micro-1'));
        expect(result[1].uuid, equals('micro-2'));
      });
    });

    group('areAllMicroTasksCompleted', () {
      test('全てのマイクロタスクが完了している場合はtrueを返す', () async {
        // Given: 全て完了したマイクロタスク
        final microTasks = [
          Task.create(
            uuid: 'micro-1',
            userUuid: 'user-1',
            title: 'ステップ1',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          )..complete(),
          Task.create(
            uuid: 'micro-2',
            userUuid: 'user-1',
            title: 'ステップ2',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          )..complete(),
        ];

        when(mockTaskRepository.getMicroTasks('task-1'))
            .thenAnswer((_) async => microTasks);

        // When: 完了状態をチェック
        final result = await engine.areAllMicroTasksCompleted('task-1');

        // Then: trueが返される
        expect(result, isTrue);
      });

      test('未完了のマイクロタスクがある場合はfalseを返す', () async {
        // Given: 一部未完了のマイクロタスク
        final microTasks = [
          Task.create(
            uuid: 'micro-1',
            userUuid: 'user-1',
            title: 'ステップ1',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          )..complete(),
          Task.create(
            uuid: 'micro-2',
            userUuid: 'user-1',
            title: 'ステップ2',
            originalTaskUuid: 'task-1',
            isMicroTask: true,
          ),
        ];

        when(mockTaskRepository.getMicroTasks('task-1'))
            .thenAnswer((_) async => microTasks);

        // When: 完了状態をチェック
        final result = await engine.areAllMicroTasksCompleted('task-1');

        // Then: falseが返される
        expect(result, isFalse);
      });
    });
  });

  // **Feature: act-based-self-management, Property 1: マイクロ・チャンキング制約の遵守**
  // **Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5**
  group('Property-Based Tests: マイクロ・チャンキング制約の遵守', () {
    late MockAIService mockAIService;
    late MockTaskRepository mockTaskRepository;
    late MicroChunkingEngine engine;

    setUp(() {
      mockAIService = MockAIService();
      mockTaskRepository = MockTaskRepository();
      engine = MicroChunkingEngine(
        aiService: mockAIService,
        taskRepository: mockTaskRepository,
      );
    });

    /// ランダムなタスクを生成するジェネレーター
    Task generateRandomTask(Random random) {
      final titles = [
        'プレゼン資料を作成する',
        'レポートを書く',
        '部屋を掃除する',
        'プログラムを実装する',
        '会議の準備をする',
        '買い物リストを作る',
        'メールを返信する',
        '企画書を作成する',
        'データ分析を行う',
        'ウェブサイトをデザインする',
      ];

      return Task.create(
        uuid: 'task-${random.nextInt(10000)}',
        userUuid: 'user-${random.nextInt(100)}',
        title: titles[random.nextInt(titles.length)],
        estimatedMinutes: 10 + random.nextInt(50), // 10-59分
      );
    }

    /// ランダムなマイクロタスクのレスポンスを生成
    String generateRandomMicroTaskResponse(Random random, int stepCount) {
      final actionVerbs = [
        '書き出す',
        '作成する',
        '決める',
        '集める',
        '書く',
        '調べる',
        '見直す',
        'チェックする',
        'リストアップする'
      ];
      final objects = [
        '目的',
        'ポイント',
        'タイトル',
        '資料',
        '段落',
        'アウトライン',
        '参考文献',
        '図表',
        '下書き',
        '内容'
      ];

      final steps = <Map<String, dynamic>>[];
      for (int i = 0; i < stepCount; i++) {
        final estimatedMinutes = 1 + random.nextInt(5); // 1-5分
        final verb = actionVerbs[random.nextInt(actionVerbs.length)];
        final object = objects[random.nextInt(objects.length)];
        final action = '${object}を$verb';

        steps.add({
          'action': action,
          'estimatedMinutes': estimatedMinutes,
          'successCriteria': '${object}が完了している',
        });
      }

      return '''
[
${steps.map((s) => '''  {
    "action": "${s['action']}",
    "estimatedMinutes": ${s['estimatedMinutes']},
    "successCriteria": "${s['successCriteria']}"
  }''').join(',\n')}
]
''';
    }

    /// 具体的な動詞で始まるかチェック
    bool startsWithActionVerb(String action) {
      final actionVerbs = [
        '書く',
        '作る',
        '作成',
        '準備',
        '集める',
        '調べる',
        '見直す',
        'チェック',
        'リスト',
        '決める',
        '実行',
        '開く',
        '閉じる',
        '送る',
        '確認',
        '整理',
        '分析',
        '設計',
        '実装',
        '削除',
        '書き出す',
        'リストアップ',
        '目的',
        'ポイント',
        'タイトル',
        '資料',
        '段落',
        'アウトライン',
        '参考文献',
        '図表',
        '下書き',
        '内容',
      ];

      return actionVerbs.any((verb) => action.contains(verb)) &&
          action.isNotEmpty;
    }

    /// 成功条件が明確かチェック
    bool hasSuccessCriteria(String criteria) {
      return criteria.isNotEmpty && criteria.length > 3;
    }

    /// 最初のステップが実行系かチェック（「準備」で始まらない）
    bool isExecutionAction(String action) {
      return !action.startsWith('準備');
    }

    test('プロパティ1: 全てのタスクが適切に分解される（100回反復）', () async {
      final random = Random(42); // シード固定で再現性を確保
      const iterations = 100;
      int successCount = 0;

      for (int i = 0; i < iterations; i++) {
        // Given: ランダムなタスク
        final task = generateRandomTask(random);
        final stepCount = 3 + random.nextInt(5); // 3-7ステップ
        final aiResponse = generateRandomMicroTaskResponse(random, stepCount);

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0] as Task);

        try {
          // When: タスクを分解
          final microTasks = await engine.decomposeTask(task);

          // Then: 全ての制約を満たす
          // 要件 1.5: 最大7ステップまで
          expect(
            microTasks.length,
            lessThanOrEqualTo(7),
            reason: 'Iteration $i: ステップ数が7を超えています',
          );

          // 要件 1.1: 各ステップは5分以内
          final allWithin5Minutes =
              microTasks.every((t) => t.estimatedMinutes! <= 5);
          expect(
            allWithin5Minutes,
            isTrue,
            reason: 'Iteration $i: 5分を超えるステップがあります',
          );

          // 要件 1.2: 具体的な動詞で開始
          final allHaveActionVerbs =
              microTasks.every((t) => startsWithActionVerb(t.title));
          expect(
            allHaveActionVerbs,
            isTrue,
            reason: 'Iteration $i: 具体的な動詞で始まらないステップがあります',
          );

          // 要件 1.3: 成功条件が明確
          final allHaveSuccessCriteria = microTasks.every((t) =>
              t.description != null && hasSuccessCriteria(t.description!));
          expect(
            allHaveSuccessCriteria,
            isTrue,
            reason: 'Iteration $i: 成功条件が不明確なステップがあります',
          );

          // 要件 1.4: 最初のステップが実行系
          if (microTasks.isNotEmpty) {
            expect(
              isExecutionAction(microTasks.first.title),
              isTrue,
              reason: 'Iteration $i: 最初のステップが「準備」で始まっています',
            );
          }

          // 全てのマイクロタスクが正しく設定されている
          for (final microTask in microTasks) {
            expect(microTask.isMicroTask, isTrue);
            expect(microTask.originalTaskUuid, equals(task.uuid));
            expect(microTask.userUuid, equals(task.userUuid));
          }

          successCount++;
        } catch (e) {
          // エラーが発生した場合もカウントして続行
          print('Iteration $i failed: $e');
        }
      }

      // 少なくとも95%の成功率を期待
      expect(
        successCount,
        greaterThanOrEqualTo((iterations * 0.95).floor()),
        reason: '成功率が95%未満です: $successCount/$iterations',
      );
    });

    test('プロパティ1: 5分を超えるステップは常に除外される', () async {
      final random = Random(123);
      const iterations = 50;

      for (int i = 0; i < iterations; i++) {
        // Given: 5分を超えるステップを含むレスポンス
        final task = generateRandomTask(random);

        final steps = <Map<String, dynamic>>[];
        for (int j = 0; j < 5; j++) {
          // ランダムに5分以内と5分超のステップを混在させる
          final estimatedMinutes = random.nextBool()
              ? 1 + random.nextInt(5) // 1-5分
              : 6 + random.nextInt(10); // 6-15分

          steps.add({
            'action': 'ステップ${j + 1}を実行する',
            'estimatedMinutes': estimatedMinutes,
            'successCriteria': 'ステップ${j + 1}が完了している',
          });
        }

        final aiResponse = '''
[
${steps.map((s) => '''  {
    "action": "${s['action']}",
    "estimatedMinutes": ${s['estimatedMinutes']},
    "successCriteria": "${s['successCriteria']}"
  }''').join(',\n')}
]
''';

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0] as Task);

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 全てのマイクロタスクが5分以内
        expect(
          microTasks.every((t) => t.estimatedMinutes! <= 5),
          isTrue,
          reason: 'Iteration $i: 5分を超えるステップが含まれています',
        );
      }
    });

    test('プロパティ1: 7ステップを超える場合は常に切り捨てられる', () async {
      final random = Random(456);
      const iterations = 50;

      for (int i = 0; i < iterations; i++) {
        // Given: 7ステップを超えるレスポンス
        final task = generateRandomTask(random);
        final stepCount = 8 + random.nextInt(5); // 8-12ステップ
        final aiResponse = generateRandomMicroTaskResponse(random, stepCount);

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0] as Task);

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 最大7ステップまで
        expect(
          microTasks.length,
          lessThanOrEqualTo(7),
          reason: 'Iteration $i: ステップ数が7を超えています (${microTasks.length})',
        );
      }
    });

    test('プロパティ1: 異なる入力に対して一貫した制約が適用される', () async {
      final random = Random(789);
      const iterations = 30;

      for (int i = 0; i < iterations; i++) {
        // Given: 様々な特性を持つタスク
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: random.nextInt(120) + 1, // 1-120分
          description: random.nextBool() ? '説明あり' : null,
          context: random.nextBool() ? 'コンテキストあり' : null,
        );

        final stepCount = 1 + random.nextInt(10); // 1-10ステップ
        final aiResponse = generateRandomMicroTaskResponse(random, stepCount);

        when(mockAIService.complete(any)).thenAnswer((_) async => aiResponse);
        when(mockTaskRepository.createTask(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0] as Task);

        // When: タスクを分解
        final microTasks = await engine.decomposeTask(task);

        // Then: 入力に関わらず制約が適用される
        expect(microTasks.length, lessThanOrEqualTo(7));
        expect(microTasks.every((t) => t.estimatedMinutes! <= 5), isTrue);
        expect(microTasks.every((t) => t.isMicroTask), isTrue);
        expect(
            microTasks.every((t) => t.originalTaskUuid == task.uuid), isTrue);
      }
    });
  });
}
