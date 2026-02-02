import 'package:hive/hive.dart';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/success_experience.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'local_storage_service.dart';

/// Web用ストレージ実装（Hive + IndexedDB）
/// ブラウザ環境で動作するFlutter Webアプリケーション向け
class WebStorageService implements LocalStorageService {
  static const String _userBoxName = 'users';
  static const String _taskBoxName = 'tasks';
  static const String _journalBoxName = 'journal_entries';
  static const String _scoreBoxName = 'self_esteem_scores';
  static const String _experienceBoxName = 'success_experiences';

  late Box<Map<dynamic, dynamic>> _userBox;
  late Box<Map<dynamic, dynamic>> _taskBox;
  late Box<Map<dynamic, dynamic>> _journalBox;
  late Box<Map<dynamic, dynamic>> _scoreBox;
  late Box<Map<dynamic, dynamic>> _experienceBox;

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _userBox = await Hive.openBox<Map<dynamic, dynamic>>(_userBoxName);
      _taskBox = await Hive.openBox<Map<dynamic, dynamic>>(_taskBoxName);
      _journalBox = await Hive.openBox<Map<dynamic, dynamic>>(_journalBoxName);
      _scoreBox = await Hive.openBox<Map<dynamic, dynamic>>(_scoreBoxName);
      _experienceBox =
          await Hive.openBox<Map<dynamic, dynamic>>(_experienceBoxName);

