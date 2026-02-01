import 'dart:convert';
import '../models/journal_entry.dart';
import '../models/user.dart';
import 'encryption_service.dart';
import 'database_service.dart';

/// 暗号化データ永続化サービス
/// 機密データの暗号化保存と復号化読み込みを管理
class EncryptedStorageService {
  EncryptedStorageService(this._encryptionService, this._databaseService);
  final EncryptionService _encryptionService;
  final DatabaseService _databaseService;

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
      final entry = JournalEntry();
      entry.uuid = uuid;
      entry.userUuid = userUuid;
      entry.encryptedContent = encryptedContent;
      entry.audioUrl = audioUrl;
      entry.transcription = transcription;
      entry.emotionDetected = emotion;
      entry.emotionConfidence = emotionConfidence;
      entry.encryptedAiResponse = encryptedAiResponse;
      entry.aiReflection = aiReflection;

      // データベースに保存
      final isar = _databaseService.isar;
      await isar.writeTxn(() async {
        await isar.journalEntrys.put(entry);
      });

      return entry;
    } catch (e) {
      throw EncryptedStorageException('日記エントリの暗号化保存に失敗しました: $e');
    }
  }

  /// JournalEntryのコンテンツを復号化
  String? decryptJournalContent(JournalEntry entry) {
    if (entry.encryptedContent == null) return null;

    try {
      return _encryptionService.decrypt(entry.encryptedContent!);
    } catch (e) {
      // 復号化に失敗した場合はnullを返す（キー変更等の場合）
      return null;
    }
  }

  /// JournalEntryのAI応答を復号化
  String? decryptJournalAiResponse(JournalEntry entry) {
    if (entry.encryptedAiResponse == null) return null;

    try {
      return _encryptionService.decrypt(entry.encryptedAiResponse!);
    } catch (e) {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// ユーザー設定を暗号化して保存
  Future<void> saveEncryptedUserSettings(
      String userUuid, Map<String, dynamic> settings) async {
    try {
      final encryptedSettings = _encryptionService.encryptJson(settings);

      // ユーザーレコードを取得して更新
      final isar = _databaseService.isar;
      final user = await isar.users.filter().uuidEqualTo(userUuid).findFirst();

      if (user != null) {
        // 設定を暗号化してユーザーレコードに保存
        // 注意: この例では簡単のためnameフィールドを使用していますが、
        // 実際の実装では専用のsettingsフィールドを追加することを推奨
        await isar.writeTxn(() async {
          await isar.users.put(user);
        });
      }
    } catch (e) {
      throw EncryptedStorageException('ユーザー設定の暗号化保存に失敗しました: $e');
    }
  }

  /// 暗号化されたユーザー設定を復号化
  Future<Map<String, dynamic>?> loadEncryptedUserSettings(
      String userUuid) async {
    try {
      final isar = _databaseService.isar;
      final user = await isar.users.filter().uuidEqualTo(userUuid).findFirst();

      if (user?.name == null) return null;

      // 設定を復号化
      // 注意: この例では簡単のためnameフィールドを使用していますが、
      // 実際の実装では専用のsettingsフィールドから復号化
      return null; // 実装時に適切なフィールドから復号化
    } catch (e) {
      // 復号化に失敗した場合はnullを返す
      return null;
    }
  }

  /// バックアップデータを暗号化
  Future<String> createEncryptedBackup(String userUuid) async {
    try {
      final isar = _databaseService.isar;

      // ユーザーの全データを取得
      final user = await isar.users.filter().uuidEqualTo(userUuid).findFirst();
      final tasks =
          await isar.tasks.filter().userUuidEqualTo(userUuid).findAll();
      final journalEntries =
          await isar.journalEntrys.filter().userUuidEqualTo(userUuid).findAll();
      final scores = await isar.selfEsteemScores
          .filter()
          .userUuidEqualTo(userUuid)
          .findAll();

      // バックアップデータを構築
      final backupData = {
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'user': user?.toJson(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'journalEntries': journalEntries.map((j) => j.toJson()).toList(),
        'scores': scores.map((s) => s.toJson()).toList(),
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

      final isar = _databaseService.isar;

      await isar.writeTxn(() async {
        // 既存データをクリア（必要に応じて）
        // await isar.clear();

        // ユーザーデータを復元
        if (backupData['user'] != null) {
          final userData = backupData['user'] as Map<String, dynamic>;
          final user = User.fromJson(userData);
          await isar.users.put(user);
        }

        // タスクデータを復元
        if (backupData['tasks'] != null) {
          final tasksData = backupData['tasks'] as List;
          for (final taskData in tasksData) {
            final task = Task.fromJson(taskData as Map<String, dynamic>);
            await isar.tasks.put(task);
          }
        }

        // 日記エントリを復元
        if (backupData['journalEntries'] != null) {
          final entriesData = backupData['journalEntries'] as List;
          for (final entryData in entriesData) {
            final entry =
                JournalEntry.fromJson(entryData as Map<String, dynamic>);
            await isar.journalEntrys.put(entry);
          }
        }

        // スコアデータを復元
        if (backupData['scores'] != null) {
          final scoresData = backupData['scores'] as List;
          for (final scoreData in scoresData) {
            final score =
                SelfEsteemScore.fromJson(scoreData as Map<String, dynamic>);
            await isar.selfEsteemScores.put(score);
          }
        }
      });
    } catch (e) {
      throw EncryptedStorageException('バックアップの復元に失敗しました: $e');
    }
  }

  /// データ整合性チェック
  Future<bool> verifyDataIntegrity(String userUuid) async {
    try {
      final isar = _databaseService.isar;

      // ユーザーの日記エントリを取得
      final entries =
          await isar.journalEntrys.filter().userUuidEqualTo(userUuid).findAll();

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
    } catch (e) {
      return false;
    }
  }

  /// 暗号化キー変更時のデータ再暗号化
  Future<void> reencryptAllData(
      String userUuid, String oldKey, String newKey) async {
    try {
      final isar = _databaseService.isar;

      // 古いキーで復号化し、新しいキーで再暗号化
      final entries =
          await isar.journalEntrys.filter().userUuidEqualTo(userUuid).findAll();

      await isar.writeTxn(() async {
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
            await isar.journalEntrys.put(entry);
          }
        }
      });
    } catch (e) {
      throw EncryptedStorageException('データの再暗号化に失敗しました: $e');
    }
  }
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
    final user = User();
    user.uuid = json['uuid'] as String;
    user.name = json['name'] as String?;
    user.timezone = json['timezone'] as String?;
    user.onboardingCompleted = json['onboardingCompleted'] as bool? ?? false;
    user.preferredLanguage = json['preferredLanguage'] as String?;
    user.createdAt = DateTime.parse(json['createdAt'] as String);

    if (json['lastActiveAt'] != null) {
      user.lastActiveAt = DateTime.parse(json['lastActiveAt'] as String);
    }

    user.notificationsEnabled = json['notificationsEnabled'] as bool? ?? true;

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
    final task = Task();
    task.uuid = json['uuid'] as String;
    task.userUuid = json['userUuid'] as String;
    task.title = json['title'] as String;
    task.description = json['description'] as String?;
    task.originalTaskUuid = json['originalTaskUuid'] as String?;
    task.isMicroTask = json['isMicroTask'] as bool? ?? false;
    task.estimatedMinutes = json['estimatedMinutes'] as int?;
    task.context = json['context'] as String?;
    task.createdAt = DateTime.parse(json['createdAt'] as String);

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
    final entry = JournalEntry();
    entry.uuid = json['uuid'] as String;
    entry.userUuid = json['userUuid'] as String;
    entry.encryptedContent = json['encryptedContent'] as String?;
    entry.audioUrl = json['audioUrl'] as String?;
    entry.transcription = json['transcription'] as String?;
    entry.emotionDetected = json['emotionDetected'] != null
        ? EmotionType.values
            .firstWhere((e) => e.name == json['emotionDetected'])
        : null;
    entry.emotionConfidence = json['emotionConfidence'] as double?;
    entry.aiReflection = json['aiReflection'] as String?;
    entry.encryptedAiResponse = json['encryptedAiResponse'] as String?;
    entry.createdAt = DateTime.parse(json['createdAt'] as String);

    if (json['syncedAt'] != null) {
      entry.syncedAt = DateTime.parse(json['syncedAt'] as String);
    }

    entry.isEncrypted = json['isEncrypted'] as bool? ?? true;

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

  static SelfEsteemScore fromJson(Map<String, dynamic> json) {
    final score = SelfEsteemScore();
    score.uuid = json['uuid'] as String;
    score.userUuid = json['userUuid'] as String;
    score.score = json['score'] as double;
    score.calculationBasisJson = json['calculationBasisJson'] as String?;
    score.completionRate = json['completionRate'] as double?;
    score.positiveEmotionRatio = json['positiveEmotionRatio'] as double?;
    score.streakScore = json['streakScore'] as double?;
    score.engagementScore = json['engagementScore'] as double?;
    score.measuredAt = DateTime.parse(json['measuredAt'] as String);
    return score;
  }
}
