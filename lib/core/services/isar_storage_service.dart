import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/success_experience.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'local_storage_service.dart';

/// Isar を使用したネイティブプラットフォーム向けストレージ実装
/// Android、iOS、Windows、macOS、Linux で使用
class IsarStorageService implements LocalStorageService {
  static Isar? _isar;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [
          UserSchema,
          TaskSchema,
          JournalEntrySchema,
          SelfEsteemScoreSchema,
          SuccessExperienceSchema,
        ],
        directory: dir.path,
        name: 'kokosid_db',
      );

      _isInitialized = true;
    } catch (e) {
      throw StorageException('Isarデータベースの初期化に失敗しました: $e');
    }
  }

  Isar get _db {
    if (!_isInitialized || _isar == null) {
      throw const StorageException('Isarデータベースが初期化されていません');
    }
    return _isar!;
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
      _isInitialized = false;
    }
  }

  @override
  Future<void> clearAllData() async {
    if (!_isInitialized) return;
    await _db.writeTxn(() async {
      await _db.clear();
    });
  }

  @override
  Future<void> clearUserData(String userUuid) async {
    if (!_isInitialized) return;

    await _db.writeTxn(() async {
      await _db.tasks.filter().userUuidEqualTo(userUuid).deleteAll();
      await _db.journalEntrys.filter().userUuidEqualTo(userUuid).deleteAll();
      await _db.selfEsteemScores.filter().userUuidEqualTo(userUuid).deleteAll();
      await _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .deleteAll();
      await _db.users.filter().uuidEqualTo(userUuid).deleteFirst();
    });
  }

  @override
  Future<int> getDatabaseSize() async {
    if (!_isInitialized) return 0;

    final userCount = await _db.users.count();
    final taskCount = await _db.tasks.count();
    final journalCount = await _db.journalEntrys.count();
    final scoreCount = await _db.selfEsteemScores.count();

    return userCount + taskCount + journalCount + scoreCount;
  }

  // =====================
  // User操作
  // =====================

  @override
  Future<User> putUser(User user) async {
    await _db.writeTxn(() async {
      await _db.users.put(user);
    });
    return user;
  }

  @override
  Future<User?> getUserByUuid(String uuid) async =>
      _db.users.filter().uuidEqualTo(uuid).findFirst();

  @override
  Future<List<User>> getAllUsers() async => _db.users.where().findAll();

  @override
  Future<User?> getFirstUser() async => _db.users.where().findFirst();

  @override
  Future<bool> deleteUserByUuid(String uuid) async => _db
      .writeTxn(() async => _db.users.filter().uuidEqualTo(uuid).deleteFirst());

  // =====================
  // Task操作
  // =====================

  @override
  Future<Task> putTask(Task task) async {
    await _db.writeTxn(() async {
      await _db.tasks.put(task);
    });
    return task;
  }

  @override
  Future<Task?> getTaskByUuid(String uuid) async =>
      _db.tasks.filter().uuidEqualTo(uuid).findFirst();

  @override
  Future<List<Task>> getTasksByUserUuid(String userUuid) async =>
      _db.tasks.filter().userUuidEqualTo(userUuid).findAll();

  @override
  Future<List<Task>> getPendingTasksByUserUuid(String userUuid) async =>
      _db.tasks
          .filter()
          .userUuidEqualTo(userUuid)
          .statusEqualTo(TaskStatus.pending)
          .findAll();

  @override
  Future<List<Task>> getCompletedTasksByUserUuid(String userUuid) async =>
      _db.tasks
          .filter()
          .userUuidEqualTo(userUuid)
          .statusEqualTo(TaskStatus.completed)
          .findAll();

  @override
  Future<List<Task>> getTodayTasksByUserUuid(String userUuid) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db.tasks
        .filter()
        .userUuidEqualTo(userUuid)
        .createdAtBetween(startOfDay, endOfDay)
        .findAll();
  }

  @override
  Future<List<Task>> getMicroTasksByOriginalUuid(String originalUuid) async =>
      _db.tasks
          .filter()
          .originalTaskUuidEqualTo(originalUuid)
          .isMicroTaskEqualTo(true)
          .findAll();

  @override
  Future<bool> deleteTaskByUuid(String uuid) async => _db
      .writeTxn(() async => _db.tasks.filter().uuidEqualTo(uuid).deleteFirst());

  @override
  Future<int> deleteAllTasksByUserUuid(String userUuid) async => _db.writeTxn(
      () async => _db.tasks.filter().userUuidEqualTo(userUuid).deleteAll());

  @override
  Future<List<Task>> getTasksByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.tasks
          .filter()
          .userUuidEqualTo(userUuid)
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<int> getCompletedTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.tasks
          .filter()
          .userUuidEqualTo(userUuid)
          .statusEqualTo(TaskStatus.completed)
          .completedAtBetween(start, end)
          .count();

  @override
  Future<int> getTotalTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.tasks
          .filter()
          .userUuidEqualTo(userUuid)
          .createdAtBetween(start, end)
          .count();

  // =====================
  // JournalEntry操作
  // =====================

  @override
  Future<JournalEntry> putJournalEntry(JournalEntry entry) async {
    await _db.writeTxn(() async {
      await _db.journalEntrys.put(entry);
    });
    return entry;
  }

  @override
  Future<JournalEntry?> getJournalEntryByUuid(String uuid) async =>
      _db.journalEntrys.filter().uuidEqualTo(uuid).findFirst();

  @override
  Future<List<JournalEntry>> getJournalEntriesByUserUuid(
          String userUuid) async =>
      _db.journalEntrys
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<JournalEntry>> getJournalEntriesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.journalEntrys
          .filter()
          .userUuidEqualTo(userUuid)
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<JournalEntry>> getTodayJournalEntriesByUserUuid(
      String userUuid) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getJournalEntriesByUserUuidAndDateRange(
        userUuid, startOfDay, endOfDay);
  }

  @override
  Future<bool> deleteJournalEntryByUuid(String uuid) async => _db.writeTxn(
      () async => _db.journalEntrys.filter().uuidEqualTo(uuid).deleteFirst());

  @override
  Future<int> deleteAllJournalEntriesByUserUuid(String userUuid) async =>
      _db.writeTxn(() async =>
          _db.journalEntrys.filter().userUuidEqualTo(userUuid).deleteAll());

  // =====================
  // SelfEsteemScore操作
  // =====================

  @override
  Future<SelfEsteemScore> putSelfEsteemScore(SelfEsteemScore score) async {
    await _db.writeTxn(() async {
      await _db.selfEsteemScores.put(score);
    });
    return score;
  }

  @override
  Future<SelfEsteemScore?> getSelfEsteemScoreByUuid(String uuid) async =>
      _db.selfEsteemScores.filter().uuidEqualTo(uuid).findFirst();

  @override
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuid(
          String userUuid) async =>
      _db.selfEsteemScores
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByMeasuredAtDesc()
          .findAll();

  @override
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.selfEsteemScores
          .filter()
          .userUuidEqualTo(userUuid)
          .measuredAtBetween(start, end)
          .sortByMeasuredAtDesc()
          .findAll();

  @override
  Future<SelfEsteemScore?> getLatestSelfEsteemScoreByUserUuid(
          String userUuid) async =>
      _db.selfEsteemScores
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByMeasuredAtDesc()
          .findFirst();

  @override
  Future<bool> deleteSelfEsteemScoreByUuid(String uuid) async =>
      _db.writeTxn(() async =>
          _db.selfEsteemScores.filter().uuidEqualTo(uuid).deleteFirst());

  @override
  Future<int> deleteAllSelfEsteemScoresByUserUuid(String userUuid) async =>
      _db.writeTxn(() async =>
          _db.selfEsteemScores.filter().userUuidEqualTo(userUuid).deleteAll());

  // =====================
  // SuccessExperience操作
  // =====================

  @override
  Future<SuccessExperience> putSuccessExperience(
      SuccessExperience experience) async {
    await _db.writeTxn(() async {
      await _db.successExperiences.put(experience);
    });
    return experience;
  }

  @override
  Future<SuccessExperience?> getSuccessExperienceByUuid(String uuid) async =>
      _db.successExperiences.filter().uuidEqualTo(uuid).findFirst();

  @override
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuid(
          String userUuid) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<SuccessExperience>> getRecentSuccessExperiencesByUserUuid(
    String userUuid, {
    int limit = 10,
  }) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByCreatedAtDesc()
          .limit(limit)
          .findAll();

  @override
  Future<List<SuccessExperience>> searchSuccessExperiencesByTag(
    String userUuid,
    String tag,
  ) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .tagsContains(tag)
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<SuccessExperience>> searchSuccessExperiencesByEmotion(
    String userUuid,
    String emotion,
  ) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .group((q) => q
              .emotionBeforeContains(emotion)
              .or()
              .emotionAfterContains(emotion))
          .sortByCreatedAtDesc()
          .findAll();

  @override
  Future<List<SuccessExperience>> getMostReferencedSuccessExperiences(
    String userUuid, {
    int limit = 5,
  }) async =>
      _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .sortByReferenceCountDesc()
          .limit(limit)
          .findAll();

  @override
  Future<bool> deleteSuccessExperienceByUuid(String uuid) async =>
      _db.writeTxn(() async =>
          _db.successExperiences.filter().uuidEqualTo(uuid).deleteFirst());

  @override
  Future<int> deleteAllSuccessExperiencesByUserUuid(String userUuid) async =>
      _db.writeTxn(() async => _db.successExperiences
          .filter()
          .userUuidEqualTo(userUuid)
          .deleteAll());

  /// Isarインスタンスを直接取得（レガシー互換性のため）
  /// 新規コードでは使用しないこと
  @Deprecated('Use LocalStorageService interface methods instead')
  Isar get isar => _db;
}
