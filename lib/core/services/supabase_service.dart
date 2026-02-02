import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/task.dart';
import '../models/user.dart' as models;
import 'encryption_service.dart';

/// Supabaseクラウド同期サービス
/// エンドツーエンド暗号化データの同期とCRDT競合解決を提供
class SupabaseService {
  SupabaseService._();

  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseClient get _client => Supabase.instance.client;
  final EncryptionService _encryptionService = EncryptionService();
  bool _isInitialized = false;

  /// Supabaseサービスの初期化
  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    if (_isInitialized) {
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );

      _isInitialized = true;
    } catch (e) {
      throw SupabaseServiceException('Supabaseの初期化に失敗しました: $e');
    }
  }

  /// 匿名ユーザーとしてサインイン
  Future<void> signInAnonymously() async {
    if (!_isInitialized) {
      throw const SupabaseServiceException('Supabaseが初期化されていません');
    }

    try {
      final response = await _client.auth.signInAnonymously();
      if (response.user == null) {
        throw const SupabaseServiceException('匿名サインインに失敗しました');
      }
    } catch (e) {
      throw SupabaseServiceException('認証エラー: $e');
    }
  }

  /// 現在のユーザーIDを取得
  String? get currentUserId => _client.auth.currentUser?.id;

  /// 認証状態を確認
  bool get isAuthenticated => _client.auth.currentUser != null;

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;

  // ==================== User Sync ====================

  /// ユーザーデータを同期（アップロード）
  Future<void> syncUser(models.User user) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final data = {
        'uuid': user.uuid,
        'auth_user_id': currentUserId,
        'name': user.name,
        'timezone': user.timezone,
        'onboarding_completed': user.onboardingCompleted,
        'preferred_language': user.preferredLanguage,
        'notifications_enabled': user.notificationsEnabled,
        'created_at': user.createdAt.toIso8601String(),
        'last_active_at': user.lastActiveAt?.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('users').upsert(data);
    } catch (e) {
      throw SupabaseServiceException('ユーザーデータの同期に失敗しました: $e');
    }
  }

  /// ユーザーデータを取得（ダウンロード）
  Future<Map<String, dynamic>?> fetchUser(String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('uuid', userUuid)
          .eq('auth_user_id', currentUserId!)
          .maybeSingle();

      return response;
    } catch (e) {
      throw SupabaseServiceException('ユーザーデータの取得に失敗しました: $e');
    }
  }

  // ==================== Task Sync ====================

  /// タスクデータを同期（アップロード）
  Future<void> syncTask(Task task) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      // タスクデータを暗号化
      final encryptedTitle = _encryptionService.encrypt(task.title);
      final encryptedDescription = task.description != null
          ? _encryptionService.encrypt(task.description!)
          : null;
      final encryptedContext = task.context != null
          ? _encryptionService.encrypt(task.context!)
          : null;

      final data = {
        'uuid': task.uuid,
        'user_uuid': task.userUuid,
        'auth_user_id': currentUserId,
        'encrypted_title': encryptedTitle,
        'encrypted_description': encryptedDescription,
        'original_task_uuid': task.originalTaskUuid,
        'is_micro_task': task.isMicroTask,
        'estimated_minutes': task.estimatedMinutes,
        'encrypted_context': encryptedContext,
        'completed_at': task.completedAt?.toIso8601String(),
        'due_date': task.dueDate?.toIso8601String(),
        'priority': task.priority.name,
        'status': task.status.name,
        'created_at': task.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('tasks').upsert(data);
    } catch (e) {
      throw SupabaseServiceException('タスクデータの同期に失敗しました: $e');
    }
  }

  /// タスクデータを取得（ダウンロード）
  Future<List<Map<String, dynamic>>> fetchTasks(String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final response = await _client
          .from('tasks')
          .select()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw SupabaseServiceException('タスクデータの取得に失敗しました: $e');
    }
  }

  /// タスクを復号化
  Task decryptTask(Map<String, dynamic> data) {
    final task = Task.create(
      uuid: data['uuid'] as String,
      userUuid: data['user_uuid'] as String,
      title: _encryptionService.decrypt(data['encrypted_title'] as String),
      description: data['encrypted_description'] != null
          ? _encryptionService.decrypt(data['encrypted_description'] as String)
          : null,
      originalTaskUuid: data['original_task_uuid'] as String?,
      isMicroTask: data['is_micro_task'] as bool? ?? false,
      estimatedMinutes: data['estimated_minutes'] as int?,
      context: data['encrypted_context'] != null
          ? _encryptionService.decrypt(data['encrypted_context'] as String)
          : null,
      dueDate: data['due_date'] != null
          ? DateTime.parse(data['due_date'] as String)
          : null,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => TaskPriority.medium,
      ),
    );

    if (data['completed_at'] != null) {
      task.completedAt = DateTime.parse(data['completed_at'] as String);
    }

    task.status = TaskStatus.values.firstWhere(
      (e) => e.name == data['status'],
      orElse: () => TaskStatus.pending,
    );

    return task;
  }

  // ==================== Journal Entry Sync ====================

  /// 日記エントリを同期（アップロード）
  Future<void> syncJournalEntry(JournalEntry entry) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final data = {
        'uuid': entry.uuid,
        'user_uuid': entry.userUuid,
        'auth_user_id': currentUserId,
        'encrypted_content': entry.encryptedContent,
        'audio_url': entry.audioUrl,
        'transcription': entry.transcription,
        'emotion_detected': entry.emotionDetected?.name,
        'emotion_confidence': entry.emotionConfidence,
        'ai_reflection': entry.aiReflection,
        'encrypted_ai_response': entry.encryptedAiResponse,
        'is_encrypted': entry.isEncrypted,
        'created_at': entry.createdAt.toIso8601String(),
        'synced_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('journal_entries').upsert(data);
    } catch (e) {
      throw SupabaseServiceException('日記エントリの同期に失敗しました: $e');
    }
  }

  /// 日記エントリを取得（ダウンロード）
  Future<List<Map<String, dynamic>>> fetchJournalEntries(
      String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final response = await _client
          .from('journal_entries')
          .select()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw SupabaseServiceException('日記エントリの取得に失敗しました: $e');
    }
  }

  /// 日記エントリを復号化
  JournalEntry decryptJournalEntry(Map<String, dynamic> data) {
    final entry = JournalEntry.create(
      uuid: data['uuid'] as String,
      userUuid: data['user_uuid'] as String,
      encryptedContent: data['encrypted_content'] as String?,
      audioUrl: data['audio_url'] as String?,
      transcription: data['transcription'] as String?,
      emotionDetected: data['emotion_detected'] != null
          ? EmotionType.values.firstWhere(
              (e) => e.name == data['emotion_detected'],
              orElse: () => EmotionType.neutral,
            )
          : null,
      emotionConfidence: (data['emotion_confidence'] as num?)?.toDouble(),
      aiReflection: data['ai_reflection'] as String?,
      encryptedAiResponse: data['encrypted_ai_response'] as String?,
    );

    if (data['synced_at'] != null) {
      entry.syncedAt = DateTime.parse(data['synced_at'] as String);
    }

    return entry;
  }

  // ==================== Self Esteem Score Sync ====================

  /// 自己肯定感スコアを同期（アップロード）
  Future<void> syncSelfEsteemScore(SelfEsteemScore score) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final data = {
        'uuid': score.uuid,
        'user_uuid': score.userUuid,
        'auth_user_id': currentUserId,
        'score': score.score,
        'calculation_basis_json': score.calculationBasisJson,
        'completion_rate': score.completionRate,
        'positive_emotion_ratio': score.positiveEmotionRatio,
        'streak_score': score.streakScore,
        'engagement_score': score.engagementScore,
        'measured_at': score.measuredAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('self_esteem_scores').upsert(data);
    } catch (e) {
      throw SupabaseServiceException('自己肯定感スコアの同期に失敗しました: $e');
    }
  }

  /// 自己肯定感スコアを取得（ダウンロード）
  Future<List<Map<String, dynamic>>> fetchSelfEsteemScores(
      String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final response = await _client
          .from('self_esteem_scores')
          .select()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!)
          .order('measured_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw SupabaseServiceException('自己肯定感スコアの取得に失敗しました: $e');
    }
  }

  /// 自己肯定感スコアを復号化
  SelfEsteemScore decryptSelfEsteemScore(Map<String, dynamic> data) {
    return SelfEsteemScore.create(
      uuid: data['uuid'] as String,
      userUuid: data['user_uuid'] as String,
      score: (data['score'] as num).toDouble(),
      calculationBasisJson: data['calculation_basis_json'] as String?,
      completionRate: (data['completion_rate'] as num?)?.toDouble(),
      positiveEmotionRatio:
          (data['positive_emotion_ratio'] as num?)?.toDouble(),
      streakScore: (data['streak_score'] as num?)?.toDouble(),
      engagementScore: (data['engagement_score'] as num?)?.toDouble(),
    );
  }

  // ==================== CRDT Conflict Resolution ====================

  /// タスク完了の競合解決（Add-Wins戦略）
  /// 完了を優先する
  Future<Task> resolveTaskCompletionConflict(
    Task localTask,
    Map<String, dynamic> remoteData,
  ) async {
    final remoteTask = decryptTask(remoteData);

    // どちらかが完了している場合、完了を優先
    if (localTask.isCompleted || remoteTask.isCompleted) {
      if (localTask.isCompleted && !remoteTask.isCompleted) {
        // ローカルの完了を優先
        await syncTask(localTask);
        return localTask;
      } else if (!localTask.isCompleted && remoteTask.isCompleted) {
        // リモートの完了を優先
        return remoteTask;
      } else {
        // 両方完了している場合、早い方を優先
        if (localTask.completedAt!.isBefore(remoteTask.completedAt!)) {
          await syncTask(localTask);
          return localTask;
        } else {
          return remoteTask;
        }
      }
    }

    // どちらも未完了の場合、最新の更新を優先（Last-Write-Wins）
    final localUpdated = remoteData['updated_at'] as String?;
    if (localUpdated != null) {
      final remoteUpdatedAt = DateTime.parse(localUpdated);
      if (localTask.createdAt.isAfter(remoteUpdatedAt)) {
        await syncTask(localTask);
        return localTask;
      }
    }

    return remoteTask;
  }

  /// ユーザー設定の競合解決（Last-Write-Wins戦略）
  /// 最新の更新を優先
  Future<models.User> resolveUserSettingsConflict(
    models.User localUser,
    Map<String, dynamic> remoteData,
  ) async {
    final remoteUpdatedAt = DateTime.parse(remoteData['updated_at'] as String);
    final localUpdatedAt = localUser.lastActiveAt ?? localUser.createdAt;

    if (localUpdatedAt.isAfter(remoteUpdatedAt)) {
      // ローカルが新しい
      await syncUser(localUser);
      return localUser;
    } else {
      // リモートが新しい
      return models.User.create(
        uuid: remoteData['uuid'] as String,
        name: remoteData['name'] as String?,
        timezone: remoteData['timezone'] as String? ?? 'Asia/Tokyo',
        onboardingCompleted:
            remoteData['onboarding_completed'] as bool? ?? false,
        preferredLanguage: remoteData['preferred_language'] as String?,
      );
    }
  }

  /// 日記エントリの競合解決（Multi-Value戦略）
  /// 両方を保持する
  Future<List<JournalEntry>> resolveJournalEntryConflict(
    JournalEntry localEntry,
    Map<String, dynamic> remoteData,
  ) async {
    final remoteEntry = decryptJournalEntry(remoteData);

    // UUIDが同じ場合、内容が異なれば両方を保持
    if (localEntry.uuid == remoteEntry.uuid) {
      if (localEntry.encryptedContent != remoteEntry.encryptedContent) {
        // ローカルエントリに新しいUUIDを割り当て
        final newLocalEntry = JournalEntry.create(
          uuid: '${localEntry.uuid}_local',
          userUuid: localEntry.userUuid,
          encryptedContent: localEntry.encryptedContent,
          audioUrl: localEntry.audioUrl,
          transcription: localEntry.transcription,
          emotionDetected: localEntry.emotionDetected,
          emotionConfidence: localEntry.emotionConfidence,
          aiReflection: localEntry.aiReflection,
          encryptedAiResponse: localEntry.encryptedAiResponse,
        );

        await syncJournalEntry(newLocalEntry);
        return [newLocalEntry, remoteEntry];
      }
    }

    return [localEntry];
  }

  // ==================== Batch Operations ====================

  /// 複数のタスクを一括同期
  Future<void> syncTasksBatch(List<Task> tasks) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      for (final task in tasks) {
        await syncTask(task);
      }
    } catch (e) {
      throw SupabaseServiceException('タスクの一括同期に失敗しました: $e');
    }
  }

  /// 複数の日記エントリを一括同期
  Future<void> syncJournalEntriesBatch(List<JournalEntry> entries) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      for (final entry in entries) {
        await syncJournalEntry(entry);
      }
    } catch (e) {
      throw SupabaseServiceException('日記エントリの一括同期に失敗しました: $e');
    }
  }

  /// 全データを同期
  Future<void> syncAllData({
    models.User? user,
    List<Task>? tasks,
    List<JournalEntry>? journalEntries,
    List<SelfEsteemScore>? scores,
  }) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      if (user != null) {
        await syncUser(user);
      }

      if (tasks != null && tasks.isNotEmpty) {
        await syncTasksBatch(tasks);
      }

      if (journalEntries != null && journalEntries.isNotEmpty) {
        await syncJournalEntriesBatch(journalEntries);
      }

      if (scores != null && scores.isNotEmpty) {
        for (final score in scores) {
          await syncSelfEsteemScore(score);
        }
      }
    } catch (e) {
      throw SupabaseServiceException('全データの同期に失敗しました: $e');
    }
  }

  // ==================== Data Deletion ====================

  /// ユーザーの全データを削除
  Future<void> deleteAllUserData(String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      // タスクを削除
      await _client
          .from('tasks')
          .delete()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!);

      // 日記エントリを削除
      await _client
          .from('journal_entries')
          .delete()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!);

      // 自己肯定感スコアを削除
      await _client
          .from('self_esteem_scores')
          .delete()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!);

      // ユーザーを削除
      await _client
          .from('users')
          .delete()
          .eq('uuid', userUuid)
          .eq('auth_user_id', currentUserId!);
    } catch (e) {
      throw SupabaseServiceException('ユーザーデータの削除に失敗しました: $e');
    }
  }

  /// アカウント削除リクエストを作成
  Future<void> requestAccountDeletion(String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      final data = {
        'user_uuid': userUuid,
        'auth_user_id': currentUserId,
        'requested_at': DateTime.now().toIso8601String(),
        'scheduled_deletion_at':
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'status': 'pending',
      };

      await _client.from('deletion_requests').insert(data);
    } catch (e) {
      throw SupabaseServiceException('アカウント削除リクエストの作成に失敗しました: $e');
    }
  }

  /// アカウント削除リクエストをキャンセル
  Future<void> cancelAccountDeletion(String userUuid) async {
    _ensureInitialized();
    _ensureAuthenticated();

    try {
      await _client
          .from('deletion_requests')
          .delete()
          .eq('user_uuid', userUuid)
          .eq('auth_user_id', currentUserId!)
          .eq('status', 'pending');
    } catch (e) {
      throw SupabaseServiceException('アカウント削除リクエストのキャンセルに失敗しました: $e');
    }
  }

  // ==================== Helper Methods ====================

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw const SupabaseServiceException('Supabaseが初期化されていません');
    }
  }

  void _ensureAuthenticated() {
    if (!isAuthenticated) {
      throw const SupabaseServiceException('認証されていません');
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _client.auth.signOut();
    } catch (e) {
      throw SupabaseServiceException('サインアウトに失敗しました: $e');
    }
  }
}

/// Supabaseサービス関連の例外
class SupabaseServiceException implements Exception {
  const SupabaseServiceException(this.message);
  final String message;

  @override
  String toString() => 'SupabaseServiceException: $message';
}
