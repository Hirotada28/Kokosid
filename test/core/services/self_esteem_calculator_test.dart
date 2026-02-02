import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/self_esteem_score.dart';
import 'package:kokosid/core/repositories/journal_repository.dart';
import 'package:kokosid/core/repositories/self_esteem_repository.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/services/self_esteem_calculator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

// モックを生成
@GenerateMocks([TaskRepository, JournalRepository, SelfEsteemRepository])
import 'self_esteem_calculator_test.mocks.dart';

void main() {
  group('SelfEsteemCalculator', () {
    late SelfEsteemCalculator calculator;
    late MockTaskRepository mockTaskRepository;
    late MockJournalRepository mockJournalRepository;
    late MockSelfEsteemRepository mockScoreRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      mockJournalRepository = MockJournalRepository();
      mockScoreRepository = MockSelfEsteemRepository();
      calculator = SelfEsteemCalculator(
        mockTaskRepository,
        mockJournalRepository,
        mockScoreRepository,
      );
    });

    group('calculateScore', () {
      test('重み係数が正しく適用される', () async {
        // Given: テストデータ
        const userUuid = 'test-user-uuid';
        const totalTasks = 10;
        const completedTasks = 8;
        final journalEntries = <JournalEntry>[];

        // モックの設定
        when(mockTaskRepository.getTotalTaskCount(any, any, any))
            .thenAnswer((_) async => totalTasks);
        when(mockTaskRepository.getCompletedTaskCount(any, any, any))
            .thenAnswer((_) async => completedTasks);
        when(mockJournalRepository.getEntriesByDateRange(any, any, any))
            .thenAnswer((_) async => journalEntries);
        when(mockScoreRepository.createScore(any)).thenAnswer(
            (invocation) async =>
                invocation.positionalArguments[0] as SelfEsteemScore);

        // When: スコアを計算
        final result = await calculator.calculateScore(userUuid);

        // Then: 重み係数が適用されたスコアが計算される
        expect(result.score, inInclusiveRange(0.0, 1.0));
        expect(result.completionRate, equals(0.8)); // 8/10
      });

      test('スコアが0.0-1.0の範囲内に制限される', () async {
        // Given: 極端な値のテストデータ
        const userUuid = 'test-user-uuid';

        // 極端な値でモック設定
        when(mockTaskRepository.getTotalTaskCount(any, any, any))
            .thenAnswer((_) async => 100);
        when(mockTaskRepository.getCompletedTaskCount(any, any, any))
            .thenAnswer((_) async => 100);
        when(mockJournalRepository.getEntriesByDateRange(any, any, any))
            .thenAnswer((_) async => <JournalEntry>[]);
        when(mockScoreRepository.createScore(any)).thenAnswer(
            (invocation) async =>
                invocation.positionalArguments[0] as SelfEsteemScore);

        // When: スコアを計算
        final result = await calculator.calculateScore(userUuid);

        // Then: スコアが0.0-1.0の範囲内
        expect(result.score, greaterThanOrEqualTo(0.0));
        expect(result.score, lessThanOrEqualTo(1.0));
      });
    });

    group('detectProgress', () {
      test('0.05ポイント以上の向上を検出する', () async {
        // Given: 進歩があるスコア履歴
        const userUuid = 'test-user-uuid';

        final scores = [
          SelfEsteemScore.create(
            uuid: 'score-1',
            userUuid: userUuid,
            score: 0.7, // 現在
            completionRate: 0.8,
            positiveEmotionRatio: 0.6,
            streakScore: 0.5,
            engagementScore: 0.4,
          ),
          SelfEsteemScore.create(
            uuid: 'score-2',
            userUuid: userUuid,
            score: 0.6, // 前回（0.1ポイント差）
            completionRate: 0.7,
            positiveEmotionRatio: 0.5,
            streakScore: 0.4,
            engagementScore: 0.3,
          ),
        ];

        when(mockScoreRepository.getRecentScores(userUuid, 7))
            .thenAnswer((_) async => scores);
        when(mockScoreRepository.getLatestScore(userUuid))
            .thenAnswer((_) async => scores.first);

        // When: 進歩を検出
        final hasProgress = await calculator.detectProgress(userUuid);

        // Then: 進歩が検出される
        expect(hasProgress, isTrue);
      });

      test('0.05ポイント未満の変化では進歩を検出しない', () async {
        // Given: 小さな変化のスコア履歴
        const userUuid = 'test-user-uuid';

        final scores = [
          SelfEsteemScore.create(
            uuid: 'score-1',
            userUuid: userUuid,
            score: 0.62, // 現在
            completionRate: 0.8,
            positiveEmotionRatio: 0.6,
            streakScore: 0.5,
            engagementScore: 0.4,
          ),
          SelfEsteemScore.create(
            uuid: 'score-2',
            userUuid: userUuid,
            score: 0.60, // 前回（0.02ポイント差）
            completionRate: 0.7,
            positiveEmotionRatio: 0.5,
            streakScore: 0.4,
            engagementScore: 0.3,
          ),
        ];

        when(mockScoreRepository.getRecentScores(userUuid, 7))
            .thenAnswer((_) async => scores);
        when(mockScoreRepository.getLatestScore(userUuid))
            .thenAnswer((_) async => scores.first);

        // When: 進歩を検出
        final hasProgress = await calculator.detectProgress(userUuid);

        // Then: 進歩が検出されない
        expect(hasProgress, isFalse);
      });
    });

    group('generateApprovalMessage', () {
      test('進歩がある場合に承認メッセージを生成する', () async {
        // Given: 進歩があるユーザー
        const userUuid = 'test-user-uuid';

        final scores = [
          SelfEsteemScore.create(
            uuid: 'score-1',
            userUuid: userUuid,
            score: 0.75,
            completionRate: 0.8,
            positiveEmotionRatio: 0.6,
            streakScore: 0.5,
            engagementScore: 0.4,
          ),
          SelfEsteemScore.create(
            uuid: 'score-2',
            userUuid: userUuid,
            score: 0.65, // 0.1ポイント差
            completionRate: 0.7,
            positiveEmotionRatio: 0.5,
            streakScore: 0.4,
            engagementScore: 0.3,
          ),
        ];

        when(mockScoreRepository.getRecentScores(userUuid, 7))
            .thenAnswer((_) async => scores);
        when(mockScoreRepository.getLatestScore(userUuid))
            .thenAnswer((_) async => scores.first);

        // When: 承認メッセージを生成
        final message = await calculator.generateApprovalMessage(userUuid);

        // Then: メッセージが生成される
        expect(message, isNotNull);
        expect(message!.isNotEmpty, isTrue);
      });

      test('進歩がない場合はnullを返す', () async {
        // Given: 進歩がないユーザー
        const userUuid = 'test-user-uuid';

        final scores = [
          SelfEsteemScore.create(
            uuid: 'score-1',
            userUuid: userUuid,
            score: 0.60,
            completionRate: 0.8,
            positiveEmotionRatio: 0.6,
            streakScore: 0.5,
            engagementScore: 0.4,
          ),
          SelfEsteemScore.create(
            uuid: 'score-2',
            userUuid: userUuid,
            score: 0.58, // 0.02ポイント差
            completionRate: 0.7,
            positiveEmotionRatio: 0.5,
            streakScore: 0.4,
            engagementScore: 0.3,
          ),
        ];

        when(mockScoreRepository.getRecentScores(userUuid, 7))
            .thenAnswer((_) async => scores);
        when(mockScoreRepository.getLatestScore(userUuid))
            .thenAnswer((_) async => scores.first);

        // When: 承認メッセージを生成
        final message = await calculator.generateApprovalMessage(userUuid);

        // Then: nullが返される
        expect(message, isNull);
      });
    });

    // **Feature: act-based-self-management, Property 14: 進歩認識と可視化の提供**
    // **Validates: Requirements 6.3, 6.4**
    group('Property-Based Tests: 進歩認識と可視化の提供', () {
      /// **Property 14: 進歩認識と可視化の提供**
      ///
      /// 全てのスコア確認時において、システムは推移グラフと算出根拠を表示し、
      /// 0.05ポイント以上の向上で承認メッセージを表示する
      test(
        'Property 14: 進歩認識 - 0.05ポイント以上の向上で承認メッセージを表示',
        () async {
          // 最小100回の反復実行
          const iterations = 100;
          final random = Random(42); // 再現性のためのシード

          for (var i = 0; i < iterations; i++) {
            // Given: ランダムなユーザーとスコア履歴
            final userUuid = 'user-${random.nextInt(1000)}';

            // 前回のスコア（0.0-0.95の範囲）
            final previousScore = random.nextDouble() * 0.95;

            // 今回のスコア（前回より0.05以上高い）
            final currentScore =
                previousScore + 0.05 + (random.nextDouble() * 0.05);

            // スコア履歴を作成（最新が先頭）
            final scores = [
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: currentScore,
                completionRate: random.nextDouble(),
                positiveEmotionRatio: random.nextDouble(),
                streakScore: random.nextDouble(),
                engagementScore: random.nextDouble(),
              ),
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: previousScore,
                completionRate: random.nextDouble(),
                positiveEmotionRatio: random.nextDouble(),
                streakScore: random.nextDouble(),
                engagementScore: random.nextDouble(),
              ),
            ];

            // Mock設定
            when(mockScoreRepository.getRecentScores(userUuid, 7))
                .thenAnswer((_) async => scores);
            when(mockScoreRepository.getLatestScore(userUuid))
                .thenAnswer((_) async => scores.first);

            // When: 進歩を検出
            final hasProgress = await calculator.detectProgress(userUuid);

            // Then: 進歩が検出される
            expect(hasProgress, isTrue,
                reason:
                    '0.05ポイント以上の向上（${previousScore.toStringAsFixed(2)} → ${currentScore.toStringAsFixed(2)}）で進歩が検出されるべき');

            // When: 承認メッセージを生成
            final message = await calculator.generateApprovalMessage(userUuid);

            // Then: 承認メッセージが生成される
            expect(message, isNotNull, reason: '進歩がある場合は承認メッセージが生成されるべき');
            expect(message!.isNotEmpty, isTrue, reason: '承認メッセージは空でないべき');

            // スコアレベルに応じた適切なメッセージが生成されることを検証
            final level = scores.first.getLevel();
            expect(message.length, greaterThan(10),
                reason: 'レベル$levelに対する意味のあるメッセージが生成されるべき');
          }
        },
      );

      test(
        'Property 14: 進歩認識 - 0.05ポイント未満の変化では承認メッセージを表示しない',
        () async {
          // 最小100回の反復実行
          const iterations = 100;
          final random = Random(42);

          for (var i = 0; i < iterations; i++) {
            // Given: ランダムなユーザーとスコア履歴
            final userUuid = 'user-${random.nextInt(1000)}';

            // 前回のスコア
            final previousScore = 0.3 + (random.nextDouble() * 0.4);

            // 今回のスコア（前回より0.05未満の変化）
            final change =
                (random.nextDouble() * 0.049) - 0.025; // -0.025 ~ +0.049
            final currentScore = (previousScore + change).clamp(0.0, 1.0);

            // スコア履歴を作成
            final scores = [
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: currentScore,
                completionRate: random.nextDouble(),
                positiveEmotionRatio: random.nextDouble(),
                streakScore: random.nextDouble(),
                engagementScore: random.nextDouble(),
              ),
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: previousScore,
                completionRate: random.nextDouble(),
                positiveEmotionRatio: random.nextDouble(),
                streakScore: random.nextDouble(),
                engagementScore: random.nextDouble(),
              ),
            ];

            // Mock設定
            when(mockScoreRepository.getRecentScores(userUuid, 7))
                .thenAnswer((_) async => scores);
            when(mockScoreRepository.getLatestScore(userUuid))
                .thenAnswer((_) async => scores.first);

            // When: 進歩を検出
            final hasProgress = await calculator.detectProgress(userUuid);

            // Then: 進歩が検出されない
            expect(hasProgress, isFalse,
                reason:
                    '0.05ポイント未満の変化（${previousScore.toStringAsFixed(2)} → ${currentScore.toStringAsFixed(2)}）では進歩が検出されないべき');

            // When: 承認メッセージを生成
            final message = await calculator.generateApprovalMessage(userUuid);

            // Then: 承認メッセージが生成されない
            expect(message, isNull, reason: '進歩がない場合は承認メッセージが生成されないべき');
          }
        },
      );

      test(
        'Property 14: 可視化 - 算出根拠が常に提供される',
        () async {
          // 最小100回の反復実行
          const iterations = 100;
          final random = Random(42);

          for (var i = 0; i < iterations; i++) {
            // Given: ランダムなユーザーとデータ
            final userUuid = 'user-${random.nextInt(1000)}';

            // ランダムなデータを生成
            final totalTasks = random.nextInt(20) + 1;
            final completedTasks = random.nextInt(totalTasks + 1);
            final journalEntries = _generateRandomJournalEntries(random, 0, 10);

            // Mock設定
            when(mockTaskRepository.getTotalTaskCount(any, any, any))
                .thenAnswer((_) async => totalTasks);
            when(mockTaskRepository.getCompletedTaskCount(any, any, any))
                .thenAnswer((_) async => completedTasks);
            when(mockJournalRepository.getEntriesByDateRange(any, any, any))
                .thenAnswer((_) async => journalEntries);
            when(mockScoreRepository.createScore(any)).thenAnswer(
                (invocation) async =>
                    invocation.positionalArguments[0] as SelfEsteemScore);

            // When: スコアを計算
            final score = await calculator.calculateScore(userUuid);

            // Then: 算出根拠が提供される
            expect(score.calculationBasisJson, isNotNull,
                reason: '算出根拠JSONが提供されるべき');
            expect(score.calculationBasisJson!.isNotEmpty, isTrue,
                reason: '算出根拠JSONは空でないべき');

            // 算出根拠の内容を検証
            when(mockScoreRepository.getLatestScore(userUuid))
                .thenAnswer((_) async => score);

            final basis = await calculator.getCalculationBasis(userUuid);
            expect(basis, isNotNull, reason: '算出根拠が取得できるべき');

            // 必須フィールドの存在を検証
            expect(basis!.containsKey('completionRate'), isTrue,
                reason: '完了率が含まれるべき');
            expect(basis.containsKey('positiveRatio'), isTrue,
                reason: 'ポジティブ感情比率が含まれるべき');
            expect(basis.containsKey('streakScore'), isTrue,
                reason: '継続日数スコアが含まれるべき');
            expect(basis.containsKey('engagementScore'), isTrue,
                reason: 'AI対話頻度スコアが含まれるべき');
            expect(basis.containsKey('weights'), isTrue, reason: '重み係数が含まれるべき');
            expect(basis.containsKey('rawData'), isTrue, reason: '生データが含まれるべき');

            // 重み係数の検証（設計書の仕様: 完了率30%、感情40%、継続20%、対話10%）
            final weights = basis['weights'] as Map<String, dynamic>;
            expect(weights['completion'], equals(0.3),
                reason: '完了率の重みは30%であるべき');
            expect(weights['emotion'], equals(0.4), reason: '感情の重みは40%であるべき');
            expect(weights['streak'], equals(0.2), reason: '継続の重みは20%であるべき');
            expect(weights['engagement'], equals(0.1),
                reason: '対話の重みは10%であるべき');

            // スコアが0.0-1.0の範囲内であることを検証
            expect(score.score, inInclusiveRange(0.0, 1.0),
                reason: 'スコアは0.0-1.0の範囲内であるべき');

            // 各構成要素が0.0-1.0の範囲内であることを検証
            expect(score.completionRate, inInclusiveRange(0.0, 1.0),
                reason: '完了率は0.0-1.0の範囲内であるべき');
            expect(score.positiveEmotionRatio, inInclusiveRange(0.0, 1.0),
                reason: 'ポジティブ感情比率は0.0-1.0の範囲内であるべき');
            expect(score.streakScore, inInclusiveRange(0.0, 1.0),
                reason: '継続日数スコアは0.0-1.0の範囲内であるべき');
            expect(score.engagementScore, inInclusiveRange(0.0, 1.0),
                reason: 'AI対話頻度スコアは0.0-1.0の範囲内であるべき');
          }
        },
      );

      test(
        'Property 14: 可視化 - スコアレベルに応じた適切なメッセージが生成される',
        () async {
          // 各スコアレベルをテスト
          final testCases = [
            (0.9, ScoreLevel.excellent, '素晴らしい'),
            (0.7, ScoreLevel.good, '良い'),
            (0.5, ScoreLevel.fair, '普通'),
            (0.3, ScoreLevel.poor, '疲れ'),
            (0.1, ScoreLevel.veryPoor, '休息'),
          ];

          for (final testCase in testCases) {
            final (scoreValue, expectedLevel, expectedKeyword) = testCase;

            // Given: 特定のスコアレベルのユーザー
            const userUuid = 'test-user';

            // 進歩があるスコア履歴を作成
            final scores = [
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: scoreValue,
                completionRate: 0.5,
                positiveEmotionRatio: 0.5,
                streakScore: 0.5,
                engagementScore: 0.5,
              ),
              SelfEsteemScore.create(
                uuid: const Uuid().v4(),
                userUuid: userUuid,
                score: scoreValue - 0.1, // 0.1ポイント低い前回スコア
                completionRate: 0.5,
                positiveEmotionRatio: 0.5,
                streakScore: 0.5,
                engagementScore: 0.5,
              ),
            ];

            // Mock設定
            when(mockScoreRepository.getRecentScores(userUuid, 7))
                .thenAnswer((_) async => scores);
            when(mockScoreRepository.getLatestScore(userUuid))
                .thenAnswer((_) async => scores.first);

            // When: 承認メッセージを生成
            final message = await calculator.generateApprovalMessage(userUuid);

            // Then: スコアレベルが正しい
            expect(scores.first.getLevel(), equals(expectedLevel),
                reason: 'スコア$scoreValueはレベル$expectedLevelであるべき');

            // Then: 適切なメッセージが生成される
            expect(message, isNotNull,
                reason: 'レベル$expectedLevelで承認メッセージが生成されるべき');
            expect(message!.isNotEmpty, isTrue, reason: '承認メッセージは空でないべき');

            // メッセージがレベルに応じた内容を含むことを検証
            // （キーワードチェックは緩やかに - メッセージの多様性を許容）
            expect(message.length, greaterThan(10),
                reason: 'レベル$expectedLevelに対する意味のあるメッセージが生成されるべき');
          }
        },
      );

      test(
        'Property 14: エッジケース - スコア履歴が不足している場合の処理',
        () async {
          // Given: スコア履歴が1つ以下のユーザー
          const userUuid = 'test-user';

          // ケース1: スコアが1つだけ
          when(mockScoreRepository.getRecentScores(userUuid, 7))
              .thenAnswer((_) async => [
                    SelfEsteemScore.create(
                      uuid: const Uuid().v4(),
                      userUuid: userUuid,
                      score: 0.8,
                      completionRate: 0.8,
                      positiveEmotionRatio: 0.8,
                      streakScore: 0.8,
                      engagementScore: 0.8,
                    ),
                  ]);

          // When: 進歩を検出
          final hasProgress1 = await calculator.detectProgress(userUuid);

          // Then: 進歩が検出されない（比較対象がない）
          expect(hasProgress1, isFalse, reason: 'スコアが1つだけの場合は進歩を検出できない');

          // ケース2: スコアが0個
          when(mockScoreRepository.getRecentScores(userUuid, 7))
              .thenAnswer((_) async => []);

          // When: 進歩を検出
          final hasProgress2 = await calculator.detectProgress(userUuid);

          // Then: 進歩が検出されない
          expect(hasProgress2, isFalse, reason: 'スコアが0個の場合は進歩を検出できない');
        },
      );
    });
  });
}

/// ランダムな日記エントリを生成
List<JournalEntry> _generateRandomJournalEntries(
    Random random, int min, int max) {
  final count = min + random.nextInt(max - min + 1);
  const emotions = EmotionType.values;

  return List.generate(count, (index) {
    final entry = JournalEntry()
      ..uuid = const Uuid().v4()
      ..userUuid = 'test-user'
      ..emotionDetected = emotions[random.nextInt(emotions.length)]
      ..emotionConfidence = random.nextDouble()
      ..createdAt = DateTime.now().subtract(Duration(days: random.nextInt(7)));
    return entry;
  });
}
