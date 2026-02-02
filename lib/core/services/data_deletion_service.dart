import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../repositories/journal_repository.dart';
import '../repositories/self_esteem_repository.dart';
import '../repositories/task_repository.dart';
import '../repositories/user_repository.dart';
import 'database_service.dart';
import 'encrypted_storage_service.dart';
import 'supabase_service.dart';

/// データ削除サービス
/// GDPR準拠のデータエクスポートとアカウント削除機能を提供
class DataDeletionService {
  DataDeletionService({
    required UserRepository userRepository,
    required TaskRepository taskRepository,
    required JournalRepository journalRepository,
    required SelfEsteemRepository selfEsteemRepository,
    required DatabaseService databaseService,
    required EncryptedStorageService encryptedStorageService,
    required SupabaseService supabaseService,
  })  : _userRepository = userRepository,
        _taskRepository = taskRepository,
        _journalRepository = journalRepository,
        _selfEsteemRepository = selfEsteemRepository,
        _databaseService = databaseService,
        _encryptedStorageService = encryptedStorageService,
        _supabaseService = supabaseService;

  final UserRepository _userRepository;
  final TaskRepository _taskRepository;
  final JournalRepository _journalRepository;
  final SelfEsteemRepository _selfEsteemRepository;
  final DatabaseService _databaseService;
  final EncryptedStorageService _encryptedStorageService;
  final SupabaseService _supabaseService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// GDPR準拠のデータエクスポート
  /// ユーザーの全データを人間が読める形式でエクスポート
  Future<DataExportResult> exportUserData(String userUuid) async {
    try {
      // ユーザーデータを取得
      final user = await _userRepository.getUserByUuid(userUuid);
      if (user == null) {
        throw DataDeletionException('ユーザーが見つかりません: $userUuid');
      }

      // 全データを取得
      final tasks = await _taskRepository.getTasksByUser(userUuid);
      final journalEntries =
          await _journalRepository.getEntriesByUser(userUuid);
      final scores = await _selfEsteemRepository.getScoresByUser(userUuid);

      // データを復号化してエクスポート形式に変換
      final exportData = <String, dynamic>{
        'export_info': {
          'version': '1.0',
          'exported_at': DateTime.now().toIso8601String(),
          'user_uuid': userUuid,
          'format': 'GDPR_compliant',
        },
        'user': _exportUser(user),
        'tasks': tasks.map(_exportTask).toList(),
        'journal_entries': journalEntries.map(_exportJournalEntry).toList(),
        'self_esteem_scores': scores.map(_exportSelfEsteemScore).toList(),
        'statistics': {
          'total_tasks': tasks.length,
          'completed_tasks': tasks.where((t) => t.isCompleted).length,
          'total_journal_entries': journalEntries.length,
          'total_scores': scores.length,
        },
      };

      // JSONファイルとして保存
      final file = await _saveExportToFile(exportData, userUuid);

      return DataExportResult(
        success: true,
        filePath: file.path,
        fileSize: await file.length(),
        exportedAt: DateTime.now(),
        recordCount: tasks.length + journalEntries.length + scores.length,
      );
    } catch (e) {
      throw DataDeletionException('データエクスポートに失敗しました: $e');
    }
  }

  /// ユーザーデータをエクスポート形式に変換
  Map<String, dynamic> _exportUser(User user) => {
        'uuid': user.uuid,
        'name': user.name,
        'timezone': user.timezone,
        'preferred_language': user.preferredLanguage,
        'onboarding_completed': user.onboardingCompleted,
        'notifications_enabled': user.notificationsEnabled,
        'created_at': user.createdAt.toIso8601String(),
        'last_active_at': user.lastActiveAt?.toIso8601String(),
      };

  /// タスクをエクスポート形式に変換
  Map<String, dynamic> _exportTask(Task task) => {
        'uuid': task.uuid,
        'title': task.title,
        'description': task.description,
        'is_micro_task': task.isMicroTask,
        'estimated_minutes': task.estimatedMinutes,
        'context': task.context,
        'priority': task.priority.name,
        'status': task.status.name,
        'completed_at': task.completedAt?.toIso8601String(),
        'due_date': task.dueDate?.toIso8601String(),
        'created_at': task.createdAt.toIso8601String(),
      };

  /// 日記エントリをエクスポート形式に変換（復号化済み）
  Map<String, dynamic> _exportJournalEntry(JournalEntry entry) {
    // コンテンツを復号化
    final decryptedContent =
        _encryptedStorageService.decryptJournalContent(entry);
    final decryptedAiResponse =
        _encryptedStorageService.decryptJournalAiResponse(entry);

    return {
      'uuid': entry.uuid,
      'content': decryptedContent,
      'transcription': entry.transcription,
      'emotion_detected': entry.emotionDetected?.name,
      'emotion_confidence': entry.emotionConfidence,
      'ai_response': decryptedAiResponse,
      'ai_reflection': entry.aiReflection,
      'created_at': entry.createdAt.toIso8601String(),
    };
  }

