import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/repositories/journal_repository.dart';
import 'package:kokosid/core/services/acoustic_analyzer.dart';
import 'package:kokosid/core/services/emotion_analyzer.dart';
import 'package:kokosid/core/services/text_emotion_classifier.dart';
import 'package:kokosid/core/services/whisper_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'emotion_analyzer_test.mocks.dart';

@GenerateMocks([
  WhisperService,
  JournalRepository,
  AcousticAnalyzer,
])
void main() {
  group('EmotionAnalyzer - Property Tests', () {
    late EmotionAnalyzer emotionAnalyzer;
    late MockAcousticAnalyzer mockAcousticAnalyzer;
    late MockWhisperService mockWhisperService;
    late TextEmotionClassifier textClassifier;
    late MockJournalRepository mockJournalRepository;

    setUp(() {
      mockAcousticAnalyzer = MockAcousticAnalyzer();
      mockWhisperService = MockWhisperService();
      textClassifier = TextEmotionClassifier();
      mockJournalRepository = MockJournalRepository();

      emotionAnalyzer = EmotionAnalyzer(
        acousticAnalyzer: mockAcousticAnalyzer,
        whisperService: mockWhisperService,
        textClassifier: textClassifier,
        journalRepository: mockJournalRepository,
      );
    });

    /// **Feature: act-based-self-management, Property 4: 3層感情分析の統合処理**
    /// **Validates: Requirements 3.1, 3.3, 3.5**
    ///
    /// 全ての音声入力に対して、システムは音響特徴分析、テキスト分析、
    /// コンテキスト分析の3層を実行し、重み付き統合により総合的な感情スコアを算出する
    test(
      'Property 4: 3層感情分析の統合処理 - 全ての音声入力で3層分析を実行',
      () async {
        // 最小100回の反復実行
        const iterations = 100;
        final random = Random(42); // 再現性のためのシード

        for (var i = 0; i < iterations; i++) {
          // Given: ランダムな音声ファイルとユーザー
          final audioFile = _createMockAudioFile(random);
          final userUuid = 'user-${random.nextInt(1000)}';

          // Mock設定
          final mockAcousticFeatures = _generateMockAcousticFeatures(random);
          when(mockAcousticAnalyzer.extractFeatures(any))
              .thenAnswer((_) async => mockAcousticFeatures);
          when(mockWhisperService.transcribe(any))
              .thenAnswer((_) async => _generateRandomText(random));
          when(mockJournalRepository.getEntriesByDateRange(
            any,
            any,
            any,
          )).thenAnswer((_) async => _generateMockHistory(random));

          // When: 音声分析を実行
          final result = await emotionAnalyzer.analyzeAudio(
            audioFile,
            userUuid,
          );

          // Then: 3層全てが実行されていることを検証

          // Layer 1: 音響特徴分析が実行されている
          expect(result.acousticFeatures, isNotNull,
              reason: 'Layer 1: 音響特徴分析が実行されていない');
          expect(result.acousticFeatures!.emotionScores.length, equals(6),
              reason: '音響分析は6つの感情スコアを返す必要がある');

          // Layer 2: テキスト分析が実行されている
          expect(result.textEmotion, isNotNull,
              reason: 'Layer 2: テキスト分析が実行されていない');
          expect(result.textEmotion!.emotionScores.length, equals(6),
              reason: 'テキスト分析は6つの感情スコアを返す必要がある');
          expect(result.transcription, isNotEmpty, reason: 'テキスト変換結果が空');

          // Layer 3: コンテキスト分析が実行されている
          expect(result.trend, isNotNull, reason: 'Layer 3: コンテキスト分析が実行されていない');

          // 重み付き統合の検証
          expect(result.primaryEmotion, isNotNull, reason: '統合された感情が生成されていない');
          expect(result.confidence, inInclusiveRange(0.0, 1.0),
              reason: '信頼度が0.0-1.0の範囲外');

          // 音響50%、テキスト50%の重み付けを検証
          final acousticScores = result.acousticFeatures!.emotionScores;
          final textScores = result.textEmotion!.emotionScores;
          final primaryEmotion = result.primaryEmotion.type;

          // 統合スコアが正しく計算されているか検証
          final expectedScore = (acousticScores[primaryEmotion]! * 0.5) +
              (textScores[primaryEmotion]! * 0.5);
          final actualScore = result.primaryEmotion.confidence;

          // 許容誤差内で一致することを確認
          expect(
            (actualScore - expectedScore).abs(),
            lessThan(0.01),
            reason: '重み付き統合が正しく計算されていない',
          );
        }
      },
    );

    test(
      'Property 4: 3層感情分析 - テキストのみの入力でも正しく動作',
      () async {
        const iterations = 50;
        final random = Random(43);

        for (var i = 0; i < iterations; i++) {
          // Given: テキスト入力
          final text = _generateRandomText(random);
          final userUuid = 'user-${random.nextInt(1000)}';

          when(mockJournalRepository.getEntriesByDateRange(
            any,
            any,
            any,
          )).thenAnswer((_) async => _generateMockHistory(random));

          // When: テキスト分析を実行
          final result = await emotionAnalyzer.analyzeText(text, userUuid);

          // Then: テキスト分析とコンテキスト分析が実行されている
          expect(result.textEmotion, isNotNull);
          expect(result.trend, isNotNull);
          expect(result.transcription, equals(text));
          expect(result.primaryEmotion, isNotNull);
          expect(result.confidence, inInclusiveRange(0.0, 1.0));

          // 音響分析は実行されていない
          expect(result.acousticFeatures, isNull);
        }
      },
    );

    /// **Feature: act-based-self-management, Property 6: 感情分類の完全性**
    /// **Validates: Requirements 3.3, 3.4**
    ///
    /// 全てのテキスト入力に対して、システムは6つの感情カテゴリ
    /// （喜び、悲しみ、怒り、不安、疲労、中立）のいずれか1つに分類し、
    /// トレンド分析（改善・悪化・安定）を実行する
    test(
      'Property 6: 感情分類の完全性 - 全てのテキスト入力で6つの感情カテゴリに分類',
      () async {
        // 最小100回の反復実行
        const iterations = 100;
        final random = Random(44); // 再現性のためのシード

        for (var i = 0; i < iterations; i++) {
          // Given: ランダムなテキスト入力
          final text = _generateRandomText(random);
          final userUuid = 'user-${random.nextInt(1000)}';

          // Mock設定
          when(mockJournalRepository.getEntriesByDateRange(
            any,
            any,
            any,
          )).thenAnswer((_) async => _generateMockHistory(random));

          // When: テキスト分析を実行
          final result = await emotionAnalyzer.analyzeText(text, userUuid);

          // Then: 6つの感情カテゴリのいずれか1つに分類される
          expect(result.primaryEmotion, isNotNull, reason: '主要感情が特定されていない');
          expect(result.primaryEmotion.type, isIn(EmotionType.values),
              reason: '感情タイプが6つのカテゴリのいずれでもない');

          // 6つの感情カテゴリが全て存在することを確認
          final validEmotions = {
            EmotionType.happy,
            EmotionType.sad,
            EmotionType.angry,
            EmotionType.anxious,
            EmotionType.tired,
            EmotionType.neutral,
          };
          expect(validEmotions.contains(result.primaryEmotion.type), isTrue,
              reason: '感情が6つの定義されたカテゴリに含まれていない');

          // トレンド分析が実行されていることを確認
          expect(result.trend, isNotNull, reason: 'トレンド分析が実行されていない');

          // トレンドは改善・悪化・安定のいずれか1つ
          final trendStates = [
            result.trend.isImproving,
            result.trend.isDecreasing,
            result.trend.isStable,
          ];
          final activeTrendCount = trendStates.where((state) => state).length;
          expect(activeTrendCount, equals(1),
              reason: 'トレンドは改善・悪化・安定のいずれか1つである必要がある');

          // 信頼度が0.0-1.0の範囲内
          expect(result.confidence, inInclusiveRange(0.0, 1.0),
              reason: '信頼度が0.0-1.0の範囲外');

          // テキスト感情分析結果が存在
          expect(result.textEmotion, isNotNull, reason: 'テキスト感情分析結果が存在しない');
          expect(result.textEmotion!.emotionScores.length, equals(6),
              reason: 'テキスト感情スコアは6つの感情全てを含む必要がある');

          // 全ての感情カテゴリのスコアが存在することを確認
          for (final emotion in validEmotions) {
            expect(
                result.textEmotion!.emotionScores.containsKey(emotion), isTrue,
                reason: '感情スコアに$emotionが含まれていない');
            expect(result.textEmotion!.emotionScores[emotion],
                inInclusiveRange(0.0, 1.0),
                reason: '$emotionのスコアが0.0-1.0の範囲外');
          }

          // スコアの合計が1.0に近いことを確認（正規化されている）
          final totalScore = result.textEmotion!.emotionScores.values
              .fold(0.0, (sum, score) => sum + score);
          expect(totalScore, closeTo(1.0, 0.01),
              reason: '感情スコアの合計が1.0に正規化されていない');
        }
      },
    );

    test(
      'Property 6: 感情分類の完全性 - トレンド分析の3状態検証',
      () async {
        const iterations = 50;
        final random = Random(45);

        for (var i = 0; i < iterations; i++) {
          // Given: 異なる感情履歴パターン
          final text = _generateRandomText(random);
          final userUuid = 'user-${random.nextInt(1000)}';

          // 改善・悪化・安定の各パターンを生成
          final historyPattern = i % 3;
          List<JournalEntry> history;

          if (historyPattern == 0) {
            // 改善パターン: 最近がポジティブ
            history = _generateImprovingHistory(userUuid, random);
          } else if (historyPattern == 1) {
            // 悪化パターン: 最近がネガティブ
            history = _generateDecreasingHistory(userUuid, random);
          } else {
            // 安定パターン: 変化なし
            history = _generateStableHistory(userUuid, random);
          }

          when(mockJournalRepository.getEntriesByDateRange(
            any,
            any,
            any,
          )).thenAnswer((_) async => history);

          // When: テキスト分析を実行
          final result = await emotionAnalyzer.analyzeText(text, userUuid);

          // Then: トレンドが正しく判定される
          expect(result.trend, isNotNull);

          // 改善・悪化・安定のいずれか1つのみがtrueであることを確認
          final trendStates = [
            result.trend.isImproving,
            result.trend.isDecreasing,
            result.trend.isStable,
          ];
          final activeTrendCount = trendStates.where((state) => state).length;
          expect(activeTrendCount, equals(1),
              reason: 'トレンドは改善・悪化・安定のいずれか1つである必要がある (iteration $i)');

          // 平均スコアが0.0-1.0の範囲内
          expect(result.trend.averageScore, inInclusiveRange(0.0, 1.0),
              reason: 'トレンドの平均スコアが0.0-1.0の範囲外');
        }
      },
    );

    test(
      'Property 6: 感情分類の完全性 - 空のテキストでも分類可能',
      () async {
        // Given: 空または非常に短いテキスト
        final edgeCases = ['', ' ', '。', 'あ', '!', '...'];
        final userUuid = 'user-test';

        when(mockJournalRepository.getEntriesByDateRange(
          any,
          any,
          any,
        )).thenAnswer((_) async => []);

        for (final text in edgeCases) {
          // When: テキスト分析を実行
          final result = await emotionAnalyzer.analyzeText(text, userUuid);

          // Then: 6つの感情カテゴリのいずれかに分類される
          expect(result.primaryEmotion, isNotNull,
              reason: 'エッジケース "$text" で主要感情が特定されていない');
          expect(result.primaryEmotion.type, isIn(EmotionType.values),
              reason: 'エッジケース "$text" で感情タイプが無効');

          // トレンド分析が実行される
          expect(result.trend, isNotNull,
              reason: 'エッジケース "$text" でトレンド分析が実行されていない');

          // デフォルトで安定状態になる（履歴が空のため）
          expect(result.trend.isStable, isTrue,
              reason: 'エッジケース "$text" で履歴が空の場合は安定状態であるべき');
        }
      },
    );
  });
}

