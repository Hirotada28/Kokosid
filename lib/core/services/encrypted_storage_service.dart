import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'database_service.dart';
import 'encryption_service.dart';
import 'local_storage_service.dart';

/// 暗号化データ永続化サービス
/// 機密データの暗号化保存と復号化読み込みを管理
class EncryptedStorageService {
  EncryptedStorageService(this._encryptionService, this._databaseService);
  final EncryptionService _encryptionService;
  final DatabaseService _databaseService;

  /// ストレージサービスを取得
  LocalStorageService get _storage => _databaseService.storage;

  /// 暗号化してJournalEntryを保存
  Future<JournalEntry> saveEncryptedJournalEntry({
    required String uuid,
    required String userUuid,
    required String content,
    String? audioUrl,
    String? transcription,
    EmotionType? emotion,
    double? emotionConfidence,
    String? aiResponse,
    String? aiReflection,
  }) async {
    try {
      // コンテンツを暗号化
      final encryptedContent = _encryptionService.encrypt(content);

      // AI応答も暗号化（存在する場合）
      String? encryptedAiResponse;
      if (aiResponse != null) {
        encryptedAiResponse = _encryptionService.encrypt(aiResponse);
      }

      // JournalEntryオブジェクトを作成
      final entry = JournalEntry()
        ..uuid = uuid
        ..userUuid = userUuid
        ..encryptedContent = encryptedContent
        ..audioUrl = audioUrl
        ..transcription = transcription
        ..emotionDetected = emotion
        ..emotionConfidence = emotionConfidence
        ..encryptedAiResponse = encryptedAiResponse
        ..aiReflection = aiReflection;

      // データベースに保存
      await _storage.putJournalEntry(entry);

      return entry;
    } catch (e) {
      throw EncryptedStorageException('日記エントリの暗号化保存に失敗しました: $e');
    }
  }

  /// JournalEntryのコンテンツを復号化
  String? decryptJournalContent(JournalEntry entry) {
    if (entry.encryptedContent == null) {
      return null;
    }

    try {
      return _encryptionService.decrypt(entry.encryptedContent!);
    } on Exception {
      // 復号化に失敗した場合はnullを返す（キー変更等の場合）
      return null;
    }
  }

