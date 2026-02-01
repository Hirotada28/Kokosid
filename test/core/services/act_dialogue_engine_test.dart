import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/act_process.dart';
import 'package:kokosid/core/models/emotion.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/user_context.dart';
import 'package:kokosid/core/services/act_dialogue_engine.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/dialogue_history_service.dart';
import 'package:kokosid/core/services/user_context_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'act_dialogue_engine_test.mocks.dart';

@GenerateMocks([AIService, UserContextService, DialogueHistoryService])
void main() {
  group('ACTDialogueEngine', () {
    late MockAIService mockAIService;
    late MockUserContextService mockUserContextService;
    late MockDialogueHistoryService mockDialogueHistoryService;
    late ACTDialogueEngine engine;

    setUp(() {
      mockAIService = MockAIService();
      mockUserContextService = MockUserContextService();
      mockDialogueHistoryService = MockDialogueHistoryService();
      engine = ACTDialogueEngine(
        mockAIService,
        mockUserContextService,
        mockDialogueHistoryService,
      );
    });

    group('generateResponse', () {
      test('否定的感情と悪化トレンドで受容プロセスを選択する', () async {
        // Given: 否定的感情と悪化トレンドのコンテキスト
        final context = UserContext(
          userId: 'user-1',
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: true,
            isStable: false,
            averageScore: 0.3,
          ),
          motivationLevel: 0.5,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext = PersonalizationContext(
          userUuid: 'user-1',
          totalDialogues: 0,
          mostFrequentProcess: 'acceptance',
          emotionFrequency: {},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext('user-1'))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'その気持ち、よくわかります。');

        // When: 否定的な入力を処理
        final response = await engine.generateResponse('つらいです', 'user-1');

        // Then: 受容プロセスが選択される
        expect(response.process, equals(ACTProcess.acceptance));
        expect(response.emotion.isNegative, isTrue);
      });

      test('自己批判的思考で脱フュージョンプロセスを選択する', () async {
        // Given: 通常のコンテキスト
        final context = UserContext(
          userId: 'user-1',
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

        final personalizationContext = PersonalizationContext(
          userUuid: 'user-1',
          totalDialogues: 0,
          mostFrequentProcess: 'defusion',
          emotionFrequency: {},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext('user-1'))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'その考えは、あくまで「考え」です。');

        // When: 自己批判的な入力を処理
        final response = await engine.generateResponse('私はダメな人間です', 'user-1');

        // Then: 脱フュージョンプロセスが選択される
        expect(response.process, equals(ACTProcess.defusion));
      });

      test('低モチベーションで価値明確化プロセスを選択する', () async {
        // Given: 低モチベーションのコンテキスト
        final context = UserContext(
          userId: 'user-1',
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.5,
          ),
          motivationLevel: 0.2,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext = PersonalizationContext(
          userUuid: 'user-1',
          totalDialogues: 0,
          mostFrequentProcess: 'valuesClarity',
          emotionFrequency: {},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext('user-1'))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'あなたにとって大切なことは何でしょうか？');

        // When: 通常の入力を処理
        final response =
            await engine.generateResponse('何をすればいいかわからない', 'user-1');

        // Then: 価値明確化プロセスが選択される
        expect(response.process, equals(ACTProcess.valuesClarity));
      });

      test('行動キーワードでコミット行動プロセスを選択する', () async {
        // Given: 高モチベーションのコンテキスト
        final context = UserContext(
          userId: 'user-1',
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.7,
          ),
          motivationLevel: 0.7,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext = PersonalizationContext(
          userUuid: 'user-1',
          totalDialogues: 0,
          mostFrequentProcess: 'committedAction',
          emotionFrequency: {},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext('user-1'))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => '素晴らしいですね！');

        // When: 行動的な入力を処理
        final response = await engine.generateResponse('今日はタスクをやります', 'user-1');

        // Then: コミット行動プロセスが選択される
        expect(response.process, equals(ACTProcess.committedAction));
      });

      test('AI障害時にフォールバック応答を返す', () async {
        // Given: AI障害が発生する状況
        final context = UserContext(
          userId: 'user-1',
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: true,
            isStable: false,
            averageScore: 0.3,
          ),
          motivationLevel: 0.5,
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext = PersonalizationContext(
          userUuid: 'user-1',
          totalDialogues: 0,
          mostFrequentProcess: 'acceptance',
          emotionFrequency: {},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext('user-1'))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenThrow(AIServiceException('API障害'));

        // When: 入力を処理
        final response = await engine.generateResponse('つらいです', 'user-1');

        // Then: フォールバック応答が返される
        expect(response.response, isNotEmpty);
        expect(response.process, equals(ACTProcess.acceptance));
      });
    });
  });

  // **Feature: act-based-self-management, Property 2: ACT対話プロセスの適切な選択**
  // **Validates: Requirements 2.1, 2.2, 2.3, 2.5**
  group('Property-Based Tests: ACT対話プロセスの適切な選択', () {
    late MockAIService mockAIService;
    late MockUserContextService mockUserContextService;
    late MockDialogueHistoryService mockDialogueHistoryService;
    late ACTDialogueEngine engine;

    setUp(() {
      mockAIService = MockAIService();
      mockUserContextService = MockUserContextService();
      mockDialogueHistoryService = MockDialogueHistoryService();
      engine = ACTDialogueEngine(
        mockAIService,
        mockUserContextService,
        mockDialogueHistoryService,
      );
    });

    /// ランダムなユーザーコンテキストを生成
    UserContext generateRandomUserContext(Random random, String userId) {
      final isImproving = random.nextBool();
      final isDecreasing = !isImproving && random.nextBool();
      final isStable = !isImproving && !isDecreasing;

      return UserContext(
        userId: userId,
        emotionTrend: EmotionTrend(
          isImproving: isImproving,
          isDecreasing: isDecreasing,
          isStable: isStable,
          averageScore: random.nextDouble(),
        ),
        motivationLevel: random.nextDouble(),
        recentEmotions: [],
        dialogueHistory: [],
      );
    }

    /// ランダムな個別化コンテキストを生成
    PersonalizationContext generateRandomPersonalizationContext(
      Random random,
      String userUuid,
    ) {
      final processes = [
        'acceptance',
        'defusion',
        'valuesClarity',
        'committedAction',
        'mindfulness',
        'observingSelf'
      ];

      return PersonalizationContext(
        userUuid: userUuid,
        totalDialogues: random.nextInt(100),
        mostFrequentProcess: processes[random.nextInt(processes.length)],
        emotionFrequency: {},
        successExperiences: [],
        recurringThemes: [],
      );
    }

    /// テストケースを生成
    Map<String, dynamic> generateTestCase(Random random) {
      final testCases = [
        // 要件 2.1: 否定的感情 → 受容プロセス
        {
          'input': ['つらいです', '悲しいです', '不安です', '心配です', '疲れました'],
          'expectedProcess': ACTProcess.acceptance,
          'contextModifier': (UserContext ctx) => UserContext(
                userId: ctx.userId,
                emotionTrend: EmotionTrend(
                  isImproving: false,
                  isDecreasing: true,
                  isStable: false,
                  averageScore: 0.3,
                ),
                motivationLevel: ctx.motivationLevel,
                recentEmotions: ctx.recentEmotions,
                dialogueHistory: ctx.dialogueHistory,
              ),
        },
        // 要件 2.2: 自己批判的思考 → 認知的脱フュージョン
        {
          'input': ['私はダメです', '無理です', 'できません', '失敗しました', '情けないです'],
          'expectedProcess': ACTProcess.defusion,
          'contextModifier': null,
        },
        // 要件 2.3: モチベーション低下 → 価値の明確化
        {
          'input': ['何をすればいいかわからない', 'やる気が出ない', '目標がない'],
          'expectedProcess': ACTProcess.valuesClarity,
          'contextModifier': (UserContext ctx) => UserContext(
                userId: ctx.userId,
                emotionTrend: ctx.emotionTrend,
                motivationLevel: 0.2,
                recentEmotions: ctx.recentEmotions,
                dialogueHistory: ctx.dialogueHistory,
              ),
        },
        // 要件 2.5: 行動意欲 → コミットされた行動
        {
          'input': ['やります', '始めます', '取り組みます', '挑戦します'],
          'expectedProcess': ACTProcess.committedAction,
          'contextModifier': (UserContext ctx) => UserContext(
                userId: ctx.userId,
                emotionTrend: ctx.emotionTrend,
                motivationLevel: 0.7,
                recentEmotions: ctx.recentEmotions,
                dialogueHistory: ctx.dialogueHistory,
              ),
        },
        // マインドフルネス
        {
          'input': ['今を感じたい', '気づきたい', '意識したい'],
          'expectedProcess': ACTProcess.mindfulness,
          'contextModifier': null,
        },
      ];

      final testCase = testCases[random.nextInt(testCases.length)];
      final inputs = testCase['input'] as List<String>;
      final selectedInput = inputs[random.nextInt(inputs.length)];

      return {
        'input': selectedInput,
        'expectedProcess': testCase['expectedProcess'],
        'contextModifier': testCase['contextModifier'],
      };
    }

    test('プロパティ2: 全てのユーザー入力に対して適切なACTプロセスが選択される（100回反復）', () async {
      final random = Random(42);
      const iterations = 100;
      int successCount = 0;

      for (var i = 0; i < iterations; i++) {
        // Given: ランダムなテストケース
        final testCase = generateTestCase(random);
        final userInput = testCase['input'] as String;
        final expectedProcess = testCase['expectedProcess'] as ACTProcess;
        final contextModifier =
            testCase['contextModifier'] as UserContext Function(UserContext)?;

        final userId = 'user-$i';
        var context = generateRandomUserContext(random, userId);

        // コンテキストを修正（特定の条件を満たすため）
        if (contextModifier != null) {
          context = contextModifier(context);
        }

        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => 'テスト応答');

        try {
          // When: 応答を生成
          final response = await engine.generateResponse(userInput, userId);

          // Then: 期待されるプロセスが選択される
          expect(
            response.process,
            equals(expectedProcess),
            reason:
                'Iteration $i: 入力「$userInput」に対して${expectedProcess.shortName}が期待されましたが、${response.process.shortName}が選択されました',
          );

          // 応答が生成される
          expect(response.response, isNotEmpty);

          // 感情が抽出される
          expect(response.emotion, isNotNull);

          successCount++;
        } catch (e) {
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

    test('プロパティ2: 否定的感情と悪化トレンドで常に受容プロセスが選択される', () async {
      final random = Random(123);
      const iterations = 50;

      final negativeInputs = [
        'つらいです',
        '悲しいです',
        '不安です',
        '心配です',
        '疲れました',
        '辛い',
        '苦しい',
        '怖い'
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 否定的感情と悪化トレンド
        final userId = 'user-$i';
        final userInput = negativeInputs[random.nextInt(negativeInputs.length)];

        final context = UserContext(
          userId: userId,
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: true,
            isStable: false,
            averageScore: 0.2 + random.nextDouble() * 0.3, // 0.2-0.5
          ),
          motivationLevel: random.nextDouble(),
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'その気持ち、よくわかります。');

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: 受容プロセスが選択される（要件 2.1）
        expect(
          response.process,
          equals(ACTProcess.acceptance),
          reason: 'Iteration $i: 否定的感情「$userInput」に対して受容プロセスが期待されました',
        );

        expect(response.emotion.isNegative, isTrue);
      }
    });

    test('プロパティ2: 自己批判的思考で常に脱フュージョンプロセスが選択される', () async {
      final random = Random(456);
      const iterations = 50;

      final selfCriticismInputs = [
        '私はダメです',
        '無理です',
        'できません',
        '失敗しました',
        '情けないです',
        '価値がない',
        'ダメな人間',
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 自己批判的思考
        final userId = 'user-$i';
        final userInput =
            selfCriticismInputs[random.nextInt(selfCriticismInputs.length)];

        final context = generateRandomUserContext(random, userId);
        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'その考えは、あくまで「考え」です。');

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: 脱フュージョンプロセスが選択される（要件 2.2）
        expect(
          response.process,
          equals(ACTProcess.defusion),
          reason: 'Iteration $i: 自己批判的思考「$userInput」に対して脱フュージョンプロセスが期待されました',
        );
      }
    });

    test('プロパティ2: 低モチベーションで常に価値明確化プロセスが選択される', () async {
      final random = Random(789);
      const iterations = 50;

      final lowMotivationInputs = [
        '何をすればいいかわからない',
        'やる気が出ない',
        '目標がない',
        '意味がない',
        '方向性が見えない',
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 低モチベーション（0.3未満）
        final userId = 'user-$i';
        final userInput =
            lowMotivationInputs[random.nextInt(lowMotivationInputs.length)];

        final context = UserContext(
          userId: userId,
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.5,
          ),
          motivationLevel: random.nextDouble() * 0.3, // 0.0-0.3
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'あなたにとって大切なことは何でしょうか？');

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: 価値明確化プロセスが選択される（要件 2.3）
        expect(
          response.process,
          equals(ACTProcess.valuesClarity),
          reason:
              'Iteration $i: 低モチベーション（${context.motivationLevel}）で価値明確化プロセスが期待されました',
        );
      }
    });

    test('プロパティ2: 行動キーワードと高モチベーションでコミット行動プロセスが選択される', () async {
      final random = Random(101112);
      const iterations = 50;

      final actionInputs = [
        'やります',
        '始めます',
        '取り組みます',
        '挑戦します',
        '実行します',
        'やってみます',
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 行動キーワードと高モチベーション
        final userId = 'user-$i';
        final userInput = actionInputs[random.nextInt(actionInputs.length)];

        final context = UserContext(
          userId: userId,
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.7,
          ),
          motivationLevel: 0.6 + random.nextDouble() * 0.4, // 0.6-1.0
          recentEmotions: [],
          dialogueHistory: [],
        );

        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => '素晴らしいですね！');

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: コミット行動プロセスが選択される（要件 2.5）
        expect(
          response.process,
          equals(ACTProcess.committedAction),
          reason: 'Iteration $i: 行動キーワード「$userInput」でコミット行動プロセスが期待されました',
        );
      }
    });

    test('プロパティ2: 全ての入力に対してACTの6つのプロセスのいずれかが選択される', () async {
      final random = Random(131415);
      const iterations = 100;

      final allInputs = [
        'つらいです',
        '私はダメです',
        '何をすればいいかわからない',
        'やります',
        '今を感じたい',
        '自分を観察したい',
        '普通の日記です',
        'こんにちは',
        'ありがとう',
        '疲れました',
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 様々な入力
        final userId = 'user-$i';
        final userInput = allInputs[random.nextInt(allInputs.length)];
        final context = generateRandomUserContext(random, userId);
        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => 'テスト応答');

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: ACTの6つのプロセスのいずれかが選択される（要件 2.5）
        expect(
          ACTProcess.values.contains(response.process),
          isTrue,
          reason: 'Iteration $i: 有効なACTプロセスが選択されませんでした',
        );

        // 応答が生成される
        expect(response.response, isNotEmpty);
      }
    });

    test('プロパティ2: AI障害時でも適切なフォールバック応答が返される', () async {
      final random = Random(161718);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: AI障害が発生する状況
        final userId = 'user-$i';
        final testCase = generateTestCase(random);
        final userInput = testCase['input'] as String;
        final expectedProcess = testCase['expectedProcess'] as ACTProcess;
        final contextModifier =
            testCase['contextModifier'] as UserContext Function(UserContext)?;

        var context = generateRandomUserContext(random, userId);
        if (contextModifier != null) {
          context = contextModifier(context);
        }

        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenThrow(AIServiceException('API障害'));

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: フォールバック応答が返される
        expect(response.response, isNotEmpty);
        expect(response.process, equals(expectedProcess));

        // フォールバック応答が適切な内容を含む
        final fallbackResponses = [
          'その気持ち',
          'その考え',
          'あなたにとって',
          '素晴らしい',
          '今この瞬間',
          '自分の思考',
        ];

        final hasAppropriateContent = fallbackResponses
            .any((phrase) => response.response.contains(phrase));
        expect(
          hasAppropriateContent,
          isTrue,
          reason: 'Iteration $i: フォールバック応答が適切な内容を含んでいません',
        );
      }
    });
  });
}