// ヘルパー関数

File _createMockAudioFile(Random random) {
  // テスト用のモックファイルを作成
  // 実際のファイルは作成せず、パスのみを返す
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final size = 10000 + random.nextInt(90000); // 10KB-100KB
  return File('/tmp/test_audio_${timestamp}_$size.m4a');
}

String _generateRandomText(Random random) {
  final texts = [
    '今日はとても嬉しいことがありました',
    '少し疲れているけど頑張ります',
    '不安な気持ちがあります',
    '怒りを感じています',
    '悲しい出来事がありました',
    '特に何も感じていません',
    '楽しい一日でした',
    'ストレスが溜まっています',
  ];
  return texts[random.nextInt(texts.length)];
}

List<JournalEntry> _generateMockHistory(Random random) {
  final count = random.nextInt(10);
  final entries = <JournalEntry>[];

  for (var i = 0; i < count; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-$i',
      userUuid: 'user-test',
    );
    entry.emotionDetected = EmotionType.values[random.nextInt(6)];
    entry.emotionConfidence = random.nextDouble();
    entries.add(entry);
  }

  return entries;
}

AcousticFeatures _generateMockAcousticFeatures(Random random) {
  // ランダムな音響特徴を生成
  final emotionScores = <EmotionType, double>{};
  var total = 0.0;

  // ランダムなスコアを生成
  for (final emotion in EmotionType.values) {
    final score = random.nextDouble();
    emotionScores[emotion] = score;
    total += score;
  }

  // 正規化（合計が1.0になるように）
  for (final emotion in EmotionType.values) {
    emotionScores[emotion] = emotionScores[emotion]! / total;
  }

  return AcousticFeatures(
    averagePitch: 150.0 + random.nextDouble() * 100,
    pitchVariance: 10.0 + random.nextDouble() * 30,
    speakingRate: 120.0 + random.nextDouble() * 60,
    averageVolume: -30.0 + random.nextDouble() * 20,
    volumeVariance: 2.0 + random.nextDouble() * 8,
    emotionScores: emotionScores,
  );
}

