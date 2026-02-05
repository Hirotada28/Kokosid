import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/emotion.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/success_experience.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/models/user_context.dart';
import 'package:kokosid/core/repositories/success_experience_repository.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/personalized_praise_service.dart';
import 'package:kokosid/core/services/user_context_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'personalized_praise_service_test.mocks.dart';

@GenerateMocks([
  AIService,
  UserContextService,
  SuccessExperienceRepository,
])
void main() {
  group('PersonalizedPraiseService', () {
    late MockAIService mockAIService;
    late MockUserContextService mockUserContextService;
    late MockSuccessExperienceRepository mockSuccessExperienceRepository;
    late PersonalizedPraiseService service;

    setUp(() {
      mockAIService = MockAIService();
      mockUserContextService = MockUserContextService();
      mockSuccessExperienceRepository = MockSuccessExperienceRepository();
      service = PersonalizedPraiseService(
        aiService: mockAIService,
        userContextService: mockUserContextService,
        successExperienceRepository: mockSuccessExperienceRepository,
      );
    });

    group('generatePraiseMessage', () {
      test('タスク完了時にパーソナライズされた賞賛メッセージを生成', () async {
        // Given: 完了したタスクとユーザーコンテキスト
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'レポートを完成させる',
          estimatedMinutes: 30,
        );

        final context = UserContext(
          userId: 'user-1',
          motivationLevel: 0.7,
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.7,
          ),
          recentEmotions: [
            Emotion.fromScores({
              EmotionType.happy: 0.8,
              EmotionType.neutral: 0.2,
            }),
          ],
          dialogueHistory: [],
        );

        final successExperiences = [
          SuccessExperience.create(
            uuid: 'success-1',
            userUuid: 'user-1',
            title: '前回のプロジェクト完了',
            description: '困難を乗り越えてプロジェクトを完了した',
          ),
        ];

        when(mockUserContextService.getUserContext('user-1'))
            .thenAnswer((_) async => context);
        when(mockSuccessExperienceRepository.getRecentSuccessExperiences(
          'user-1',
          limit: 5,
        )).thenAnswer((_) async => successExperiences);
        when(mockAIService.complete(any))
            .thenAnswer((_) async => '素晴らしい！レポート完成おめでとうございます！');

        // When: 賞賛メッセージを生成
        final message = await service.generatePraiseMessage(task, 'user-1');

        // Then: メッセージが生成される
        expect(message, isNotEmpty);
        verify(mockAIService.complete(any)).called(1);
      });
    });

    group('remindSuccessExperience', () {
      test('否定的感情時に成功体験を思い出させる', () async {
        // Given: 否定的な感情状態
        final currentEmotion = Emotion.fromScores({
          EmotionType.anxious: 0.8,
          EmotionType.neutral: 0.2,
        });

        final successExperience = SuccessExperience.create(
          uuid: 'success-1',
          userUuid: 'user-1',
          title: '不安を乗り越えた経験',
          description: '以前も不安だったが、乗り越えることができた',
          emotionBefore: 'anxious',
          emotionAfter: 'happy',
          lessonsLearned: '一歩ずつ進めば大丈夫',
        );

        when(mockSuccessExperienceRepository.searchByEmotion(
          'user-1',
          'anxious',
        )).thenAnswer((_) async => [successExperience]);
        when(mockSuccessExperienceRepository
                .getMostReferencedSuccessExperiences('user-1'))
            .thenAnswer((_) async => []);
        when(mockSuccessExperienceRepository.recordReference('success-1'))
            .thenAnswer((_) async => {});

        // When: 成功体験を思い出させる
        final message =
            await service.remindSuccessExperience('user-1', currentEmotion);

        // Then: 励ましメッセージが生成される
        expect(message, isNotNull);
        expect(message, contains('不安を乗り越えた経験'));
        expect(message, contains('一歩ずつ進めば大丈夫'));
        verify(mockSuccessExperienceRepository.recordReference('success-1'))
            .called(1);
      });

      test('ポジティブ感情時はnullを返す', () async {
        // Given: ポジティブな感情状態
        final currentEmotion = Emotion.fromScores({
          EmotionType.happy: 0.9,
          EmotionType.neutral: 0.1,
        });

        // When: 成功体験を思い出させる
        final message =
            await service.remindSuccessExperience('user-1', currentEmotion);

        // Then: nullが返される
        expect(message, isNull);
        verifyNever(mockSuccessExperienceRepository.searchByEmotion(any, any));
      });

      test('関連する成功体験がない場合はnullを返す', () async {
        // Given: 否定的な感情状態だが成功体験がない
        final currentEmotion = Emotion.fromScores({
          EmotionType.sad: 0.7,
          EmotionType.neutral: 0.3,
        });

        when(mockSuccessExperienceRepository.searchByEmotion('user-1', 'sad'))
            .thenAnswer((_) async => []);
        when(mockSuccessExperienceRepository
                .getMostReferencedSuccessExperiences('user-1'))
            .thenAnswer((_) async => []);

        // When: 成功体験を思い出させる
        final message =
            await service.remindSuccessExperience('user-1', currentEmotion);

        // Then: nullが返される
        expect(message, isNull);
      });
    });

    group('recordSuccessFromTask', () {
      test('15分以上のタスクから成功体験を自動記録', () async {
        // Given: 15分以上のタスク
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '重要なプレゼン準備',
          estimatedMinutes: 30,
          description: 'プレゼン資料を完成させた',
        );

        final expectedExperience = SuccessExperience.create(
          uuid: 'success-1',
          userUuid: 'user-1',
          title: '重要なプレゼン準備',
          description: 'プレゼン資料を完成させた',
        );

        when(mockSuccessExperienceRepository.createSuccessExperience(any))
            .thenAnswer((_) async => expectedExperience);

        // When: タスクから成功体験を記録
        final experience = await service.recordSuccessFromTask(
          task,
          'user-1',
          emotionBefore: 'anxious',
          emotionAfter: 'happy',
        );

        // Then: 成功体験が記録される
        expect(experience, isNotNull);
        verify(mockSuccessExperienceRepository.createSuccessExperience(any))
            .called(1);
      });

      test('15分未満のタスクは記録しない', () async {
        // Given: 15分未満のタスク
        final task = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '短いタスク',
          estimatedMinutes: 10,
        );

        // When: タスクから成功体験を記録
        final experience = await service.recordSuccessFromTask(task, 'user-1');

        // Then: nullが返される
        expect(experience, isNull);
        verifyNever(
            mockSuccessExperienceRepository.createSuccessExperience(any));
      });
    });

    group('recordSuccessExperience', () {
      test('手動で成功体験を記録', () async {
        // Given: 成功体験の情報
        final expectedExperience = SuccessExperience.create(
          uuid: 'success-1',
          userUuid: 'user-1',
          title: '大きな挑戦を達成',
          description: '困難なプロジェクトを完了した',
        );

        when(mockSuccessExperienceRepository.createSuccessExperience(any))
            .thenAnswer((_) async => expectedExperience);

        // When: 成功体験を記録
        final experience = await service.recordSuccessExperience(
          userUuid: 'user-1',
          title: '大きな挑戦を達成',
          description: '困難なプロジェクトを完了した',
          emotionBefore: 'anxious',
          emotionAfter: 'happy',
          lessonsLearned: '準備が大切',
          tags: ['プロジェクト', '達成'],
        );

        // Then: 成功体験が記録される
        expect(experience, isNotNull);
        verify(mockSuccessExperienceRepository.createSuccessExperience(any))
            .called(1);
      });
    });

    group('searchSuccessExperiences', () {
      test('タグで成功体験を検索', () async {
        // Given: タグで検索
        final experiences = [
          SuccessExperience.create(
            uuid: 'success-1',
            userUuid: 'user-1',
            title: '成功1',
            description: '説明1',
            tags: 'プロジェクト',
          ),
        ];

        when(mockSuccessExperienceRepository.searchByTag('user-1', 'プロジェクト'))
            .thenAnswer((_) async => experiences);

        // When: 検索
        final results = await service.searchSuccessExperiences(
          'user-1',
          tag: 'プロジェクト',
        );

        // Then: 結果が返される
        expect(results, hasLength(1));
        verify(mockSuccessExperienceRepository.searchByTag('user-1', 'プロジェクト'))
            .called(1);
      });

      test('感情で成功体験を検索', () async {
        // Given: 感情で検索
        final experiences = [
          SuccessExperience.create(
            uuid: 'success-1',
            userUuid: 'user-1',
            title: '成功1',
            description: '説明1',
            emotionBefore: 'anxious',
          ),
        ];

        when(mockSuccessExperienceRepository.searchByEmotion(
                'user-1', 'anxious'))
            .thenAnswer((_) async => experiences);

        // When: 検索
        final results = await service.searchSuccessExperiences(
          'user-1',
          emotion: 'anxious',
        );

        // Then: 結果が返される
        expect(results, hasLength(1));
        verify(mockSuccessExperienceRepository.searchByEmotion(
                'user-1', 'anxious'))
            .called(1);
      });
    });
  });

  // **Feature: act-based-self-management, Property 16: 成功体験の記録と活用**
  // **Validates: Requirements 7.5**
  group('Property-Based Tests: 成功体験の記録と活用', () {
    late MockAIService mockAIService;
    late MockUserContextService mockUserContextService;
    late MockSuccessExperienceRepository mockSuccessExperienceRepository;
    late PersonalizedPraiseService service;

    setUp(() {
      mockAIService = MockAIService();
      mockUserContextService = MockUserContextService();
      mockSuccessExperienceRepository = MockSuccessExperienceRepository();
      service = PersonalizedPraiseService(
        aiService: mockAIService,
        userContextService: mockUserContextService,
        successExperienceRepository: mockSuccessExperienceRepository,
      );
    });

    /// ランダムなタスクを生成
    Task generateRandomTask(Random random) {
      final titles = [
        'レポートを書く',
        'プレゼンを準備する',
        'コードをレビューする',
        'ミーティングに参加する',
        'データを分析する',
        'ドキュメントを更新する',
        'バグを修正する',
        'テストを実行する',
        'デザインを作成する',
        '企画書を作成する',
      ];

      final descriptions = [
        '重要なタスクを完了した',
        '困難を乗り越えた',
        'チームに貢献した',
        '新しいスキルを習得した',
        '目標を達成した',
      ];

      final estimatedMinutes = 5 + random.nextInt(60); // 5-64分

      return Task.create(
        uuid: 'task-${random.nextInt(10000)}',
        userUuid: 'user-${random.nextInt(100)}',
        title: titles[random.nextInt(titles.length)],
        estimatedMinutes: estimatedMinutes,
        description: descriptions[random.nextInt(descriptions.length)],
      );
    }

    /// ランダムな成功体験を生成
    SuccessExperience generateRandomSuccessExperience(
      Random random,
      String userUuid,
    ) {
      final titles = [
        '大きなプロジェクトを完了',
        '困難な課題を解決',
        '新しいスキルを習得',
        'チームをサポート',
        '重要な発表を成功',
      ];

      final descriptions = [
        '不安を感じながらも、一歩ずつ進めて達成できた',
        '最初は難しいと思ったが、諦めずに取り組んだ',
        '周りのサポートを受けながら、目標を達成した',
        '自分の強みを活かして、良い結果を出せた',
        '準備をしっかりして、自信を持って臨めた',
      ];

      final emotions = ['anxious', 'sad', 'tired', 'neutral'];
      final positiveEmotions = ['happy', 'neutral'];

      final tags = ['プロジェクト', '学習', 'チーム', '発表', '達成'];

      return SuccessExperience.create(
        uuid: 'success-${random.nextInt(10000)}',
        userUuid: userUuid,
        title: titles[random.nextInt(titles.length)],
        description: descriptions[random.nextInt(descriptions.length)],
        emotionBefore: emotions[random.nextInt(emotions.length)],
        emotionAfter: positiveEmotions[random.nextInt(positiveEmotions.length)],
        lessonsLearned: random.nextBool() ? '一歩ずつ進めば大丈夫' : null,
        tags: random.nextBool()
            ? tags.sublist(0, 1 + random.nextInt(3)).join(',')
            : null,
      );
    }

    test('プロパティ16: 15分以上のタスクは常に成功体験として記録される', () async {
      final random = Random(42);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: 15分以上のタスク
        final estimatedMinutes = 15 + random.nextInt(60); // 15-74分
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: estimatedMinutes,
          description: '重要なタスク',
        );

        final expectedExperience = SuccessExperience.create(
          uuid: 'success-$i',
          userUuid: 'user-$i',
          title: task.title,
          description: task.description!,
        );

        when(mockSuccessExperienceRepository.createSuccessExperience(any))
            .thenAnswer((_) async => expectedExperience);

        // When: タスクから成功体験を記録
        final experience = await service.recordSuccessFromTask(task, 'user-$i');

        // Then: 要件 7.5 - 成功体験が記録される
        expect(
          experience,
          isNotNull,
          reason: 'Iteration $i: 15分以上のタスクは成功体験として記録されるべき',
        );
        verify(mockSuccessExperienceRepository.createSuccessExperience(any))
            .called(1);

        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: 15分未満のタスクは成功体験として記録されない', () async {
      final random = Random(123);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: 15分未満のタスク
        final estimatedMinutes = 1 + random.nextInt(14); // 1-14分
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: estimatedMinutes,
        );

        // When: タスクから成功体験を記録
        final experience = await service.recordSuccessFromTask(task, 'user-$i');

        // Then: nullが返される
        expect(
          experience,
          isNull,
          reason: 'Iteration $i: 15分未満のタスクは記録されないべき',
        );
        verifyNever(
            mockSuccessExperienceRepository.createSuccessExperience(any));
      }
    });

    test('プロパティ16: 否定的感情時に常に成功体験を思い出させる', () async {
      final random = Random(456);
      const iterations = 100;

      final negativeEmotions = [
        EmotionType.sad,
        EmotionType.anxious,
        EmotionType.angry,
        EmotionType.tired,
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: 否定的な感情状態と関連する成功体験
        final emotionType =
            negativeEmotions[random.nextInt(negativeEmotions.length)];
        final confidence = 0.5 + random.nextDouble() * 0.5; // 0.5-1.0

        final currentEmotion = Emotion.fromScores({
          emotionType: confidence,
          EmotionType.neutral: 1.0 - confidence,
        });

        final userUuid = 'user-$i';
        final successExperience =
            generateRandomSuccessExperience(random, userUuid);

        when(mockSuccessExperienceRepository.searchByEmotion(
          userUuid,
          emotionType.toString().split('.').last,
        )).thenAnswer((_) async => [successExperience]);
        when(mockSuccessExperienceRepository
                .getMostReferencedSuccessExperiences(userUuid))
            .thenAnswer((_) async => []);
        when(mockSuccessExperienceRepository
                .recordReference(successExperience.uuid))
            .thenAnswer((_) async => {});

        // When: 成功体験を思い出させる
        final message =
            await service.remindSuccessExperience(userUuid, currentEmotion);

        // Then: 要件 7.5 - 励ましメッセージが生成される
        expect(
          message,
          isNotNull,
          reason: 'Iteration $i: 否定的感情時はメッセージが生成されるべき',
        );
        expect(
          message,
          isNotEmpty,
          reason: 'Iteration $i: メッセージは空ではない',
        );
        expect(
          message,
          contains(successExperience.title),
          reason: 'Iteration $i: 成功体験のタイトルが含まれる',
        );

        // 参照が記録される
        verify(mockSuccessExperienceRepository
                .recordReference(successExperience.uuid))
            .called(1);

        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: ポジティブ感情時は成功体験を思い出させない', () async {
      final random = Random(789);
      const iterations = 50;

      final positiveEmotions = [
        EmotionType.happy,
        EmotionType.neutral,
      ];

      for (var i = 0; i < iterations; i++) {
        // Given: ポジティブな感情状態
        final emotionType =
            positiveEmotions[random.nextInt(positiveEmotions.length)];
        final confidence = 0.5 + random.nextDouble() * 0.5;

        final currentEmotion = Emotion.fromScores({
          emotionType: confidence,
          EmotionType.neutral: 1.0 - confidence,
        });

        final userUuid = 'user-$i';

        // When: 成功体験を思い出させる
        final message =
            await service.remindSuccessExperience(userUuid, currentEmotion);

        // Then: nullが返される
        expect(
          message,
          isNull,
          reason: 'Iteration $i: ポジティブ感情時はnullが返されるべき',
        );
        verifyNever(mockSuccessExperienceRepository.searchByEmotion(any, any));
      }
    });

    test('プロパティ16: 成功体験の参照回数が正しく記録される', () async {
      final random = Random(101112);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: 否定的な感情状態と成功体験
        final currentEmotion = Emotion.fromScores({
          EmotionType.anxious: 0.8,
          EmotionType.neutral: 0.2,
        });

        final userUuid = 'user-$i';
        final successExperience =
            generateRandomSuccessExperience(random, userUuid);

        when(mockSuccessExperienceRepository.searchByEmotion(
          userUuid,
          'anxious',
        )).thenAnswer((_) async => [successExperience]);
        when(mockSuccessExperienceRepository
                .getMostReferencedSuccessExperiences(userUuid))
            .thenAnswer((_) async => []);
        when(mockSuccessExperienceRepository
                .recordReference(successExperience.uuid))
            .thenAnswer((_) async => {});

        // When: 成功体験を思い出させる
        await service.remindSuccessExperience(userUuid, currentEmotion);

        // Then: 参照が記録される
        verify(mockSuccessExperienceRepository
                .recordReference(successExperience.uuid))
            .called(1);

        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: 手動記録された成功体験は常に保存される', () async {
      final random = Random(131415);
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        // Given: 成功体験の情報
        final userUuid = 'user-$i';
        final title = 'タイトル$i';
        final description = '説明$i';

        final expectedExperience = SuccessExperience.create(
          uuid: 'success-$i',
          userUuid: userUuid,
          title: title,
          description: description,
        );

        when(mockSuccessExperienceRepository.createSuccessExperience(any))
            .thenAnswer((_) async => expectedExperience);

        // When: 手動で成功体験を記録
        final experience = await service.recordSuccessExperience(
          userUuid: userUuid,
          title: title,
          description: description,
          emotionBefore: random.nextBool() ? 'anxious' : null,
          emotionAfter: random.nextBool() ? 'happy' : null,
          lessonsLearned: random.nextBool() ? '学び$i' : null,
          tags: random.nextBool() ? ['タグ1', 'タグ2'] : null,
        );

        // Then: 成功体験が記録される
        expect(
          experience,
          isNotNull,
          reason: 'Iteration $i: 手動記録は常に保存されるべき',
        );
        verify(mockSuccessExperienceRepository.createSuccessExperience(any))
            .called(1);

        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: 賞賛メッセージは過去の成功体験を参照する', () async {
      final random = Random(161718);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        // Given: タスクとユーザーコンテキスト、過去の成功体験
        final task = generateRandomTask(random);
        final userUuid = task.userUuid;

        final context = UserContext(
          userId: userUuid,
          motivationLevel: random.nextDouble(),
          emotionTrend: EmotionTrend(
            isImproving: true,
            isDecreasing: false,
            isStable: false,
            averageScore: 0.7,
          ),
          recentEmotions: [
            Emotion.fromScores({
              EmotionType.happy: 0.8,
              EmotionType.neutral: 0.2,
            }),
          ],
          dialogueHistory: [],
        );

        final successExperiences = List.generate(
          1 + random.nextInt(5),
          (j) => generateRandomSuccessExperience(random, userUuid),
        );

        when(mockUserContextService.getUserContext(userUuid))
            .thenAnswer((_) async => context);
        when(mockSuccessExperienceRepository.getRecentSuccessExperiences(
          userUuid,
          limit: 5,
        )).thenAnswer((_) async => successExperiences);
        when(mockAIService.complete(any)).thenAnswer((_) async => '素晴らしい達成です！');

        // When: 賞賛メッセージを生成
        final message = await service.generatePraiseMessage(task, userUuid);

        // Then: 要件 7.5 - メッセージが生成され、過去の成功体験が参照される
        expect(
          message,
          isNotEmpty,
          reason: 'Iteration $i: 賞賛メッセージが生成されるべき',
        );

        // AIサービスが呼ばれ、成功体験が取得される
        verify(mockAIService.complete(any)).called(1);
        verify(mockSuccessExperienceRepository.getRecentSuccessExperiences(
          userUuid,
          limit: 5,
        )).called(1);

        reset(mockAIService);
        reset(mockUserContextService);
        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: 検索機能は常に正しいフィルタを適用する', () async {
      final random = Random(192021);
      const iterations = 50;

      for (var i = 0; i < iterations; i++) {
        final userUuid = 'user-$i';

        // タグ検索
        if (random.nextBool()) {
          final tag = 'タグ$i';
          final experiences = [
            generateRandomSuccessExperience(random, userUuid),
          ];

          when(mockSuccessExperienceRepository.searchByTag(userUuid, tag))
              .thenAnswer((_) async => experiences);

          final results = await service.searchSuccessExperiences(
            userUuid,
            tag: tag,
          );

          expect(results, isNotEmpty);
          verify(mockSuccessExperienceRepository.searchByTag(userUuid, tag))
              .called(1);
        }
        // 感情検索
        else {
          const emotion = 'anxious';
          final experiences = [
            generateRandomSuccessExperience(random, userUuid),
          ];

          when(mockSuccessExperienceRepository.searchByEmotion(
                  userUuid, emotion))
              .thenAnswer((_) async => experiences);

          final results = await service.searchSuccessExperiences(
            userUuid,
            emotion: emotion,
          );

          expect(results, isNotEmpty);
          verify(mockSuccessExperienceRepository.searchByEmotion(
                  userUuid, emotion))
              .called(1);
        }

        reset(mockSuccessExperienceRepository);
      }
    });

    test('プロパティ16: 境界値での正しい動作', () async {
      // Given: 境界値のテストケース
      final testCases = [
        {'minutes': 14, 'shouldRecord': false},
        {'minutes': 15, 'shouldRecord': true},
        {'minutes': 16, 'shouldRecord': true},
        {'minutes': 1, 'shouldRecord': false},
        {'minutes': 60, 'shouldRecord': true},
      ];

      for (var i = 0; i < testCases.length; i++) {
        final testCase = testCases[i];
        final task = Task.create(
          uuid: 'task-$i',
          userUuid: 'user-$i',
          title: 'タスク$i',
          estimatedMinutes: testCase['minutes'] as int,
          description: '説明',
        );

        final expectedExperience = SuccessExperience.create(
          uuid: 'success-$i',
          userUuid: 'user-$i',
          title: task.title,
          description: task.description!,
        );

        when(mockSuccessExperienceRepository.createSuccessExperience(any))
            .thenAnswer((_) async => expectedExperience);

        // When: タスクから成功体験を記録
        final experience = await service.recordSuccessFromTask(task, 'user-$i');

        // Then: 期待される動作
        if (testCase['shouldRecord'] as bool) {
          expect(
            experience,
            isNotNull,
            reason: 'Case $i: ${testCase['minutes']}分は記録されるべき',
          );
          verify(mockSuccessExperienceRepository.createSuccessExperience(any))
              .called(1);
        } else {
          expect(
            experience,
            isNull,
            reason: 'Case $i: ${testCase['minutes']}分は記録されないべき',
          );
          verifyNever(
              mockSuccessExperienceRepository.createSuccessExperience(any));
        }

        reset(mockSuccessExperienceRepository);
      }
    });
  });
}
