import '../models/journal_entry.dart';
import '../models/task.dart';
import '../models/user.dart' as models;

/// 同期競合解決システム
/// CRDT（Conflict-free Replicated Data Type）戦略を使用して競合を解決
class ConflictResolver {
  /// 競合ログを記録
  final List<ConflictLog> _conflictLogs = [];

  /// 競合ログを取得
  List<ConflictLog> get conflictLogs => List.unmodifiable(_conflictLogs);

  /// タスク完了の競合解決（Add-Wins戦略）
  /// 完了を優先する
  Task resolveTaskCompletionConflict(
    Task localTask,
    Task remoteTask,
  ) {
    // 競合を記録
    _logConflict(ConflictLog(
      type: ConflictType.taskCompletion,
      entityId: localTask.uuid,
      strategy: ConflictStrategy.addWins,
      timestamp: DateTime.now(),
      localData: _taskToMap(localTask),
      remoteData: _taskToMap(remoteTask),
    ));

    // どちらかが完了している場合、完了を優先
    if (localTask.isCompleted || remoteTask.isCompleted) {
      if (localTask.isCompleted && !remoteTask.isCompleted) {
        // ローカルの完了を優先
        _logResolution('タスク完了の競合: ローカルの完了を優先 (${localTask.uuid})');
        return localTask;
      } else if (!localTask.isCompleted && remoteTask.isCompleted) {
        // リモートの完了を優先
        _logResolution('タスク完了の競合: リモートの完了を優先 (${remoteTask.uuid})');
        return remoteTask;
      } else {
        // 両方完了している場合、早い方を優先
        if (localTask.completedAt!.isBefore(remoteTask.completedAt!)) {
          _logResolution('タスク完了の競合: ローカルの早い完了を優先 (${localTask.uuid})');
          return localTask;
        } else {
          _logResolution('タスク完了の競合: リモートの早い完了を優先 (${remoteTask.uuid})');
          return remoteTask;
        }
      }
    }

    // どちらも未完了の場合、最新の更新を優先（Last-Write-Wins）
    if (localTask.createdAt.isAfter(remoteTask.createdAt)) {
      _logResolution('タスク競合: ローカルの最新更新を優先 (${localTask.uuid})');
      return localTask;
    } else {
      _logResolution('タスク競合: リモートの最新更新を優先 (${remoteTask.uuid})');
      return remoteTask;
    }
  }

  /// ユーザー設定の競合解決（Last-Write-Wins戦略）
  /// 最新の更新を優先
  models.User resolveUserSettingsConflict(
    models.User localUser,
    models.User remoteUser,
    DateTime remoteUpdatedAt,
  ) {
    // 競合を記録
    _logConflict(ConflictLog(
      type: ConflictType.userSettings,
      entityId: localUser.uuid,
      strategy: ConflictStrategy.lastWriteWins,
      timestamp: DateTime.now(),
      localData: _userToMap(localUser),
      remoteData: _userToMap(remoteUser),
    ));

    final localUpdatedAt = localUser.lastActiveAt ?? localUser.createdAt;

    if (localUpdatedAt.isAfter(remoteUpdatedAt)) {
      // ローカルが新しい
      _logResolution('ユーザー設定の競合: ローカルの最新更新を優先 (${localUser.uuid})');
      return localUser;
    } else {
      // リモートが新しい
      _logResolution('ユーザー設定の競合: リモートの最新更新を優先 (${remoteUser.uuid})');
      return remoteUser;
    }
  }