/// 改善パターンの履歴を生成（最近がポジティブ）
List<JournalEntry> _generateImprovingHistory(String userUuid, Random random) {
  final entries = <JournalEntry>[];
  final now = DateTime.now();

  // 最近3日間: ポジティブ感情が多い
  for (var i = 0; i < 3; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-recent-$i',
      userUuid: userUuid,
    );
    entry.createdAt = now.subtract(Duration(days: i));
    // 80%の確率でポジティブ
    entry.emotionDetected = random.nextDouble() < 0.8
        ? (random.nextBool() ? EmotionType.happy : EmotionType.neutral)
        : EmotionType.sad;
    entry.emotionConfidence = 0.7 + random.nextDouble() * 0.3;
    entries.add(entry);
  }

  // 過去4日間: ネガティブ感情が多い
  for (var i = 3; i < 7; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-old-$i',
      userUuid: userUuid,
    );
    entry.createdAt = now.subtract(Duration(days: i));
    // 70%の確率でネガティブ
    entry.emotionDetected = random.nextDouble() < 0.7
        ? [
            EmotionType.sad,
            EmotionType.anxious,
            EmotionType.tired
          ][random.nextInt(3)]
        : EmotionType.neutral;
    entry.emotionConfidence = 0.6 + random.nextDouble() * 0.3;
    entries.add(entry);
  }

  return entries;
}