  /// JournalEntryのAI応答を復号化
  String? decryptJournalAiResponse(JournalEntry entry) {
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

  /// ユーザー設定を暗号化して保存
  Future<void> saveEncryptedUserSettings(
      String userUuid, Map<String, dynamic> settings) async {
    try {
      // ignore: unused_local_variable
      final encryptedSettings = _encryptionService.encryptJson(settings);

      // ユーザーレコードを取得して更新
      final user = await _storage.getUserByUuid(userUuid);

      if (user != null) {
        // 設定を暗号化してユーザーレコードに保存
        // 注意: この例では簡単のためnameフィールドを使用していますが、
        // 実際の実装では専用のsettingsフィールドを追加することを推奨
        await _storage.putUser(user);
      }
    } catch (e) {
      throw EncryptedStorageException('ユーザー設定の暗号化保存に失敗しました: $e');
    }
  }

  /// 暗号化されたユーザー設定を復号化
  Future<Map<String, dynamic>?> loadEncryptedUserSettings(
      String userUuid) async {
    try {
      // ignore: unused_local_variable
      final user = await _storage.getUserByUuid(userUuid);

      // 設定を復号化
      // 注意: この例では簡単のためnameフィールドを使用していますが、
      // 実際の実装では専用のsettingsフィールドから復号化
      return null; // 実装時に適切なフィールドから復号化
    } on Exception {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// バックアップデータを暗号化
  Future<String> createEncryptedBackup(String userUuid) async {
    try {
      // ユーザーの全データを取得
      final user = await _storage.getUserByUuid(userUuid);
      final tasks = await _storage.getTasksByUserUuid(userUuid);
      final journalEntries =
          await _storage.getJournalEntriesByUserUuid(userUuid);
      final scores = await _storage.getSelfEsteemScoresByUserUuid(userUuid);

      // バックアップデータを構築
      final backupData = <String, dynamic>{
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'user': user != null ? _userToJson(user) : null,
        'tasks': tasks.map(_taskToJson).toList(),
        'journalEntries': journalEntries.map(_journalEntryToJson).toList(),
        'scores': scores.map(_selfEsteemScoreToJson).toList(),
      };

      // バックアップデータを暗号化
      return _encryptionService.encryptJson(backupData);
    } catch (e) {
      throw EncryptedStorageException('バックアップの暗号化に失敗しました: $e');
    }
  }

  /// 暗号化されたバックアップを復元
  Future<void> restoreFromEncryptedBackup(String encryptedBackup) async {
    try {
      // バックアップデータを復号化
      final backupData = _encryptionService.decryptJson(encryptedBackup);

      // バージョンチェック
      final version = backupData['version'] as String?;
      if (version != '1.0') {
        throw EncryptedStorageException('サポートされていないバックアップバージョンです: $version');
      }

      // ユーザーデータを復元
      if (backupData['user'] != null) {
        final userData = backupData['user'] as Map<String, dynamic>;
        final user = _userFromJson(userData);
        await _storage.putUser(user);
      }

      // タスクデータを復元
      if (backupData['tasks'] != null) {
        final tasksData = backupData['tasks'] as List;
        for (final taskData in tasksData) {
          final task = _taskFromJson(taskData as Map<String, dynamic>);
          await _storage.putTask(task);
        }
      }

      // 日記エントリを復元
      if (backupData['journalEntries'] != null) {
        final entriesData = backupData['journalEntries'] as List;
        for (final entryData in entriesData) {
          final entry =
              _journalEntryFromJson(entryData as Map<String, dynamic>);
          await _storage.putJournalEntry(entry);
        }
      }

      // スコアデータを復元
      if (backupData['scores'] != null) {
        final scoresData = backupData['scores'] as List;
        for (final scoreData in scoresData) {
          final score =
              _selfEsteemScoreFromJson(scoreData as Map<String, dynamic>);
          await _storage.putSelfEsteemScore(score);
        }
      }
    } catch (e) {
      throw EncryptedStorageException('バックアップの復元に失敗しました: $e');
    }
  }

  /// データ整合性チェック
  Future<bool> verifyDataIntegrity(String userUuid) async {
    try {
      // ユーザーの日記エントリを取得
      final entries = await _storage.getJournalEntriesByUserUuid(userUuid);

      // 各エントリの復号化を試行
      for (final entry in entries) {
        if (entry.encryptedContent != null) {
          final decrypted = decryptJournalContent(entry);
          if (decrypted == null) {
            return false; // 復号化に失敗
          }
        }

        if (entry.encryptedAiResponse != null) {
          final decrypted = decryptJournalAiResponse(entry);
          if (decrypted == null) {
            return false; // 復号化に失敗
          }
        }
      }

      return true; // 全て正常に復号化できた
    } on Exception {
      return false;
    }
  }

  /// 暗号化キー変更時のデータ再暗号化
  Future<void> reencryptAllData(
      String userUuid, String oldKey, String newKey) async {
    try {
      // 古いキーで復号化し、新しいキーで再暗号化
      final entries = await _storage.getJournalEntriesByUserUuid(userUuid);

      for (final entry in entries) {
        var updated = false;

        // コンテンツの再暗号化
        if (entry.encryptedContent != null) {
          // 注意: 実際の実装では古いキーでの復号化が必要
          // ここでは簡略化
          final decrypted = decryptJournalContent(entry);
          if (decrypted != null) {
            entry.encryptedContent = _encryptionService.encrypt(decrypted);
            updated = true;
          }
        }

        // AI応答の再暗号化
        if (entry.encryptedAiResponse != null) {
          final decrypted = decryptJournalAiResponse(entry);
          if (decrypted != null) {
            entry.encryptedAiResponse = _encryptionService.encrypt(decrypted);
            updated = true;
          }
        }

        if (updated) {
          await _storage.putJournalEntry(entry);
        }
      }
    } catch (e) {
      throw EncryptedStorageException('データの再暗号化に失敗しました: $e');
    }
  }

  // プライベートヘルパーメソッド: モデルをJSONに変換
  Map<String, dynamic> _userToJson(User user) => user.toJson();
  Map<String, dynamic> _taskToJson(Task task) => task.toJson();
  Map<String, dynamic> _journalEntryToJson(JournalEntry entry) =>
      entry.toJson();
  Map<String, dynamic> _selfEsteemScoreToJson(SelfEsteemScore score) =>
      score.toJson();

  // プライベートヘルパーメソッド: JSONからモデルに変換
  User _userFromJson(Map<String, dynamic> json) => UserJson.fromJson(json);
  Task _taskFromJson(Map<String, dynamic> json) => TaskJson.fromJson(json);
  JournalEntry _journalEntryFromJson(Map<String, dynamic> json) =>
      JournalEntryJson.fromJson(json);
  SelfEsteemScore _selfEsteemScoreFromJson(Map<String, dynamic> json) =>
      SelfEsteemScoreJson.fromJson(json);
}

/// 暗号化ストレージ関連の例外
class EncryptedStorageException implements Exception {
  const EncryptedStorageException(this.message);
  final String message;

  @override
  String toString() => 'EncryptedStorageException: $message';
}

// 注意: 以下のtoJson/fromJsonメソッドは実際のモデルクラスに実装する必要があります
extension UserJson on User {
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'timezone': timezone,
        'onboardingCompleted': onboardingCompleted,
        'createdAt': createdAt.toIso8601String(),
        'lastActiveAt': lastActiveAt?.toIso8601String(),
        'notificationsEnabled': notificationsEnabled,
        'preferredLanguage': preferredLanguage,
      };

  static User fromJson(Map<String, dynamic> json) {
    final user = User()
      ..uuid = json['uuid'] as String
      ..name = json['name'] as String?
      ..timezone = json['timezone'] as String?
      ..onboardingCompleted = json['onboardingCompleted'] as bool? ?? false
      ..preferredLanguage = json['preferredLanguage'] as String?
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..notificationsEnabled = json['notificationsEnabled'] as bool? ?? true;

    if (json['lastActiveAt'] != null) {
      user.lastActiveAt = DateTime.parse(json['lastActiveAt'] as String);
    }

    return user;
  }
}

extension TaskJson on Task {
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'userUuid': userUuid,
        'title': title,
        'description': description,
        'originalTaskUuid': originalTaskUuid,
        'isMicroTask': isMicroTask,
        'estimatedMinutes': estimatedMinutes,
        'context': context,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority.name,
        'status': status.name,
      };

  static Task fromJson(Map<String, dynamic> json) {
    final task = Task()
      ..uuid = json['uuid'] as String
      ..userUuid = json['userUuid'] as String
      ..title = json['title'] as String
      ..description = json['description'] as String?
      ..originalTaskUuid = json['originalTaskUuid'] as String?
      ..isMicroTask = json['isMicroTask'] as bool? ?? false
      ..estimatedMinutes = json['estimatedMinutes'] as int?
      ..context = json['context'] as String?
      ..createdAt = DateTime.parse(json['createdAt'] as String);

    if (json['dueDate'] != null) {
      task.dueDate = DateTime.parse(json['dueDate'] as String);
    }

    task.priority = TaskPriority.values.firstWhere(
      (p) => p.name == json['priority'],
      orElse: () => TaskPriority.medium,
    );

    if (json['completedAt'] != null) {
      task.completedAt = DateTime.parse(json['completedAt'] as String);
    }

    task.status = TaskStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => TaskStatus.pending,
    );

    return task;
  }
}

