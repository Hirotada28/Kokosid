import 'dart:async';

import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/task.dart';
import '../models/user.dart' as models;
import 'database_service.dart';
import 'local_storage_service.dart';
import 'network_service.dart';
import 'sync_queue_service.dart';

/// オフライン機能管理サービス
/// ネットワーク状態に応じた動作モードの切り替えと同期管理
class OfflineManager {
  OfflineManager._();

  static OfflineManager? _instance;
  static OfflineManager get instance => _instance ??= OfflineManager._();

  final NetworkService _networkService = NetworkService.instance;
  final SyncQueueService _syncQueue = SyncQueueService.instance;
  final DatabaseService _databaseService = DatabaseService();

  /// ストレージサービスを取得
  LocalStorageService get _storage => _databaseService.storage;

  StreamSubscription<bool>? _networkSubscription;
  bool _isInitialized = false;
  OfflineMode _currentMode = OfflineMode.online;

  /// 現在の動作モード
  OfflineMode get currentMode => _currentMode;

  /// オフラインモードかチェック
  bool get isOfflineMode => _currentMode == OfflineMode.offline;

  /// オンラインモードかチェック
  bool get isOnlineMode => _currentMode == OfflineMode.online;

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    // ネットワークサービスを初期化
    await _networkService.initialize();

    // データベースサービスを初期化
    await _databaseService.initialize();

    // 初期モードを設定
    _currentMode =
        _networkService.isOnline ? OfflineMode.online : OfflineMode.offline;

    // ネットワーク状態の変更を監視
    _networkSubscription =
        _networkService.onlineStream.listen(_onNetworkChanged);

    // 自動同期を開始
    _syncQueue.startAutoSync();

    _isInitialized = true;
  }

  /// ネットワーク状態変更時の処理
  void _onNetworkChanged(bool isOnline) {
    if (isOnline) {
      _switchToOnlineMode();
    } else {
      _switchToOfflineMode();
    }
  }

  /// オンラインモードに切り替え
  Future<void> _switchToOnlineMode() async {
    if (_currentMode == OfflineMode.online) {
      return;
    }

    _currentMode = OfflineMode.online;

    // 同期待ちデータを同期
    if (_syncQueue.queueSize > 0) {
      await _syncQueue.sync();
    }
  }

  /// オフラインモードに切り替え
  void _switchToOfflineMode() {
    if (_currentMode == OfflineMode.offline) {
      return;
    }

    _currentMode = OfflineMode.offline;
  }

  // ==================== Offline Operations ====================

  /// ユーザーデータを保存（オフライン対応）
  Future<void> saveUser(models.User user) async {
    // ローカルに保存
    await _storage.putUser(user);

    // オンラインの場合は同期キューに追加
    if (isOnlineMode) {
      _syncQueue.enqueueUserSync(user);
    } else {
      // オフラインの場合は同期待ちキューに追加
      _syncQueue.enqueueUserSync(user);
    }
  }

  /// タスクを保存（オフライン対応）
  Future<void> saveTask(Task task) async {
    // ローカルに保存
    await _storage.putTask(task);

    // 同期キューに追加
    _syncQueue.enqueueTaskSync(task);
  }

  /// 日記エントリを保存（オフライン対応）
  Future<void> saveJournalEntry(JournalEntry entry) async {
    // ローカルに保存
    await _storage.putJournalEntry(entry);

    // 同期キューに追加
    _syncQueue.enqueueJournalEntrySync(entry);
  }

  /// 自己肯定感スコアを保存（オフライン対応）
  Future<void> saveSelfEsteemScore(SelfEsteemScore score) async {
    // ローカルに保存
    await _storage.putSelfEsteemScore(score);

    // 同期キューに追加
    _syncQueue.enqueueSelfEsteemScoreSync(score);
  }

  // ==================== Offline Read Operations ====================

  /// ユーザーデータを取得（ローカルから）
  Future<models.User?> getUser(String uuid) async {
    return await _storage.getUserByUuid(uuid);
  }

  /// タスクを取得（ローカルから）
  Future<Task?> getTask(String uuid) async {
    return await _storage.getTaskByUuid(uuid);
  }

  /// ユーザーの全タスクを取得（ローカルから）
  Future<List<Task>> getUserTasks(String userUuid) async {
    return await _storage.getTasksByUserUuid(userUuid);
  }

  /// 日記エントリを取得（ローカルから）
  Future<JournalEntry?> getJournalEntry(String uuid) async {
    return await _storage.getJournalEntryByUuid(uuid);
  }

  /// ユーザーの全日記エントリを取得（ローカルから）
  Future<List<JournalEntry>> getUserJournalEntries(String userUuid) async {
    return await _storage.getJournalEntriesByUserUuid(userUuid);
  }

  /// 自己肯定感スコアを取得（ローカルから）
  Future<List<SelfEsteemScore>> getUserSelfEsteemScores(String userUuid) async {
    return await _storage.getSelfEsteemScoresByUserUuid(userUuid);
  }

  // ==================== Sync Management ====================

  /// 手動同期を実行
  Future<SyncResult> manualSync() async {
    if (isOfflineMode) {
      return SyncResult(
        success: false,
        message: 'オフラインモードです',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    return await _syncQueue.sync();
  }

  /// 同期待ちデータの数を取得
  int get pendingSyncCount => _syncQueue.queueSize;

  /// 同期中かチェック
  bool get isSyncing => _syncQueue.isSyncing;

  // ==================== Offline Status ====================

  /// オフライン機能の状態を取得
  OfflineStatus getStatus() {
    return OfflineStatus(
      mode: _currentMode,
      isOnline: _networkService.isOnline,
      pendingSyncCount: _syncQueue.queueSize,
      isSyncing: _syncQueue.isSyncing,
      lastSyncAttempt: _syncQueue.getOldestOperationTimestamp(),
    );
  }

  /// オフライン機能が正常に動作しているかチェック
  Future<bool> performHealthCheck() async {
    try {
      // データベースの健全性チェック
      final dbHealthy = await _databaseService.performHealthCheck();
      if (!dbHealthy) {
        return false;
      }

      // ネットワークサービスが初期化されているかチェック
      if (!_isInitialized) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// サービスを破棄
  void dispose() {
    _networkSubscription?.cancel();
    _syncQueue.dispose();
    _networkService.dispose();
  }
}

/// オフライン動作モード
enum OfflineMode {
  /// オンラインモード（通常動作）
  online,

  /// オフラインモード（ローカルのみ）
  offline,
}

/// オフライン機能の状態
class OfflineStatus {
  OfflineStatus({
    required this.mode,
    required this.isOnline,
    required this.pendingSyncCount,
    required this.isSyncing,
    this.lastSyncAttempt,
  });
  final OfflineMode mode;
  final bool isOnline;
  final int pendingSyncCount;
  final bool isSyncing;
  final DateTime? lastSyncAttempt;

  @override
  String toString() =>
      'OfflineStatus{mode: $mode, isOnline: $isOnline, pending: $pendingSyncCount, syncing: $isSyncing}';
}
