import '../models/journal_entry.dart';
import '../repositories/journal_repository.dart';
import 'encryption_service.dart';

/// 対話エントリ
class DialogueEntry {
  DialogueEntry({
    required this.uuid,
    required this.userUuid,
    required this.userInput,
    required this.aiResponse,
    required this.actProcess,
    this.emotionType,
    this.emotionConfidence,
    required this.createdAt,
  });

  final String uuid;
  final String userUuid;
  final String userInput;
  final String aiResponse;
  final String actProcess;
  final String? emotionType;
  final double? emotionConfidence;
  final DateTime createdAt;

  @override
  String toString() =>
      'DialogueEntry{uuid: $uuid, actProcess: $actProcess, emotion: $emotionType}';
}

/// 個別化コンテキスト
class PersonalizationContext {
  PersonalizationContext({
    required this.userUuid,
    required this.totalDialogues,
    required this.mostFrequentProcess,
    required this.emotionFrequency,
    required this.successExperiences,
    required this.recurringThemes,
    this.lastDialogueAt,
  });

  final String userUuid;
  final int totalDialogues;
  final String mostFrequentProcess;
  final Map<String, int> emotionFrequency;
  final List<String> successExperiences;
  final List<String> recurringThemes;
  final DateTime? lastDialogueAt;

  @override
  String toString() =>
      'PersonalizationContext{totalDialogues: $totalDialogues, mostFrequentProcess: $mostFrequentProcess}';
}

/// 対話履歴管理サービス
class DialogueHistoryService {
  DialogueHistoryService(this._journalRepository, this._encryptionService);

  final JournalRepository _journalRepository;
  final EncryptionService _encryptionService;

  /// 対話エントリを保存
  Future<DialogueEntry> saveDialogue({
    required String uuid,
    required String userUuid,
    required String userInput,
    required String aiResponse,
    required String actProcess,
    String? emotionType,
    double? emotionConfidence,
  }) async {
    // ユーザー入力とAI応答を暗号化
    final encryptedInput = _encryptionService.encrypt(userInput);
    final encryptedResponse = _encryptionService.encrypt(aiResponse);

    // JournalEntryとして保存
    final journalEntry = JournalEntry.create(
      uuid: uuid,
      userUuid: userUuid,
      encryptedContent: encryptedInput,
      encryptedAiResponse: encryptedResponse,
      aiReflection: actProcess,
      emotionDetected:
          emotionType != null ? _parseEmotionType(emotionType) : null,
      emotionConfidence: emotionConfidence,
    );

    await _journalRepository.createEntry(journalEntry);

    return DialogueEntry(
      uuid: uuid,
      userUuid: userUuid,
      userInput: userInput,
      aiResponse: aiResponse,
      actProcess: actProcess,
      emotionType: emotionType,
      emotionConfidence: emotionConfidence,
      createdAt: journalEntry.createdAt,
    );
  }

  /// 対話履歴を取得
  Future<List<DialogueEntry>> getDialogueHistory(
    String userUuid, {
    int limit = 50,
  }) async {
    final entries = await _journalRepository.getEntriesByUser(userUuid);

    // AI応答があるエントリのみをフィルタ
    final dialogueEntries = entries
        .where((e) => e.encryptedAiResponse != null)
        .take(limit)
        .map(_convertToDialogueEntry)
        .toList();

    return dialogueEntries;
  }

  /// 最近の対話を取得
  Future<List<DialogueEntry>> getRecentDialogues(
    String userUuid, {
    int days = 7,
    int limit = 10,
  }) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    final entries = await _journalRepository.getEntriesByDateRange(
      userUuid,
      startDate,
      now,
    );

    final dialogueEntries = entries
        .where((e) => e.encryptedAiResponse != null)
        .take(limit)
        .map(_convertToDialogueEntry)
        .toList();