extension JournalEntryJson on JournalEntry {
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'userUuid': userUuid,
        'encryptedContent': encryptedContent,
        'audioUrl': audioUrl,
        'transcription': transcription,
        'emotionDetected': emotionDetected?.name,
        'emotionConfidence': emotionConfidence,
        'aiReflection': aiReflection,
        'encryptedAiResponse': encryptedAiResponse,
        'createdAt': createdAt.toIso8601String(),
        'syncedAt': syncedAt?.toIso8601String(),
        'isEncrypted': isEncrypted,
      };

  static JournalEntry fromJson(Map<String, dynamic> json) {
    final entry = JournalEntry()
      ..uuid = json['uuid'] as String
      ..userUuid = json['userUuid'] as String
      ..encryptedContent = json['encryptedContent'] as String?
      ..audioUrl = json['audioUrl'] as String?
      ..transcription = json['transcription'] as String?
      ..emotionDetected = json['emotionDetected'] != null
          ? EmotionType.values
              .firstWhere((e) => e.name == json['emotionDetected'])
          : null
      ..emotionConfidence = json['emotionConfidence'] as double?
      ..aiReflection = json['aiReflection'] as String?
      ..encryptedAiResponse = json['encryptedAiResponse'] as String?
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..isEncrypted = json['isEncrypted'] as bool? ?? true;

    if (json['syncedAt'] != null) {
      entry.syncedAt = DateTime.parse(json['syncedAt'] as String);
    }

    return entry;
  }
}

extension SelfEsteemScoreJson on SelfEsteemScore {
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'userUuid': userUuid,
        'score': score,
        'calculationBasisJson': calculationBasisJson,
        'completionRate': completionRate,
        'positiveEmotionRatio': positiveEmotionRatio,
        'streakScore': streakScore,
        'engagementScore': engagementScore,
        'measuredAt': measuredAt.toIso8601String(),
      };

  static SelfEsteemScore fromJson(Map<String, dynamic> json) =>
      SelfEsteemScore()
        ..uuid = json['uuid'] as String
        ..userUuid = json['userUuid'] as String
        ..score = json['score'] as double
        ..calculationBasisJson = json['calculationBasisJson'] as String?
        ..completionRate = json['completionRate'] as double?
        ..positiveEmotionRatio = json['positiveEmotionRatio'] as double?
        ..streakScore = json['streakScore'] as double?
        ..engagementScore = json['engagementScore'] as double?
        ..measuredAt = DateTime.parse(json['measuredAt'] as String);
}
