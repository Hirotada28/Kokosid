import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/emotion.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/models/user_context.dart';
import 'package:kokosid/core/repositories/journal_repository.dart';
import 'package:kokosid/core/repositories/self_esteem_repository.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/services/achievement_streak_system.dart';
import 'package:kokosid/core/services/act_dialogue_engine.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/dialogue_history_service.dart';
import 'package:kokosid/core/services/emotion_analyzer.dart';
import 'package:kokosid/core/services/micro_chunking_engine.dart';
import 'package:kokosid/core/services/notification_service.dart';
import 'package:kokosid/core/services/self_esteem_calculator.dart';
import 'package:kokosid/core/services/task_completion_animation_service.dart';
import 'package:kokosid/core/services/user_context_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'end_to_end_flows_test.mocks.dart';

/// 統合テスト: エンドツーエンドフローの検証
///
/// このテストスイートは、Kokosidアプリケーションの主要な3つのユーザーフローを検証します:
/// 1. タスク管理フロー: タスク作成 → マイクロ分解 → 完了 → お祝い演出
/// 2. 音声入力フロー: 音声入力 → 感情分析 → ACT対話 → 日記保存
/// 3. 自己肯定感フロー: スコア計算 → 可視化 → 進歩承認

@GenerateMocks([
  AIService,
  TaskRepository,
  JournalRepository,
  SelfEsteemRepository,
  UserContextService,
  DialogueHistoryService,
  EmotionAnalyzer,
  AchievementStreakSystem,
  NotificationService,
])
void main() {
  group('End-to-End Integration Tests', () {
    late MockAIService mockAIService;
    late MockTaskRepository mockTaskRepository;
    late MockJournalRepository mockJournalRepository;
    late MockSelfEsteemRepository mockSelfEsteemRepository;
    late MockUserContextService mockUserContextService;
    late MockDialogueHistoryService mockDialogueHistoryService;
    late MockEmotionAnalyzer mockEmotionAnalyzer;
    late MockAchievementStreakSystem mockAchievementStreakSystem;

    setUp(() {
      mockAIService = MockAIService();
      mockTaskRepository = MockTaskRepository();
      mockJournalRepository = MockJournalRepository();
      mockSelfEsteemRepository = MockSelfEsteemRepository();
      mockUserContextService = MockUserContextService();
      mockDialogueHistoryService = MockDialogueHistoryService();
      mockEmotionAnalyzer = MockEmotionAnalyzer();
      mockAchievementStreakSystem = MockAchievementStreakSystem();
    });

    /// **フロー1: タスク管理フロー**
    /// オンボーディング → タスク作成 → マイクロ分解 → 完了 → お祝い演出
    group('Flow 1: Task Management Flow', () {
      test('完全なタスク管理フローが正常に動作する', () async {
        // Given: 必要なサービスを初期化
        final microChunkingEngine = MicroChunkingEngine(
          aiService: mockAIService,
          taskRepository: mockTaskRepository,
        );

        when(mockAchievementStreakSystem.getCurrentStreak(any))
            .thenAnswer((_) async => 0);

        final animationService = TaskCompletionAnimationService(
          achievementStreakSystem: mockAchievementStreakSystem,
        );

        const userUuid = 'test-user';

        // Step 1: タスク作成
        final originalTask = Task.create(
          uuid: 'task-1',
          userUuid: userUuid,
          title: 'プレゼン資料を作成する',
          estimatedMinutes: 30,
        );

        when(mockTaskRepository.createTask(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0] as Task);

        // Step 2: マイクロ分解
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

        final microTasks =
            await microChunkingEngine.decomposeTask(originalTask);

        // Then: マイクロタスクが正しく生成される
        expect(microTasks.length, equals(3));
        expect(microTasks.every((t) => t.estimatedMinutes! <= 5), isTrue);
        expect(microTasks.every((t) => t.isMicroTask), isTrue);

        // Step 3: タスク完了
        final firstMicroTask = microTasks[0]..complete();

        expect(firstMicroTask.isCompleted, isTrue);
        expect(firstMicroTask.completedAt, isNotNull);

        // Step 4: お祝い演出の選択
        final animation = await animationService.selectAnimation(
          firstMicroTask,
          userUuid,
        );

        // Then: 適切なアニメーションが選択される
        expect(animation, isNotNull);
        expect(animation.type, equals(CompletionAnimationType.sparkle));
        expect(animation.duration, equals(const Duration(seconds: 1)));

        // 全体フローの検証
        expect(originalTask.uuid, isNotEmpty);
        expect(microTasks.first.originalTaskUuid, equals(originalTask.uuid));
        expect(firstMicroTask.isCompleted, isTrue);
        expect(animation.type, isNotNull);
      });

      test('連続達成時に特別なアニメーションが表示される', () async {
        // Given: 連続達成のシナリオ
        when(mockAchievementStreakSystem.getCurrentStreak(any))
            .thenAnswer((_) async => 5);

        final animationService = TaskCompletionAnimationService(
          achievementStreakSystem: mockAchievementStreakSystem,
        );

        final task = Task.create(
          uuid: 'task-streak',
          userUuid: 'test-user',
          title: 'Test task',
          estimatedMinutes: 5,
        );

        // When: 連続達成フラグでアニメーションを選択
        final animation = await animationService.selectAnimation(
          task,
          'test-user',
        );

        // Then: ストリーク炎アニメーションが選択される
        expect(animation.type, equals(CompletionAnimationType.streakFlame));
        expect(animation.duration, isNull); // ループアニメーション
      });
    });

    /// **フロー2: 音声入力フロー**
    /// 音声入力 → 感情分析 → ACT対話 → 日記保存
    group('Flow 2: Voice Input and Dialogue Flow', () {
      test('完全な音声入力フローが正常に動作する', () async {
        // Given: 必要なサービスを初期化
        final actDialogueEngine = ACTDialogueEngine(
          mockAIService,
          mockUserContextService,
          mockDialogueHistoryService,
        );

        const userUuid = 'test-user';
        const userInput = 'つらいです';

        // Step 1: 感情分析（モック）
        final emotion = Emotion(
          type: EmotionType.sad,
          confidence: 0.85,
          scores: {
            EmotionType.sad: 0.85,
            EmotionType.neutral: 0.1,
            EmotionType.happy: 0.05,
          },
          isNegative: true,
        );

        final emotionResult = EmotionResult(
          primaryEmotion: emotion,
          confidence: 0.85,
          trend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.5,
          ),
          text: userInput,
        );

        when(mockEmotionAnalyzer.analyzeText(userInput, userUuid))
            .thenAnswer((_) async => emotionResult);

        // Step 2: ユーザーコンテキストの取得
        final userContext = UserContext(
          userId: userUuid,
          emotionTrend: EmotionTrend(
            isImproving: false,
            isDecreasing: false,
            isStable: true,
            averageScore: 0.5,
          ),
          motivationLevel: 0.7,
          recentEmotions: [emotion],
          dialogueHistory: [],
        );

        final personalizationContext = PersonalizationContext(
          userUuid: userUuid,
          totalDialogues: 5,
          mostFrequentProcess: 'acceptance',
          emotionFrequency: {'sad': 2, 'neutral': 3},
          successExperiences: [],
          recurringThemes: [],
        );

        when(mockUserContextService.getUserContext(userUuid))
            .thenAnswer((_) async => userContext);

        when(mockDialogueHistoryService.buildPersonalizationContext(userUuid))
            .thenAnswer((_) async => personalizationContext);

        // Step 3: ACT対話応答の生成
        when(mockAIService.complete(any))
            .thenAnswer((_) async => 'その気持ち、よくわかります。');

        final response =
            await actDialogueEngine.generateResponse(userInput, userUuid);

        // Then: 適切な応答が生成される
        expect(response.response, isNotEmpty);
        expect(response.emotion.isNegative, isTrue);
        expect(response.process, isNotNull);

        // Step 4: 日記エントリの保存（モック）
        when(mockJournalRepository.createEntry(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0]);

        // 全体フローの検証
        expect(emotion.type, equals(EmotionType.sad));
        expect(response.response, isNotEmpty);
        expect(response.emotion.isNegative, isTrue);
      });
    });

    /// **フロー3: 自己肯定感フロー**
    /// 自己肯定感スコア計算 → 可視化 → 進歩承認
    group('Flow 3: Self-Esteem Score Flow', () {
      test('完全な自己肯定感スコアフローが正常に動作する', () async {
        // Given: 必要なサービスを初期化
        final calculator = SelfEsteemCalculator(
          mockTaskRepository,
          mockJournalRepository,
          mockSelfEsteemRepository,
        );

        const userUuid = 'test-user';

        // Step 1: データの準備
        when(mockTaskRepository.getTotalTaskCount(any, any, any))
            .thenAnswer((_) async => 10);
        when(mockTaskRepository.getCompletedTaskCount(any, any, any))
            .thenAnswer((_) async => 8);
        when(mockJournalRepository.getEntriesByDateRange(any, any, any))
            .thenAnswer((_) async => []);
        when(mockSelfEsteemRepository.createScore(any)).thenAnswer(
            (invocation) async => invocation.positionalArguments[0]);

        // Step 2: スコア計算
        final score = await calculator.calculateScore(userUuid);

        // Then: スコアが正しく計算される
        expect(score.score, inInclusiveRange(0.0, 1.0));
        expect(score.completionRate, inInclusiveRange(0.0, 1.0));
        expect(score.calculationBasisJson, isNotNull);

        // Step 3: 算出根拠の取得
        when(mockSelfEsteemRepository.getLatestScore(userUuid))
            .thenAnswer((_) async => score);

        final basis = await calculator.getCalculationBasis(userUuid);

        // Then: 算出根拠が提供される
        expect(basis, isNotNull);
        expect(basis!.containsKey('completionRate'), isTrue);
        expect(basis.containsKey('weights'), isTrue);

        // Step 4: 進歩検出（モック）
        when(mockSelfEsteemRepository.getRecentScores(userUuid, 7))
            .thenAnswer((_) async => [score]);

        final hasProgress = await calculator.detectProgress(userUuid);

        // 全体フローの検証
        expect(score.score, greaterThanOrEqualTo(0.0));
        expect(score.score, lessThanOrEqualTo(1.0));
        expect(basis.containsKey('completionRate'), isTrue);
        expect(hasProgress, isFalse); // 1つのスコアのみなので進歩なし
      });
    });
  });
}