  /// 日記エントリの競合解決（Multi-Value戦略）
  /// 両方を保持する
  List<JournalEntry> resolveJournalEntryConflict(
    JournalEntry localEntry,
    JournalEntry remoteEntry,
  ) {
    // 競合を記録
    _logConflict(ConflictLog(
      type: ConflictType.journalEntry,
      entityId: localEntry.uuid,
      strategy: ConflictStrategy.multiValue,
      timestamp: DateTime.now(),
      localData: _journalEntryToMap(localEntry),
      remoteData: _journalEntryToMap(remoteEntry),
    ));

    // UUIDが同じ場合、内容が異なれば両方を保持
    if (localEntry.uuid == remoteEntry.uuid) {
      if (localEntry.encryptedContent != remoteEntry.encryptedContent) {
        // ローカルエントリに新しいUUIDを割り当て
        final newLocalEntry = JournalEntry.create(
          uuid:
              '${localEntry.uuid}_local_${DateTime.now().millisecondsSinceEpoch}',
          userUuid: localEntry.userUuid,
          encryptedContent: localEntry.encryptedContent,
          audioUrl: localEntry.audioUrl,
          transcription: localEntry.transcription,
          emotionDetected: localEntry.emotionDetected,
          emotionConfidence: localEntry.emotionConfidence,
          aiReflection: localEntry.aiReflection,
          encryptedAiResponse: localEntry.encryptedAiResponse,
        );

        _logResolution('日記エントリの競合: 両方を保持 (${localEntry.uuid})');
        return [newLocalEntry, remoteEntry];
      }
    }

    // 内容が同じ場合はローカルのみを保持
    _logResolution('日記エントリの競合: 内容が同じためローカルを保持 (${localEntry.uuid})');
    return [localEntry];
  }

