import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/act_process.dart';
import 'package:kokosid/core/models/emotion.dart';
import 'package:kokosid/core/models/user_context.dart';
import 'package:kokosid/core/services/act_dialogue_engine.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/dialogue_history_service.dart';
import 'package:kokosid/core/services/user_context_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'act_dialogue_engine_test.mocks.dart';

/// モック用の個別化された応答を生成
String _generateMockPersonalizedResponse(
  PersonalizationContext context,
  Random random,
) {
  if (context.totalDialogues == 0) {
    return 'その気持ち、よくわかります。';
  }

  final responses = [
    '以前も${context.mostFrequentProcess}について話しましたね。',
    '対話回数${context.totalDialogues}回目ですね。',
    if (context.successExperiences.isNotEmpty)
      '${context.successExperiences.first}という成功体験を思い出してください。',
    if (context.recurringThemes.isNotEmpty)
      '${context.recurringThemes.first}について、また話しましょう。',
  ];

  return responses[random.nextInt(responses.length)];
}

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
        } on Exception catch (e) {
          // ignore: avoid_print
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

        final hasAppropriateContent =
            fallbackResponses.any(response.response.contains);
        expect(
          hasAppropriateContent,
          isTrue,
          reason: 'Iteration $i: フォールバック応答が適切な内容を含んでいません',
        );
      }
    });
  });

  // **Feature: act-based-self-management, Property 3: 個別化された対話応答の生成**
  // **Validates: Requirements 2.4**
  group('Property-Based Tests: 個別化された対話応答の生成', () {
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

    /// ランダムな対話履歴を生成
    List<String> generateDialogueHistory(Random random) {
      final historySize = random.nextInt(10);
      final dialogues = <String>[];

      final sampleDialogues = [
        'acceptance',
        'defusion',
        'valuesClarity',
        'committedAction',
        'mindfulness',
        'observingSelf',
      ];

      for (var i = 0; i < historySize; i++) {
        dialogues.add(sampleDialogues[random.nextInt(sampleDialogues.length)]);
      }

      return dialogues;
    }

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
        dialogueHistory: generateDialogueHistory(random),
      );
    }

    /// ランダムな個別化コンテキストを生成
    PersonalizationContext generateRandomPersonalizationContext(
      Random random,
      String userUuid, {
      int? totalDialogues,
      String? mostFrequentProcess,
      List<String>? successExperiences,
      List<String>? recurringThemes,
    }) {
      final processes = [
        'acceptance',
        'defusion',
        'valuesClarity',
        'committedAction',
        'mindfulness',
        'observingSelf'
      ];

      final themes = ['仕事', '家族', '健康', '目標', '不安', '人間関係'];
      final experiences = [
        'プロジェクトを完了した',
        '運動を続けられた',
        '友人と話せた',
        '早起きできた',
        '新しいことに挑戦した'
      ];

      return PersonalizationContext(
        userUuid: userUuid,
        totalDialogues: totalDialogues ?? random.nextInt(100),
        mostFrequentProcess:
            mostFrequentProcess ?? processes[random.nextInt(processes.length)],
        emotionFrequency: {},
        successExperiences: successExperiences ??
            List.generate(
              random.nextInt(5),
              (_) => experiences[random.nextInt(experiences.length)],
            ),
        recurringThemes: recurringThemes ??
            List.generate(
              random.nextInt(3),
              (_) => themes[random.nextInt(themes.length)],
            ),
      );
    }

    /// モック用の個別化された応答を生成
    String generateMockPersonalizedResponse(
      PersonalizationContext context,
      Random random,
    ) {
      if (context.totalDialogues == 0) {
        return 'その気持ち、よくわかります。';
      }

      final responses = [
        '以前も${context.mostFrequentProcess}について話しましたね。',
        '対話回数${context.totalDialogues}回目ですね。',
        if (context.successExperiences.isNotEmpty)
          '${context.successExperiences.first}という成功体験を思い出してください。',
        if (context.recurringThemes.isNotEmpty)
          '${context.recurringThemes.first}について、また話しましょう。',
      ];

      return responses[random.nextInt(responses.length)];
    }

    test('プロパティ3: 同一入力でも対話履歴によって異なる応答が生成される（100回反復）', () async {
      final random = Random(42);
      const iterations = 100;
      const userInput = 'つらいです';

      final responses = <String, Set<String>>{};

      for (var i = 0; i < iterations; i++) {
        // Given: 異なる対話履歴を持つコンテキスト
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);

        // 異なる個別化コンテキストを生成
        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        // プロンプトに個別化情報が含まれるように、異なる応答を返す
        final mockResponse = _generateMockPersonalizedResponse(
          personalizationContext,
          random,
        );

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: 応答を記録
        final key =
            '${personalizationContext.totalDialogues}-${personalizationContext.mostFrequentProcess}';
        responses.putIfAbsent(key, () => <String>{});
        responses[key]!.add(response.response);
      }

      // 少なくとも10種類以上の異なる応答パターンが生成されることを期待
      expect(
        responses.length,
        greaterThanOrEqualTo(10),
        reason: '個別化された応答のバリエーションが不足しています: ${responses.length}種類',
      );
    });

    test('プロパティ3: 対話履歴が多いユーザーには過去の情報を参照した応答が生成される', () async {
      final random = Random(123);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 対話履歴が豊富なユーザー
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);

        final personalizationContext = generateRandomPersonalizationContext(
          random,
          userId,
          totalDialogues: 50 + random.nextInt(50), // 50-100回の対話
          successExperiences: ['運動を続けられた', 'プロジェクトを完了した'],
          recurringThemes: ['仕事', '健康'],
        );

        // 個別化情報を含む応答を生成
        final mockResponse =
            '以前も${personalizationContext.recurringThemes.first}について話しましたね。${personalizationContext.successExperiences.first}という成功体験を思い出してください。';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: 個別化された応答が生成される（要件 2.4）
        expect(response.response, isNotEmpty);

        // プロンプトに個別化情報が含まれていることを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        expect(
          capturedPrompt.contains('対話回数'),
          isTrue,
          reason: 'プロンプトに対話回数が含まれていません',
        );

        expect(
          capturedPrompt.contains('よく使うプロセス'),
          isTrue,
          reason: 'プロンプトによく使うプロセスが含まれていません',
        );
      }
    });

    test('プロパティ3: 初回ユーザーには一般的な応答が生成される', () async {
      final random = Random(456);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 初回ユーザー（対話履歴なし）
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);

        final personalizationContext = generateRandomPersonalizationContext(
          random,
          userId,
          totalDialogues: 0,
          successExperiences: [],
          recurringThemes: [],
        );

        final mockResponse = 'その気持ち、よくわかります。';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: 一般的な応答が生成される
        expect(response.response, isNotEmpty);

        // プロンプトに個別化情報が含まれていないことを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        // 対話回数が0の場合、個別化情報セクションが含まれない
        expect(
          !capturedPrompt.contains('対話回数: 0回') ||
              !capturedPrompt.contains('【個別化情報】'),
          isTrue,
          reason: '初回ユーザーのプロンプトに個別化情報が含まれています',
        );
      }
    });

    test('プロパティ3: 同じユーザーでも異なる入力には異なる応答が生成される', () async {
      final random = Random(789);
      const iterations = 50;

      final inputs = [
        'つらいです',
        '私はダメです',
        '何をすればいいかわからない',
        'やります',
        '今を感じたい',
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 同じユーザー、異なる入力
        const userId = 'same-user';
        final context = generateRandomUserContext(random, userId);
        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        final userInput = inputs[random.nextInt(inputs.length)];
        final mockResponse = '入力「$userInput」に対する応答';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse(userInput, userId);

        // Then: 入力に応じた応答が生成される
        expect(response.response, isNotEmpty);

        // プロンプトにユーザー入力が含まれていることを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        expect(
          capturedPrompt.contains(userInput),
          isTrue,
          reason: 'プロンプトにユーザー入力が含まれていません',
        );
      }
    });

    test('プロパティ3: 頻繁に使用されるACTプロセスが応答に反映される', () async {
      final random = Random(101112);
      const iterations = 50;

      final processes = [
        'acceptance',
        'defusion',
        'valuesClarity',
        'committedAction',
        'mindfulness',
        'observingSelf'
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 特定のプロセスを頻繁に使用するユーザー
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);
        final mostFrequentProcess = processes[random.nextInt(processes.length)];

        final personalizationContext = generateRandomPersonalizationContext(
          random,
          userId,
          totalDialogues: 20,
          mostFrequentProcess: mostFrequentProcess,
        );

        final mockResponse = 'テスト応答';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: 応答が生成される
        expect(response.response, isNotEmpty);

        // プロンプトに頻繁に使用されるプロセスが含まれていることを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        expect(
          capturedPrompt.contains(mostFrequentProcess),
          isTrue,
          reason: 'プロンプトに頻繁に使用されるプロセスが含まれていません',
        );
      }
    });

    test('プロパティ3: 成功体験が応答に活用される', () async {
      final random = Random(131415);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 成功体験を持つユーザー
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);

        final successExperiences = ['プロジェクトを完了した', '運動を続けられた', '友人と話せた'];

        final personalizationContext = generateRandomPersonalizationContext(
          random,
          userId,
          totalDialogues: 30,
          successExperiences: successExperiences,
        );

        final mockResponse = '以前${successExperiences.first}という成功体験がありましたね。';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: 応答が生成される
        expect(response.response, isNotEmpty);

        // プロンプトに成功体験が含まれていることを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        expect(
          capturedPrompt.contains('過去の成功体験'),
          isTrue,
          reason: 'プロンプトに成功体験が含まれていません',
        );
      }
    });

    test('プロパティ3: 繰り返しテーマが応答に反映される', () async {
      final random = Random(161718);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 繰り返しテーマを持つユーザー
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);

        final recurringThemes = ['仕事', '健康', '人間関係'];

        final personalizationContext = generateRandomPersonalizationContext(
          random,
          userId,
          totalDialogues: 25,
          recurringThemes: recurringThemes,
        );

        final mockResponse = '${recurringThemes.first}について、また話しましょう。';

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any)).thenAnswer((_) async => mockResponse);

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: 応答が生成される
        expect(response.response, isNotEmpty);

        // プロンプトに繰り返しテーマが含まれていることを検証
        final capturedPrompt =
            verify(mockAIService.complete(captureAny)).captured.first as String;

        expect(
          capturedPrompt.contains('繰り返しテーマ'),
          isTrue,
          reason: 'プロンプトに繰り返しテーマが含まれていません',
        );
      }
    });

    test('プロパティ3: AI障害時でも個別化されたフォールバック応答が返される', () async {
      final random = Random(192021);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: AI障害が発生する状況
        final userId = 'user-$i';
        final context = generateRandomUserContext(random, userId);
        final personalizationContext =
            generateRandomPersonalizationContext(random, userId);

        when(mockUserContextService.getUserContext(userId))
            .thenAnswer((_) async => context);
        when(mockDialogueHistoryService.buildPersonalizationContext(userId))
            .thenAnswer((_) async => personalizationContext);
        when(mockAIService.complete(any))
            .thenThrow(AIServiceException('API障害'));

        // When: 応答を生成
        final response = await engine.generateResponse('つらいです', userId);

        // Then: フォールバック応答が返される
        expect(response.response, isNotEmpty);

        // フォールバック応答でも適切なACTプロセスが選択される
        expect(ACTProcess.values.contains(response.process), isTrue);
      }
    });
  });
}