  /// 自己肯定感スコアをエクスポート形式に変換
  Map<String, dynamic> _exportSelfEsteemScore(SelfEsteemScore score) => {
        'uuid': score.uuid,
        'score': score.score,
        'completion_rate': score.completionRate,
        'positive_emotion_ratio': score.positiveEmotionRatio,
        'streak_score': score.streakScore,
        'engagement_score': score.engagementScore,
        'measured_at': score.measuredAt.toIso8601String(),
      };

  /// エクスポートデータをファイルに保存
  Future<File> _saveExportToFile(
    Map<String, dynamic> data,
    String userUuid,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'kokosid_export_${userUuid}_$timestamp.json';
    final file = File('${directory.path}/$fileName');

    // 人間が読みやすい形式でJSON保存
    final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
    await file.writeAsString(prettyJson);

    return file;
  }

  /// アカウント削除リクエストの作成
  /// 30日後に完全削除がスケジュールされる
  Future<DeletionRequestResult> requestAccountDeletion(
    String userUuid, {
    required String confirmationPassword,
  }) async {
    try {
      // セキュリティ検証: パスワード確認
      final isValid = await _verifyDeletionRequest(confirmationPassword);
      if (!isValid) {
        throw const DataDeletionException('削除確認に失敗しました');
      }

      // ユーザーが存在するか確認
      final user = await _userRepository.getUserByUuid(userUuid);
      if (user == null) {
        throw DataDeletionException('ユーザーが見つかりません: $userUuid');
      }

      // サーバー側に削除リクエストを作成
      if (_supabaseService.isInitialized && _supabaseService.isAuthenticated) {
        await _supabaseService.requestAccountDeletion(userUuid);
      }

      // ローカルに削除予定日を記録
      final scheduledDeletionDate =
          DateTime.now().add(const Duration(days: 30));
      await _secureStorage.write(
        key: 'deletion_scheduled_$userUuid',
        value: scheduledDeletionDate.toIso8601String(),
      );

      return DeletionRequestResult(
        success: true,
        scheduledDeletionDate: scheduledDeletionDate,
        message: 'アカウント削除リクエストが作成されました。'
            '30日以内にデータが完全削除されます。',
      );
    } catch (e) {
      throw DataDeletionException('削除リクエストの作成に失敗しました: $e');
    }
  }

  /// 削除リクエストのキャンセル
  Future<void> cancelDeletionRequest(String userUuid) async {
    try {
      // ローカルの削除予定を削除
      await _secureStorage.delete(key: 'deletion_scheduled_$userUuid');

      // サーバー側の削除リクエストもキャンセル
      if (_supabaseService.isInitialized && _supabaseService.isAuthenticated) {
        await _supabaseService.cancelAccountDeletion(userUuid);
      }
    } catch (e) {
      throw DataDeletionException('削除リクエストのキャンセルに失敗しました: $e');
    }
  }

  /// 削除予定日を確認
  Future<DateTime?> getScheduledDeletionDate(String userUuid) async {
    try {
      final dateString =
          await _secureStorage.read(key: 'deletion_scheduled_$userUuid');
      if (dateString == null) {
        return null;
      }
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// ローカルデータの完全削除
  Future<void> deleteLocalData(String userUuid) async {
    try {
      // 1. データベースから全データを削除
      await _databaseService.clearUserData(userUuid);

      // 2. Secure Storageから暗号化キーを削除
      await _secureStorage.delete(key: 'encryption_key_$userUuid');
      await _secureStorage.delete(key: 'deletion_scheduled_$userUuid');

      // 3. ローカルファイル（音声ファイル等）を削除
      await _deleteLocalFiles(userUuid);
    } catch (e) {
      throw DataDeletionException('ローカルデータの削除に失敗しました: $e');
    }
  }

  /// サーバーデータの完全削除
  Future<void> deleteServerData(String userUuid) async {
    try {
      if (!_supabaseService.isInitialized ||
          !_supabaseService.isAuthenticated) {
        throw const DataDeletionException('認証されていません');
      }

      // Supabaseから全データを削除
      await _supabaseService.deleteAllUserData(userUuid);
    } on Exception catch (e) {
      throw DataDeletionException('サーバーデータの削除に失敗しました: $e');
    }
  }

  /// 完全なアカウント削除（ローカル + サーバー）
  Future<CompleteDeletionResult> performCompleteDeletion(
    String userUuid,
  ) async {
    final results = <String, bool>{};

    try {
      // 1. ローカルデータを削除
      try {
        await deleteLocalData(userUuid);
        results['local_deletion'] = true;
      } catch (e) {
        results['local_deletion'] = false;
        throw DataDeletionException('ローカルデータの削除に失敗: $e');
      }

      // 2. サーバーデータを削除
      try {
        await deleteServerData(userUuid);
        results['server_deletion'] = true;
      } catch (e) {
        results['server_deletion'] = false;
        // サーバー削除失敗は警告として扱う（オフライン時等）
      }

      // 3. 削除予定記録を削除
      await _secureStorage.delete(key: 'deletion_scheduled_$userUuid');

      return CompleteDeletionResult(
        success: results['local_deletion'] == true,
        localDeleted: results['local_deletion'] ?? false,
        serverDeleted: results['server_deletion'] ?? false,
        deletedAt: DateTime.now(),
        message: _buildDeletionMessage(results),
      );
    } catch (e) {
      return CompleteDeletionResult(
        success: false,
        localDeleted: results['local_deletion'] ?? false,
        serverDeleted: results['server_deletion'] ?? false,
        deletedAt: DateTime.now(),
        message: 'データ削除中にエラーが発生しました: $e',
      );
    }
  }

  /// 削除確認のセキュリティ検証
  Future<bool> _verifyDeletionRequest(String confirmationPassword) async =>
      // 実装例: パスワードまたはPINコードの検証
      // 実際の実装では、ユーザーの認証情報と照合する
      // ここでは簡易的な実装として、空でないことを確認
      confirmationPassword.isNotEmpty;

  /// ローカルファイル（音声ファイル等）を削除
  Future<void> _deleteLocalFiles(String userUuid) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final userDir = Directory('${directory.path}/users/$userUuid');

      if (userDir.existsSync()) {
        await userDir.delete(recursive: true);
      }
    } on Exception {
      // ファイル削除エラーは警告として扱う
    }
  }