    return dialogueEntries;
  }

  /// 特定の感情に関連する対話を取得
  Future<List<DialogueEntry>> getDialoguesByEmotion(
    String userUuid,
    String emotionType,
  ) async {
    final emotion = _parseEmotionType(emotionType);
    final entries = await _journalRepository.getEntriesByEmotion(
      userUuid,
      emotion,
    );

    final dialogueEntries = entries
        .where((e) => e.encryptedAiResponse != null)
        .map(_convertToDialogueEntry)
        .toList();

    return dialogueEntries;
  }

  /// 個別化コンテキストを構築
  Future<PersonalizationContext> buildPersonalizationContext(
    String userUuid,
  ) async {
    // 最近の対話を取得
    final recentDialogues = await getRecentDialogues(userUuid, days: 30);

    // 頻繁に使用されるACTプロセスを分析
    final processFrequency = <String, int>{};
    for (final dialogue in recentDialogues) {
      final process = dialogue.actProcess;
      processFrequency[process] = (processFrequency[process] ?? 0) + 1;
    }

    // 最も頻繁なプロセスを取得
    final mostFrequentProcess = processFrequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // 感情パターンを分析
    final emotionFrequency = <String, int>{};
    for (final dialogue in recentDialogues) {
      if (dialogue.emotionType != null) {
        final emotion = dialogue.emotionType!;
        emotionFrequency[emotion] = (emotionFrequency[emotion] ?? 0) + 1;
      }
    }

    // 過去の成功体験を抽出（ポジティブな感情の対話）
    final successExperiences = recentDialogues
        .where((d) =>
            d.emotionType == 'happy' ||
            (d.emotionConfidence != null && d.emotionConfidence! > 0.7))
        .map((d) => d.userInput)
        .take(5)
        .toList();

    // 繰り返されるテーマを抽出（簡易的なキーワード分析）
    final themes = _extractThemes(recentDialogues);

    return PersonalizationContext(
      userUuid: userUuid,
      totalDialogues: recentDialogues.length,
      mostFrequentProcess: mostFrequentProcess,
      emotionFrequency: emotionFrequency,
      successExperiences: successExperiences,
      recurringThemes: themes,
      lastDialogueAt:
          recentDialogues.isNotEmpty ? recentDialogues.first.createdAt : null,
    );
  }

  /// JournalEntryをDialogueEntryに変換
  DialogueEntry _convertToDialogueEntry(JournalEntry entry) {
    final userInput = entry.encryptedContent != null
        ? _journalRepository.decryptContent(entry) ?? ''
        : '';

    final aiResponse = entry.encryptedAiResponse != null
        ? _journalRepository.decryptAiResponse(entry) ?? ''
        : '';

    return DialogueEntry(
      uuid: entry.uuid,
      userUuid: entry.userUuid,
      userInput: userInput,
      aiResponse: aiResponse,
      actProcess: entry.aiReflection ?? '',
      emotionType: entry.emotionDetected?.name,
      emotionConfidence: entry.emotionConfidence,
      createdAt: entry.createdAt,
    );
  }

  /// 感情タイプをパース
  EmotionType _parseEmotionType(String emotionType) {
    switch (emotionType.toLowerCase()) {
      case 'happy':
        return EmotionType.happy;
      case 'sad':
        return EmotionType.sad;
      case 'angry':
        return EmotionType.angry;
      case 'anxious':
        return EmotionType.anxious;
      case 'tired':
        return EmotionType.tired;
      default:
        return EmotionType.neutral;
    }
  }

  /// テーマを抽出（簡易的なキーワード分析）
  List<String> _extractThemes(List<DialogueEntry> dialogues) {
    final keywords = <String, int>{};

    // 日本語の一般的なテーマキーワード
    final themeKeywords = [
      '仕事',
      '家族',
      '友人',
      '健康',
      '勉強',
      '趣味',
      '将来',
      '不安',
      '目標',
      '人間関係'
    ];

    for (final dialogue in dialogues) {
      for (final keyword in themeKeywords) {
        if (dialogue.userInput.contains(keyword)) {
          keywords[keyword] = (keywords[keyword] ?? 0) + 1;
        }
      }
    }

    // 頻度順にソートして上位5つを返す
    final sortedKeywords = keywords.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedKeywords.take(5).map((e) => e.key).toList();
  }
}
