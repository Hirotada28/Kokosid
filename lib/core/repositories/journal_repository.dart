import 'package:isar/isar.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';

/// 日記エントリデータリポジトリ
class JournalRepository {
  JournalRepository(this._databaseService, this._encryptionService);
  final DatabaseService _databaseService;
  final EncryptionService _encryptionService;

  /// 日記エントリを作成
  Future<JournalEntry> createEntry(JournalEntry entry) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.journalEntrys.put(entry);
    });

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
  Future<JournalEntry?> getEntryByUuid(String uuid) async {
    final isar = _databaseService.isar;

    return isar.journalEntrys.filter().uuidEqualTo(uuid).findFirst();
  }

  /// ユーザーの全日記エントリを取得
  Future<List<JournalEntry>> getEntriesByUser(String userUuid) async {
    final isar = _databaseService.isar;

    return isar.journalEntrys
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 今日の日記エントリを取得
  Future<List<JournalEntry>> getTodayEntries(String userUuid) async {
    final isar = _databaseService.isar;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return isar.journalEntrys
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(startOfDay, endOfDay)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 期間内の日記エントリを取得
  Future<List<JournalEntry>> getEntriesByDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final isar = _databaseService.isar;

    return isar.journalEntrys
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(start, end)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 感情別の日記エントリを取得
  Future<List<JournalEntry>> getEntriesByEmotion(
    String userUuid,
    EmotionType emotion,
  ) async {
    final isar = _databaseService.isar;

    return isar.journalEntrys
        .filter()
        .userUuidEqualTo(userUuid)
        .emotionDetectedEqualTo(emotion)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 日記エントリを更新
  Future<JournalEntry> updateEntry(JournalEntry entry) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.journalEntrys.put(entry);
    });

    return entry;
  }

  /// 日記エントリを削除
  Future<bool> deleteEntry(String uuid) async {
    final isar = _databaseService.isar;

    return isar.writeTxn(() async =>
        await isar.journalEntrys.filter().uuidEqualTo(uuid).deleteFirst());
  }

  /// 暗号化されたコンテンツを復号化
  String? decryptContent(JournalEntry entry) {
    if (entry.encryptedContent == null) return null;

    try {
      return _encryptionService.decrypt(entry.encryptedContent!);
    } catch (e) {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// AI応答を復号化
  String? decryptAiResponse(JournalEntry entry) {
    if (entry.encryptedAiResponse == null) return null;

    try {
      return _encryptionService.decrypt(entry.encryptedAiResponse!);
    } catch (e) {
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
    final isar = _databaseService.isar;

    return isar.journalEntrys
        .filter()
        .userUuidEqualTo(userUuid)
        .syncedAtIsNull()
        .findAll();
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