  /// 削除結果メッセージを構築
  String _buildDeletionMessage(Map<String, bool> results) {
    if (results['local_deletion'] == true &&
        results['server_deletion'] == true) {
      return 'アカウントとすべてのデータが完全に削除されました。';
    } else if (results['local_deletion'] == true) {
      return 'ローカルデータは削除されましたが、サーバーデータの削除に失敗しました。'
          'ネットワーク接続を確認して再試行してください。';
    } else {
      return 'データ削除に失敗しました。';
    }
  }

  /// 削除可能かどうかを確認
  Future<bool> canDeleteAccount(String userUuid) async {
    try {
      final user = await _userRepository.getUserByUuid(userUuid);
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// データ削除の統計情報を取得
  Future<DeletionStats> getDeletionStats(String userUuid) async {
    try {
      final tasks = await _taskRepository.getTasksByUser(userUuid);
      final journalEntries =
          await _journalRepository.getEntriesByUser(userUuid);
      final scores = await _selfEsteemRepository.getScoresByUser(userUuid);

      return DeletionStats(
        totalTasks: tasks.length,
        totalJournalEntries: journalEntries.length,
        totalScores: scores.length,
        estimatedDataSize: _estimateDataSize(
          tasks.length,
          journalEntries.length,
          scores.length,
        ),
      );
    } catch (e) {
      throw DataDeletionException('削除統計の取得に失敗しました: $e');
    }
  }

  /// データサイズを推定（KB単位）
  int _estimateDataSize(int tasks, int journals, int scores) =>
      // 概算: タスク1KB、日記5KB、スコア0.5KB
      (tasks * 1) + (journals * 5) + (scores * 1);
}

/// データエクスポート結果
class DataExportResult {
  DataExportResult({
    required this.success,
    required this.filePath,
    required this.fileSize,
    required this.exportedAt,
    required this.recordCount,
  });

  final bool success;
  final String filePath;
  final int fileSize;
  final DateTime exportedAt;
  final int recordCount;
}

/// 削除リクエスト結果
class DeletionRequestResult {
  DeletionRequestResult({
    required this.success,
    required this.scheduledDeletionDate,
    required this.message,
  });

  final bool success;
  final DateTime scheduledDeletionDate;
  final String message;
}

/// 完全削除結果
class CompleteDeletionResult {
  CompleteDeletionResult({
    required this.success,
    required this.localDeleted,
    required this.serverDeleted,
    required this.deletedAt,
    required this.message,
  });

  final bool success;
  final bool localDeleted;
  final bool serverDeleted;
  final DateTime deletedAt;
  final String message;
}

/// 削除統計情報
class DeletionStats {
  DeletionStats({
    required this.totalTasks,
    required this.totalJournalEntries,
    required this.totalScores,
    required this.estimatedDataSize,
  });

  final int totalTasks;
  final int totalJournalEntries;
  final int totalScores;
  final int estimatedDataSize; // KB単位
}

/// データ削除関連の例外
class DataDeletionException implements Exception {
  const DataDeletionException(this.message);
  final String message;

  @override
  String toString() => 'DataDeletionException: $message';
}
