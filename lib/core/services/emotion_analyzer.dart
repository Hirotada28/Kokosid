import 'dart:io';

import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../repositories/journal_repository.dart';
import 'acoustic_analyzer.dart';
import 'text_emotion_classifier.dart';
import 'whisper_service.dart';

/// 感情分析結果
class EmotionResult {
  EmotionResult({
    required this.primaryEmotion,
    required this.confidence,
    required this.trend,
    required this.transcription,
    this.acousticFeatures,
    this.textEmotion,
  });

  final Emotion primaryEmotion;
  final double confidence;
  final EmotionTrend trend;
  final String transcription;
  final AcousticFeatures? acousticFeatures;
  final TextEmotion? textEmotion;

  @override
  String toString() =>
      'EmotionResult{emotion: $primaryEmotion, confidence: $confidence, trend: $trend}';
}

/// 3層感情分析システム
/// Layer 1: 音響特徴分析（オンデバイス）
/// Layer 2: テキスト変換と言語分析
/// Layer 3: コンテキスト統合分析
class EmotionAnalyzer {
  EmotionAnalyzer({
    required this.acousticAnalyzer,
    required this.whisperService,
    required this.textClassifier,
    required this.journalRepository,
  });

  final AcousticAnalyzer acousticAnalyzer;
  final WhisperService whisperService;
  final TextEmotionClassifier textClassifier;
  final JournalRepository journalRepository;

  /// 音声から多層的な感情分析を実行
  Future<EmotionResult> analyzeAudio(File audioFile, String userUuid) async {
    // Layer 1: 音響特徴分析（オンデバイス）
    final acousticFeatures = await acousticAnalyzer.extractFeatures(audioFile);

    // Layer 2: テキスト変換と言語分析
    final transcription = await whisperService.transcribe(audioFile);
    final textEmotion = await textClassifier.classify(transcription);

    // Layer 3: コンテキスト統合分析
    final history = await _getEmotionHistory(userUuid, days: 7);
    final trend = _analyzeTrend(history);

    // 総合スコア計算（重み付き平均: 音響50%、テキスト50%）
    final combinedEmotion = _combineResults(acousticFeatures, textEmotion);

    return EmotionResult(
      primaryEmotion: combinedEmotion,
      confidence: _calculateConfidence(acousticFeatures, textEmotion),
      trend: trend,
      transcription: transcription,
      acousticFeatures: acousticFeatures,
      textEmotion: textEmotion,
    );
  }

  /// テキストから感情分析を実行（音声なしの場合）
  Future<EmotionResult> analyzeText(String text, String userUuid) async {
    // テキスト分析のみ
    final textEmotion = await textClassifier.classify(text);

    // コンテキスト統合分析
    final history = await _getEmotionHistory(userUuid, days: 7);
    final trend = _analyzeTrend(history);

    // テキストのみの場合は100%の重み
    final emotion = Emotion.fromScores(textEmotion.emotionScores);

    return EmotionResult(
      primaryEmotion: emotion,
      confidence: textEmotion.confidence,
      trend: trend,
      transcription: text,
      textEmotion: textEmotion,
    );
  }

  /// 音響特徴とテキスト感情を統合
  Emotion _combineResults(
    AcousticFeatures acoustic,
    TextEmotion text,
  ) {
    // 音響50%、テキスト50%の重み付き統合
    final combinedScores = <EmotionType, double>{};

    for (final emotion in EmotionType.values) {
      final acousticScore = acoustic.emotionScores[emotion] ?? 0.0;
      final textScore = text.emotionScores[emotion] ?? 0.0;
      combinedScores[emotion] = (acousticScore * 0.5) + (textScore * 0.5);
    }

    return Emotion.fromScores(combinedScores);
  }

  /// 信頼度を計算
  double _calculateConfidence(
    AcousticFeatures acoustic,
    TextEmotion text,
  ) {
    // 音響と テキストの信頼度の平均
    final acousticConfidence =
        acoustic.emotionScores.values.reduce((a, b) => a > b ? a : b);
    final textConfidence = text.confidence;
    return (acousticConfidence + textConfidence) / 2;
  }

  /// 過去の感情履歴を取得
  Future<List<JournalEntry>> _getEmotionHistory(
    String userUuid, {
    required int days,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    return journalRepository.getEntriesByDateRange(
      userUuid,
      startDate,
      DateTime.now(),
    );
  }

  /// 感情トレンドを分析
  EmotionTrend _analyzeTrend(List<JournalEntry> history) {
    if (history.isEmpty) {
      return EmotionTrend(
        isImproving: false,
        isDecreasing: false,
        isStable: true,
        averageScore: 0.5,
      );
    }

    // ポジティブ感情の比率を計算
    final positiveEmotions = [EmotionType.happy, EmotionType.neutral];
    final recentEntries = history.take(3).toList();
    final olderEntries = history.skip(3).take(4).toList();

    final recentPositiveRatio = _calculatePositiveRatio(
      recentEntries,
      positiveEmotions,
    );
    final olderPositiveRatio = _calculatePositiveRatio(
      olderEntries,
      positiveEmotions,
    );

    // トレンドを判定
    final difference = recentPositiveRatio - olderPositiveRatio;
    const threshold = 0.1; // 10%の変化で有意とみなす

    final isImproving = difference > threshold;
    final isDecreasing = difference < -threshold;
    final isStable = !isImproving && !isDecreasing;

    return EmotionTrend(
      isImproving: isImproving,
      isDecreasing: isDecreasing,
      isStable: isStable,
      averageScore: recentPositiveRatio,
    );
  }

  /// ポジティブ感情の比率を計算
  double _calculatePositiveRatio(
    List<JournalEntry> entries,
    List<EmotionType> positiveEmotions,
  ) {
    if (entries.isEmpty) return 0.5;

    final positiveCount = entries
        .where((e) =>
            e.emotionDetected != null &&
            positiveEmotions.contains(e.emotionDetected))
        .length;

    return positiveCount / entries.length;
  }
}
