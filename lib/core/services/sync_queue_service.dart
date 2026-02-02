import 'dart:async';
import 'dart:collection';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/task.dart';
import '../models/user.dart' as models;
import 'supabase_service.dart';

/// 同期待ちキュー管理サービス
/// オフライン時のデータ変更を記録し、オンライン復帰時に同期
class SyncQueueService {
  SyncQueueService._();

  static SyncQueueService? _instance;
  static SyncQueueService get instance => _instance ??= SyncQueueService._();

  final Queue<SyncOperation> _queue = Queue<SyncOperation>();
  final SupabaseService _supabaseService = SupabaseService.instance;

  bool _isSyncing = false;
  Timer? _syncTimer;

  /// 同期キューにユーザー更新を追加
  void enqueueUserSync(models.User user) {
    _queue.add(SyncOperation(
      type: SyncOperationType.user,
      data: user,
      timestamp: DateTime.now(),
    ));
  }

  /// 同期キューにタスク更新を追加
  void enqueueTaskSync(Task task) {
    _queue.add(SyncOperation(
      type: SyncOperationType.task,
      data: task,
      timestamp: DateTime.now(),
    ));
  }

  /// 同期キューに日記エントリ更新を追加
  void enqueueJournalEntrySync(JournalEntry entry) {
    _queue.add(SyncOperation(
      type: SyncOperationType.journalEntry,
      data: entry,
      timestamp: DateTime.now(),
    ));
  }

  /// 同期キューに自己肯定感スコア更新を追加
  void enqueueSelfEsteemScoreSync(SelfEsteemScore score) {
    _queue.add(SyncOperation(
      type: SyncOperationType.selfEsteemScore,
      data: score,
      timestamp: DateTime.now(),
    ));
  }

  /// キューのサイズを取得
  int get queueSize => _queue.length;

  /// キューが空かチェック
  bool get isEmpty => _queue.isEmpty;

  /// 同期中かチェック
  bool get isSyncing => _isSyncing;

  /// 同期を実行
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: '既に同期中です',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    if (_queue.isEmpty) {
      return SyncResult(
        success: true,
        message: '同期するデータがありません',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    _isSyncing = true;
    var syncedCount = 0;
    var failedCount = 0;
    final failedOperations = <SyncOperation>[];

    try {
      while (_queue.isNotEmpty) {
        final operation = _queue.removeFirst();

        try {
          await _executeSyncOperation(operation);
          syncedCount++;
        } catch (e) {
          failedCount++;
          failedOperations.add(operation);
        }
      }

      // 失敗した操作をキューに戻す
      for (final operation in failedOperations) {
        _queue.add(operation);
      }

      return SyncResult(
        success: failedCount == 0,
        message: failedCount == 0 ? '同期が完了しました' : '$failedCount 件の同期に失敗しました',
        syncedCount: syncedCount,
        failedCount: failedCount,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// 同期操作を実行
  Future<void> _executeSyncOperation(SyncOperation operation) async {
    switch (operation.type) {
      case SyncOperationType.user:
        await _supabaseService.syncUser(operation.data as models.User);
      case SyncOperationType.task:
        await _supabaseService.syncTask(operation.data as Task);
      case SyncOperationType.journalEntry:
        await _supabaseService.syncJournalEntry(operation.data as JournalEntry);
      case SyncOperationType.selfEsteemScore:
        await _supabaseService
            .syncSelfEsteemScore(operation.data as SelfEsteemScore);
    }
  }

  /// 自動同期を開始
  void startAutoSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) async {
      if (!_isSyncing && _queue.isNotEmpty) {
        await sync();
      }
    });
  }

  /// 自動同期を停止
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// キューをクリア
  void clearQueue() {
    _queue.clear();
  }

  /// キューの内容を取得（デバッグ用）
  List<SyncOperation> getQueueContents() {
    return List.from(_queue);
  }

  /// 特定タイプの操作数を取得
  int getOperationCount(SyncOperationType type) {
    return _queue.where((op) => op.type == type).length;
  }

  /// 最も古い操作のタイムスタンプを取得
  DateTime? getOldestOperationTimestamp() {
    if (_queue.isEmpty) {
      return null;
    }
    return _queue.first.timestamp;
  }

  /// サービスを破棄
  void dispose() {
    stopAutoSync();
    clearQueue();
  }
}

/// 同期操作
class SyncOperation {
  SyncOperation({
    required this.type,
    required this.data,
    required this.timestamp,
  });
  final SyncOperationType type;
  final Object data;
  final DateTime timestamp;

  @override
  String toString() => 'SyncOperation{type: $type, timestamp: $timestamp}';
}

/// 同期操作タイプ
enum SyncOperationType {
  user,
  task,
  journalEntry,
  selfEsteemScore,
}

/// 同期結果
class SyncResult {
  SyncResult({
    required this.success,
    required this.message,
    required this.syncedCount,
    required this.failedCount,
  });
  final bool success;
  final String message;
  final int syncedCount;
  final int failedCount;

  @override
  String toString() =>
      'SyncResult{success: $success, synced: $syncedCount, failed: $failedCount, message: $message}';
}