      _isInitialized = true;
    } catch (e) {
      throw StorageException('Webストレージの初期化に失敗しました: $e');
    }
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> close() async {
    if (!_isInitialized) return;
    await _userBox.close();
    await _taskBox.close();
    await _journalBox.close();
    await _scoreBox.close();
    await _experienceBox.close();
    _isInitialized = false;
  }

  @override
  Future<void> clearAllData() async {
    if (!_isInitialized) return;
    await _userBox.clear();
    await _taskBox.clear();
    await _journalBox.clear();
    await _scoreBox.clear();
    await _experienceBox.clear();
  }

  @override
  Future<void> clearUserData(String userUuid) async {
    if (!_isInitialized) return;

    // タスクを削除
    final taskKeys = _taskBox.keys.where((key) {
      final data = _taskBox.get(key);
      return data?['userUuid'] == userUuid;
    }).toList();
    await _taskBox.deleteAll(taskKeys);

    // 日記エントリを削除
    final journalKeys = _journalBox.keys.where((key) {
      final data = _journalBox.get(key);
      return data?['userUuid'] == userUuid;
    }).toList();
    await _journalBox.deleteAll(journalKeys);

    // スコアを削除
    final scoreKeys = _scoreBox.keys.where((key) {
      final data = _scoreBox.get(key);
      return data?['userUuid'] == userUuid;
    }).toList();
    await _scoreBox.deleteAll(scoreKeys);

    // 成功体験を削除
    final experienceKeys = _experienceBox.keys.where((key) {
      final data = _experienceBox.get(key);
      return data?['userUuid'] == userUuid;
    }).toList();
    await _experienceBox.deleteAll(experienceKeys);

    // ユーザーを削除
    final userKeys = _userBox.keys.where((key) {
      final data = _userBox.get(key);
      return data?['uuid'] == userUuid;
    }).toList();
    await _userBox.deleteAll(userKeys);
  }

  @override
  Future<int> getDatabaseSize() async {
    if (!_isInitialized) return 0;
    return _userBox.length +
        _taskBox.length +
        _journalBox.length +
        _scoreBox.length +
        _experienceBox.length;
  }

  // =====================
  // User操作
  // =====================

  @override
  Future<User> putUser(User user) async {
    final data = _userToMap(user);
    await _userBox.put(user.uuid, data);
    return user;
  }

  @override
  Future<User?> getUserByUuid(String uuid) async {
    final data = _userBox.get(uuid);
    if (data == null) return null;
    return _mapToUser(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _userBox.values
        .map((data) => _mapToUser(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<User?> getFirstUser() async {
    if (_userBox.isEmpty) return null;
    final data = _userBox.values.first;
    return _mapToUser(Map<String, dynamic>.from(data));
  }

  @override
  Future<bool> deleteUserByUuid(String uuid) async {
    if (!_userBox.containsKey(uuid)) return false;
    await _userBox.delete(uuid);
    return true;
  }

  // =====================
  // Task操作
  // =====================

  @override
  Future<Task> putTask(Task task) async {
    final data = _taskToMap(task);
    await _taskBox.put(task.uuid, data);
    return task;
  }

  @override
  Future<Task?> getTaskByUuid(String uuid) async {
    final data = _taskBox.get(uuid);
    if (data == null) return null;
    return _mapToTask(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<Task>> getTasksByUserUuid(String userUuid) async {
    return _taskBox.values
        .where((data) => data['userUuid'] == userUuid)
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<List<Task>> getPendingTasksByUserUuid(String userUuid) async {
    return _taskBox.values
        .where((data) =>
            data['userUuid'] == userUuid && data['status'] == 'pending')
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<List<Task>> getCompletedTasksByUserUuid(String userUuid) async {
    return _taskBox.values
        .where((data) =>
            data['userUuid'] == userUuid && data['status'] == 'completed')
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<List<Task>> getTodayTasksByUserUuid(String userUuid) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _taskBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final createdAt = DateTime.parse(data['createdAt'] as String);
          return createdAt.isAfter(startOfDay) && createdAt.isBefore(endOfDay);
        })
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<List<Task>> getMicroTasksByOriginalUuid(String originalUuid) async {
    return _taskBox.values
        .where((data) =>
            data['originalTaskUuid'] == originalUuid &&
            data['isMicroTask'] == true)
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
  }

  @override
  Future<bool> deleteTaskByUuid(String uuid) async {
    if (!_taskBox.containsKey(uuid)) return false;
    await _taskBox.delete(uuid);
    return true;
  }

  @override
  Future<int> deleteAllTasksByUserUuid(String userUuid) async {
    final keysToDelete = _taskBox.keys
        .where((key) => _taskBox.get(key)?['userUuid'] == userUuid)
        .toList();
    await _taskBox.deleteAll(keysToDelete);
    return keysToDelete.length;
  }

  @override
  Future<List<Task>> getTasksByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final tasks = _taskBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final createdAt = DateTime.parse(data['createdAt'] as String);
          return createdAt.isAfter(start) && createdAt.isBefore(end);
        })
        .map((data) => _mapToTask(Map<String, dynamic>.from(data)))
        .toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  @override
  Future<int> getCompletedTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    return _taskBox.values.where((data) {
      if (data['userUuid'] != userUuid) return false;
      if (data['status'] != 'completed') return false;
      final completedAt = data['completedAt'] as String?;
      if (completedAt == null) return false;
      final date = DateTime.parse(completedAt);
      return date.isAfter(start) && date.isBefore(end);
    }).length;
  }

  @override
  Future<int> getTotalTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    return _taskBox.values.where((data) {
      if (data['userUuid'] != userUuid) return false;
      final createdAt = DateTime.parse(data['createdAt'] as String);
      return createdAt.isAfter(start) && createdAt.isBefore(end);
    }).length;
  }

  // =====================
  // JournalEntry操作
  // =====================

  @override
  Future<JournalEntry> putJournalEntry(JournalEntry entry) async {
    final data = _journalEntryToMap(entry);
    await _journalBox.put(entry.uuid, data);
    return entry;
  }

  @override
  Future<JournalEntry?> getJournalEntryByUuid(String uuid) async {
    final data = _journalBox.get(uuid);
    if (data == null) return null;
    return _mapToJournalEntry(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<JournalEntry>> getJournalEntriesByUserUuid(
      String userUuid) async {
    final entries = _journalBox.values
        .where((data) => data['userUuid'] == userUuid)
        .map((data) => _mapToJournalEntry(Map<String, dynamic>.from(data)))
        .toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  Future<List<JournalEntry>> getJournalEntriesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final entries = _journalBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final createdAt = DateTime.parse(data['createdAt'] as String);
          return createdAt.isAfter(start) && createdAt.isBefore(end);
        })
        .map((data) => _mapToJournalEntry(Map<String, dynamic>.from(data)))
        .toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

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
  Future<bool> deleteJournalEntryByUuid(String uuid) async {
    if (!_journalBox.containsKey(uuid)) return false;
    await _journalBox.delete(uuid);
    return true;
  }

  @override
  Future<int> deleteAllJournalEntriesByUserUuid(String userUuid) async {
    final keysToDelete = _journalBox.keys
        .where((key) => _journalBox.get(key)?['userUuid'] == userUuid)
        .toList();
    await _journalBox.deleteAll(keysToDelete);
    return keysToDelete.length;
  }

  // =====================
  // SelfEsteemScore操作
  // =====================

  @override
  Future<SelfEsteemScore> putSelfEsteemScore(SelfEsteemScore score) async {
    final data = _selfEsteemScoreToMap(score);
    await _scoreBox.put(score.uuid, data);
    return score;
  }

  @override
  Future<SelfEsteemScore?> getSelfEsteemScoreByUuid(String uuid) async {
    final data = _scoreBox.get(uuid);
    if (data == null) return null;
    return _mapToSelfEsteemScore(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuid(
      String userUuid) async {
    final scores = _scoreBox.values
        .where((data) => data['userUuid'] == userUuid)
        .map((data) => _mapToSelfEsteemScore(Map<String, dynamic>.from(data)))
        .toList();
    scores.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    return scores;
  }

  @override
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final scores = _scoreBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final measuredAt = DateTime.parse(data['measuredAt'] as String);
          return measuredAt.isAfter(start) && measuredAt.isBefore(end);
        })
        .map((data) => _mapToSelfEsteemScore(Map<String, dynamic>.from(data)))
        .toList();
    scores.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    return scores;
  }

  @override
  Future<SelfEsteemScore?> getLatestSelfEsteemScoreByUserUuid(
      String userUuid) async {
    final scores = await getSelfEsteemScoresByUserUuid(userUuid);
    if (scores.isEmpty) return null;
    return scores.first;
  }

  @override
  Future<bool> deleteSelfEsteemScoreByUuid(String uuid) async {
    if (!_scoreBox.containsKey(uuid)) return false;
    await _scoreBox.delete(uuid);
    return true;
  }

  @override
  Future<int> deleteAllSelfEsteemScoresByUserUuid(String userUuid) async {
    final keysToDelete = _scoreBox.keys
        .where((key) => _scoreBox.get(key)?['userUuid'] == userUuid)
        .toList();
    await _scoreBox.deleteAll(keysToDelete);
    return keysToDelete.length;
  }

  // =====================
  // シリアライゼーション・ヘルパー
  // =====================

  Map<String, dynamic> _userToMap(User user) {
    return {
      'uuid': user.uuid,
      'name': user.name,
      'timezone': user.timezone,
      'onboardingCompleted': user.onboardingCompleted,
      'createdAt': user.createdAt.toIso8601String(),
      'lastActiveAt': user.lastActiveAt?.toIso8601String(),
      'notificationsEnabled': user.notificationsEnabled,
      'preferredLanguage': user.preferredLanguage,
    };
  }

  User _mapToUser(Map<String, dynamic> data) {
    final user = User()
      ..uuid = data['uuid'] as String
      ..name = data['name'] as String?
      ..timezone = data['timezone'] as String?
      ..onboardingCompleted = data['onboardingCompleted'] as bool? ?? false
      ..createdAt = DateTime.parse(data['createdAt'] as String)
      ..lastActiveAt = data['lastActiveAt'] != null
          ? DateTime.parse(data['lastActiveAt'] as String)
          : null
      ..notificationsEnabled = data['notificationsEnabled'] as bool? ?? true
      ..preferredLanguage = data['preferredLanguage'] as String?;
    return user;
  }

  Map<String, dynamic> _taskToMap(Task task) {
    return {
      'uuid': task.uuid,
      'userUuid': task.userUuid,
      'title': task.title,
      'description': task.description,
      'originalTaskUuid': task.originalTaskUuid,
      'isMicroTask': task.isMicroTask,
      'estimatedMinutes': task.estimatedMinutes,
      'context': task.context,
      'completedAt': task.completedAt?.toIso8601String(),
      'createdAt': task.createdAt.toIso8601String(),
      'dueDate': task.dueDate?.toIso8601String(),
      'priority': task.priority.name,
      'status': task.status.name,
    };
  }

  Task _mapToTask(Map<String, dynamic> data) {
    final task = Task()
      ..uuid = data['uuid'] as String
      ..userUuid = data['userUuid'] as String
      ..title = data['title'] as String
      ..description = data['description'] as String?
      ..originalTaskUuid = data['originalTaskUuid'] as String?
      ..isMicroTask = data['isMicroTask'] as bool? ?? false
      ..estimatedMinutes = data['estimatedMinutes'] as int?
      ..context = data['context'] as String?
      ..completedAt = data['completedAt'] != null
          ? DateTime.parse(data['completedAt'] as String)
          : null
      ..createdAt = DateTime.parse(data['createdAt'] as String)
      ..dueDate = data['dueDate'] != null
          ? DateTime.parse(data['dueDate'] as String)
          : null
      ..priority = TaskPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => TaskPriority.medium,
      )
      ..status = TaskStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TaskStatus.pending,
      );
    return task;
  }

  Map<String, dynamic> _journalEntryToMap(JournalEntry entry) {
    return {
      'uuid': entry.uuid,
      'userUuid': entry.userUuid,
      'encryptedContent': entry.encryptedContent,
      'audioUrl': entry.audioUrl,
      'transcription': entry.transcription,
      'emotionDetected': entry.emotionDetected?.name,
      'emotionConfidence': entry.emotionConfidence,
      'aiReflection': entry.aiReflection,
      'encryptedAiResponse': entry.encryptedAiResponse,
      'createdAt': entry.createdAt.toIso8601String(),
      'syncedAt': entry.syncedAt?.toIso8601String(),
      'isEncrypted': entry.isEncrypted,
    };
  }

  JournalEntry _mapToJournalEntry(Map<String, dynamic> data) {
    final entry = JournalEntry()
      ..uuid = data['uuid'] as String
      ..userUuid = data['userUuid'] as String
      ..encryptedContent = data['encryptedContent'] as String?
      ..audioUrl = data['audioUrl'] as String?
      ..transcription = data['transcription'] as String?
      ..emotionDetected = data['emotionDetected'] != null
          ? EmotionType.values.firstWhere(
              (e) => e.name == data['emotionDetected'],
              orElse: () => EmotionType.neutral,
            )
          : null
      ..emotionConfidence = (data['emotionConfidence'] as num?)?.toDouble()
      ..aiReflection = data['aiReflection'] as String?
      ..encryptedAiResponse = data['encryptedAiResponse'] as String?
      ..createdAt = DateTime.parse(data['createdAt'] as String)
      ..syncedAt = data['syncedAt'] != null
          ? DateTime.parse(data['syncedAt'] as String)
          : null
      ..isEncrypted = data['isEncrypted'] as bool? ?? true;
    return entry;
  }

  Map<String, dynamic> _selfEsteemScoreToMap(SelfEsteemScore score) {
    return {
      'uuid': score.uuid,
      'userUuid': score.userUuid,
      'score': score.score,
      'calculationBasisJson': score.calculationBasisJson,
      'completionRate': score.completionRate,
      'positiveEmotionRatio': score.positiveEmotionRatio,
      'streakScore': score.streakScore,
      'engagementScore': score.engagementScore,
      'measuredAt': score.measuredAt.toIso8601String(),
    };
  }

  SelfEsteemScore _mapToSelfEsteemScore(Map<String, dynamic> data) {
    final score = SelfEsteemScore()
      ..uuid = data['uuid'] as String
      ..userUuid = data['userUuid'] as String
      ..score = (data['score'] as num).toDouble()
      ..calculationBasisJson = data['calculationBasisJson'] as String?
      ..completionRate = (data['completionRate'] as num?)?.toDouble()
      ..positiveEmotionRatio =
          (data['positiveEmotionRatio'] as num?)?.toDouble()
      ..streakScore = (data['streakScore'] as num?)?.toDouble()
      ..engagementScore = (data['engagementScore'] as num?)?.toDouble()
      ..measuredAt = DateTime.parse(data['measuredAt'] as String);
    return score;
  }

  // =====================
  // SuccessExperience操作
  // =====================

  @override
  Future<SuccessExperience> putSuccessExperience(
      SuccessExperience experience) async {
    final data = _successExperienceToMap(experience);
    await _experienceBox.put(experience.uuid, data);
    return experience;
  }

  @override
  Future<SuccessExperience?> getSuccessExperienceByUuid(String uuid) async {
    final data = _experienceBox.get(uuid);
    if (data == null) return null;
    return _mapToSuccessExperience(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuid(
      String userUuid) async {
    final experiences = _experienceBox.values
        .where((data) => data['userUuid'] == userUuid)
        .map((data) => _mapToSuccessExperience(Map<String, dynamic>.from(data)))
        .toList();
    experiences.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return experiences;
  }

  @override
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  ) async {
    final experiences = _experienceBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final createdAt = DateTime.parse(data['createdAt'] as String);
          return createdAt.isAfter(start) && createdAt.isBefore(end);
        })
        .map((data) => _mapToSuccessExperience(Map<String, dynamic>.from(data)))
        .toList();
    experiences.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return experiences;
  }

  @override
  Future<List<SuccessExperience>> getRecentSuccessExperiencesByUserUuid(
    String userUuid, {
    int limit = 10,
  }) async {
    final experiences = await getSuccessExperiencesByUserUuid(userUuid);
    return experiences.take(limit).toList();
  }

  @override
  Future<List<SuccessExperience>> searchSuccessExperiencesByTag(
    String userUuid,
    String tag,
  ) async {
    final experiences = _experienceBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final tags = data['tags'] as String? ?? '';
          return tags.toLowerCase().contains(tag.toLowerCase());
        })
        .map((data) => _mapToSuccessExperience(Map<String, dynamic>.from(data)))
        .toList();
    experiences.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return experiences;
  }

  @override
  Future<List<SuccessExperience>> searchSuccessExperiencesByEmotion(
    String userUuid,
    String emotion,
  ) async {
    final experiences = _experienceBox.values
        .where((data) {
          if (data['userUuid'] != userUuid) return false;
          final emotionBefore = data['emotionBefore'] as String? ?? '';
          final emotionAfter = data['emotionAfter'] as String? ?? '';
          return emotionBefore.toLowerCase().contains(emotion.toLowerCase()) ||
              emotionAfter.toLowerCase().contains(emotion.toLowerCase());
        })
        .map((data) => _mapToSuccessExperience(Map<String, dynamic>.from(data)))
        .toList();
    experiences.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return experiences;
  }

  @override
  Future<List<SuccessExperience>> getMostReferencedSuccessExperiences(
    String userUuid, {
    int limit = 5,
  }) async {
    final experiences = _experienceBox.values
        .where((data) => data['userUuid'] == userUuid)
        .map((data) => _mapToSuccessExperience(Map<String, dynamic>.from(data)))
        .toList();
    experiences.sort((a, b) => b.referenceCount.compareTo(a.referenceCount));
    return experiences.take(limit).toList();
  }

  @override
  Future<bool> deleteSuccessExperienceByUuid(String uuid) async {
    if (!_experienceBox.containsKey(uuid)) return false;
    await _experienceBox.delete(uuid);
    return true;
  }

  @override
  Future<int> deleteAllSuccessExperiencesByUserUuid(String userUuid) async {
    final keys = _experienceBox.keys.where((key) {
      final data = _experienceBox.get(key);
      return data?['userUuid'] == userUuid;
    }).toList();
    await _experienceBox.deleteAll(keys);
    return keys.length;
  }

  // SuccessExperience変換ヘルパー

  Map<String, dynamic> _successExperienceToMap(SuccessExperience experience) {
    return {
      'uuid': experience.uuid,
      'userUuid': experience.userUuid,
      'title': experience.title,
      'description': experience.description,
      'taskUuid': experience.taskUuid,
      'emotionBefore': experience.emotionBefore,
      'emotionAfter': experience.emotionAfter,
      'lessonsLearned': experience.lessonsLearned,
      'tags': experience.tags,
      'createdAt': experience.createdAt.toIso8601String(),
      'lastReferencedAt': experience.lastReferencedAt?.toIso8601String(),
      'referenceCount': experience.referenceCount,
    };
  }

  SuccessExperience _mapToSuccessExperience(Map<String, dynamic> data) {
    final experience = SuccessExperience()
      ..uuid = data['uuid'] as String
      ..userUuid = data['userUuid'] as String
      ..title = data['title'] as String
      ..description = data['description'] as String
      ..taskUuid = data['taskUuid'] as String?
      ..emotionBefore = data['emotionBefore'] as String?
      ..emotionAfter = data['emotionAfter'] as String?
      ..lessonsLearned = data['lessonsLearned'] as String?
      ..tags = data['tags'] as String?
      ..createdAt = DateTime.parse(data['createdAt'] as String)
      ..lastReferencedAt = data['lastReferencedAt'] != null
          ? DateTime.parse(data['lastReferencedAt'] as String)
          : null
      ..referenceCount = data['referenceCount'] as int? ?? 0;
    return experience;
  }
}