  /// タスクの一般的な競合解決（フィールド単位のマージ）
  Task resolveTaskFieldConflict(
    Task localTask,
    Task remoteTask,
  ) {
    // 競合を記録
    _logConflict(ConflictLog(
      type: ConflictType.taskField,
      entityId: localTask.uuid,
      strategy: ConflictStrategy.fieldMerge,
      timestamp: DateTime.now(),
      localData: _taskToMap(localTask),
      remoteData: _taskToMap(remoteTask),
    ));

    // フィールド単位でマージ
    final mergedTask = Task.create(
      uuid: localTask.uuid,
      userUuid: localTask.userUuid,
      title: _selectNewerField(
        localTask.title,
        remoteTask.title,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
      description: _selectNewerField(
        localTask.description,
        remoteTask.description,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
      originalTaskUuid:
          localTask.originalTaskUuid ?? remoteTask.originalTaskUuid,
      isMicroTask: localTask.isMicroTask,
      estimatedMinutes: _selectNewerField(
        localTask.estimatedMinutes,
        remoteTask.estimatedMinutes,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
      context: _selectNewerField(
        localTask.context,
        remoteTask.context,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
      dueDate: _selectNewerField(
        localTask.dueDate,
        remoteTask.dueDate,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
      priority: _selectNewerField(
        localTask.priority,
        remoteTask.priority,
        localTask.createdAt,
        remoteTask.createdAt,
      ),
    );

    // 完了状態は Add-Wins 戦略
    if (localTask.isCompleted || remoteTask.isCompleted) {
      if (localTask.isCompleted) {
        mergedTask.completedAt = localTask.completedAt;
        mergedTask.status = TaskStatus.completed;
      } else {
        mergedTask.completedAt = remoteTask.completedAt;
        mergedTask.status = TaskStatus.completed;
      }
    } else {
      mergedTask.status = localTask.createdAt.isAfter(remoteTask.createdAt)
          ? localTask.status
          : remoteTask.status;
    }

    _logResolution('タスクフィールドの競合: フィールド単位でマージ (${localTask.uuid})');
    return mergedTask;
  }

  /// より新しいフィールドを選択
  T _selectNewerField<T>(
    T localValue,
    T remoteValue,
    DateTime localTimestamp,
    DateTime remoteTimestamp,
  ) {
    if (localTimestamp.isAfter(remoteTimestamp)) {
      return localValue;
    } else {
      return remoteValue;
    }
  }

  /// 競合を記録
  void _logConflict(ConflictLog log) {
    _conflictLogs.add(log);
    print('⚠️ 競合検出: ${log.type.name} - ${log.strategy.name}');
  }

  /// 解決を記録
  void _logResolution(String message) {
    print('✅ 競合解決: $message');
  }

  /// タスクをMapに変換
  Map<String, dynamic> _taskToMap(Task task) => {
        'uuid': task.uuid,
        'title': task.title,
        'description': task.description,
        'completed_at': task.completedAt?.toIso8601String(),
        'status': task.status.name,
        'created_at': task.createdAt.toIso8601String(),
      };

  /// ユーザーをMapに変換
  Map<String, dynamic> _userToMap(models.User user) => {
        'uuid': user.uuid,
        'name': user.name,
        'timezone': user.timezone,
        'onboarding_completed': user.onboardingCompleted,
        'created_at': user.createdAt.toIso8601String(),
        'last_active_at': user.lastActiveAt?.toIso8601String(),
      };

  /// 日記エントリをMapに変換
  Map<String, dynamic> _journalEntryToMap(JournalEntry entry) => {
        'uuid': entry.uuid,
        'encrypted_content': entry.encryptedContent,
        'emotion_detected': entry.emotionDetected?.name,
        'created_at': entry.createdAt.toIso8601String(),
      };

  /// 競合ログをクリア
  void clearLogs() {
    _conflictLogs.clear();
  }

  /// 競合統計を取得
  ConflictStatistics getStatistics() {
    final stats = ConflictStatistics();

    for (final log in _conflictLogs) {
      stats.totalConflicts++;

      switch (log.type) {
        case ConflictType.taskCompletion:
          stats.taskCompletionConflicts++;
          break;
        case ConflictType.userSettings:
          stats.userSettingsConflicts++;
          break;
        case ConflictType.journalEntry:
          stats.journalEntryConflicts++;
          break;
        case ConflictType.taskField:
          stats.taskFieldConflicts++;
          break;
      }

      switch (log.strategy) {
        case ConflictStrategy.addWins:
          stats.addWinsResolutions++;
          break;
        case ConflictStrategy.lastWriteWins:
          stats.lastWriteWinsResolutions++;
          break;
        case ConflictStrategy.multiValue:
          stats.multiValueResolutions++;
          break;
        case ConflictStrategy.fieldMerge:
          stats.fieldMergeResolutions++;
          break;
      }
    }

    return stats;
  }
}

/// 競合タイプ
enum ConflictType {
  taskCompletion,
  userSettings,
  journalEntry,
  taskField,
}

/// 競合解決戦略
enum ConflictStrategy {
  addWins, // 追加を優先（タスク完了など）
  lastWriteWins, // 最新の更新を優先（ユーザー設定など）
  multiValue, // 両方を保持（日記エントリなど）
  fieldMerge, // フィールド単位でマージ
}

/// 競合ログ
class ConflictLog {
  ConflictLog({
    required this.type,
    required this.entityId,
    required this.strategy,
    required this.timestamp,
    required this.localData,
    required this.remoteData,
  });

  final ConflictType type;
  final String entityId;
  final ConflictStrategy strategy;
  final DateTime timestamp;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
}

/// 競合統計
class ConflictStatistics {
  int totalConflicts = 0;
  int taskCompletionConflicts = 0;
  int userSettingsConflicts = 0;
  int journalEntryConflicts = 0;
  int taskFieldConflicts = 0;

  int addWinsResolutions = 0;
  int lastWriteWinsResolutions = 0;
  int multiValueResolutions = 0;
  int fieldMergeResolutions = 0;

  @override
  String toString() => '''
競合統計:
  総競合数: $totalConflicts
  - タスク完了: $taskCompletionConflicts
  - ユーザー設定: $userSettingsConflicts
  - 日記エントリ: $journalEntryConflicts
  - タスクフィールド: $taskFieldConflicts
  
解決戦略:
  - Add-Wins: $addWinsResolutions
  - Last-Write-Wins: $lastWriteWinsResolutions
  - Multi-Value: $multiValueResolutions
  - Field-Merge: $fieldMergeResolutions
''';
}