/// 悪化パターンの履歴を生成（最近がネガティブ）
List<JournalEntry> _generateDecreasingHistory(String userUuid, Random random) {
  final entries = <JournalEntry>[];
  final now = DateTime.now();

  // 最近3日間: ネガティブ感情が多い
  for (var i = 0; i < 3; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-recent-$i',
      userUuid: userUuid,
    );
    entry.createdAt = now.subtract(Duration(days: i));
    // 80%の確率でネガティブ
    entry.emotionDetected = random.nextDouble() < 0.8
        ? [
            EmotionType.sad,
            EmotionType.anxious,
            EmotionType.tired
          ][random.nextInt(3)]
        : EmotionType.neutral;
    entry.emotionConfidence = 0.7 + random.nextDouble() * 0.3;
    entries.add(entry);
  }

  // 過去4日間: ポジティブ感情が多い
  for (var i = 3; i < 7; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-old-$i',
      userUuid: userUuid,
    );
    entry.createdAt = now.subtract(Duration(days: i));
    // 70%の確率でポジティブ
    entry.emotionDetected = random.nextDouble() < 0.7
        ? (random.nextBool() ? EmotionType.happy : EmotionType.neutral)
        : EmotionType.sad;
    entry.emotionConfidence = 0.6 + random.nextDouble() * 0.3;
    entries.add(entry);
  }

  return entries;
}

/// 安定パターンの履歴を生成（変化なし）
List<JournalEntry> _generateStableHistory(String userUuid, Random random) {
  final entries = <JournalEntry>[];
  final now = DateTime.now();

  // 全期間: 同じような感情分布
  for (var i = 0; i < 7; i++) {
    final entry = JournalEntry.create(
      uuid: 'entry-$i',
      userUuid: userUuid,
    );
    entry.createdAt = now.subtract(Duration(days: i));
    // 均等な分布
    entry.emotionDetected = EmotionType.values[random.nextInt(6)];
    entry.emotionConfidence = 0.5 + random.nextDouble() * 0.3;
    entries.add(entry);
  }

  return entries;
}
