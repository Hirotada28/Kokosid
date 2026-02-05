import '../models/journal_entry.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';
import '../services/local_storage_service.dart';

/// 日記エントリデータリポジトリ
class JournalRepository {
  JournalRepository(this._databaseService, this._encryptionService);
  final DatabaseService _databaseService;
  final EncryptionService _encryptionService;

  /// ストレージサービスを取得
  LocalStorageService get _storage => _databaseService.storage;

  /// 日記エントリを作成
  Future<JournalEntry> createEntry(JournalEntry entry) async {
    await _storage.putJournalEntry(entry);
    return entry;
  }

  /// 暗号化されたコンテンツで日記エントリを作成
  Future<JournalEntry> createEncryptedEntry({
    required String uuid,
    required String userUuid,
    required String content,
    String? audioUrl,
    EmotionType? emotion,
    double? emotionConfidence,
  }) async {
    final encryptedContent = _encryptionService.encrypt(content);

    final entry = JournalEntry.create(
      uuid: uuid,
      userUuid: userUuid,
      encryptedContent: encryptedContent,
      audioUrl: audioUrl,
      emotionDetected: emotion,
      emotionConfidence: emotionConfidence,
    );

    return createEntry(entry);
  }

  /// UUIDで日記エントリを取得
  Future<JournalEntry?> getEntryByUuid(String uuid) async =>
      _storage.getJournalEntryByUuid(uuid);

  /// ユーザーの全日記エントリを取得
  Future<List<JournalEntry>> getEntriesByUser(String userUuid) async =>
      _storage.getJournalEntriesByUserUuid(userUuid);

  /// 今日の日記エントリを取得
  Future<List<JournalEntry>> getTodayEntries(String userUuid) async =>
      _storage.getTodayJournalEntriesByUserUuid(userUuid);

  /// 期間内の日記エントリを取得
  Future<List<JournalEntry>> getEntriesByDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _storage.getJournalEntriesByUserUuidAndDateRange(userUuid, start, end);

  /// 感情別の日記エントリを取得
  Future<List<JournalEntry>> getEntriesByEmotion(
    String userUuid,
    EmotionType emotion,
  ) async {
    final entries = await _storage.getJournalEntriesByUserUuid(userUuid);
    return entries.where((entry) => entry.emotionDetected == emotion).toList();
  }

  /// 日記エントリを更新
  Future<JournalEntry> updateEntry(JournalEntry entry) async {
    await _storage.putJournalEntry(entry);
    return entry;
  }

  /// 日記エントリを削除
  Future<bool> deleteEntry(String uuid) async =>
      _storage.deleteJournalEntryByUuid(uuid);

  /// 暗号化されたコンテンツを復号化
  String? decryptContent(JournalEntry entry) {
    if (entry.encryptedContent == null) {
      return null;
    }

    try {
      return _encryptionService.decrypt(entry.encryptedContent!);
    } on Exception {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// AI応答を復号化
  String? decryptAiResponse(JournalEntry entry) {
    if (entry.encryptedAiResponse == null) {
      return null;
    }

    try {
      return _encryptionService.decrypt(entry.encryptedAiResponse!);
    } on Exception {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// 期間内の感情統計を取得
  Future<Map<EmotionType, int>> getEmotionStatistics(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final entries = await getEntriesByDateRange(userUuid, start, end);
    final statistics = <EmotionType, int>{};

    for (final emotion in EmotionType.values) {
      statistics[emotion] = 0;
    }

    for (final entry in entries) {
      if (entry.emotionDetected != null) {
        statistics[entry.emotionDetected!] =
            (statistics[entry.emotionDetected!] ?? 0) + 1;
      }
    }

    return statistics;
  }

  /// 同期待ちエントリを取得
  Future<List<JournalEntry>> getUnsyncedEntries(String userUuid) async {
    final entries = await _storage.getJournalEntriesByUserUuid(userUuid);
    return entries.where((entry) => entry.syncedAt == null).toList();
  }

  /// エントリを同期済みとしてマーク
  Future<void> markAsSynced(String uuid) async {
    final entry = await getEntryByUuid(uuid);
    if (entry != null) {
      entry.markSynced();
      await updateEntry(entry);
    }
  }
}
