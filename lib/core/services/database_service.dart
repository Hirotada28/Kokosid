import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';

import 'local_storage_service.dart';
import 'storage_service_factory.dart';

/// ローカルデータベースサービス
/// プラットフォームに応じてIsar（ネイティブ）またはHive（Web）を使用
class DatabaseService {
  LocalStorageService? _storageService;
  bool _isInitialized = false;

  /// データベースの初期化
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Web環境の場合はHiveを初期化
      if (kIsWeb) {
        await Hive.initFlutter();
      }

      // プラットフォームに応じたストレージサービスを取得
      _storageService = StorageServiceFactory.instance;
      await _storageService!.initialize();

      _isInitialized = true;
    } catch (e) {
      throw DatabaseException('データベースの初期化に失敗しました: $e');
    }
  }

  /// ストレージサービスを取得
  LocalStorageService get storage {
    if (!_isInitialized || _storageService == null) {
      throw const DatabaseException('データベースが初期化されていません');
    }
    return _storageService!;
  }

  /// データベースを閉じる
  Future<void> close() async {
    if (_storageService != null) {
      await _storageService!.close();
      _storageService = null;
      _isInitialized = false;
    }
  }

  /// 全データを削除（アカウント削除時に使用）
  Future<void> clearAllData() async {
    if (!_isInitialized) {
      return;
    }
    await storage.clearAllData();
  }

  /// データベースサイズを取得
  Future<int> getDatabaseSize() async {
    if (!_isInitialized) {
      return 0;
    }
    return storage.getDatabaseSize();
  }

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;

  /// 特定ユーザーのデータを削除
  Future<void> clearUserData(String userUuid) async {
    if (!_isInitialized) {
      return;
    }
    await storage.clearUserData(userUuid);
  }

  /// データベース統計を取得
  Future<DatabaseStats> getStats() async {
    if (!_isInitialized) {
      return DatabaseStats(
        userCount: 0,
        taskCount: 0,
        journalEntryCount: 0,
        scoreCount: 0,
        totalSize: 0,
      );
    }

    final totalSize = await storage.getDatabaseSize();

    return DatabaseStats(
      userCount: 0, // 詳細カウントは必要に応じて実装
      taskCount: 0,
      journalEntryCount: 0,
      scoreCount: 0,
      totalSize: totalSize,
    );
  }

  /// データベースの健全性チェック
  Future<bool> performHealthCheck() async {
    try {
      if (!_isInitialized) {
        return false;
      }

      // 基本的な読み取りテスト
      await storage.getDatabaseSize();

      return true;
    } on Exception {
      return false;
    }
  }

  /// データベースの最適化
  /// ネイティブプラットフォームでのみ効果がある
  Future<void> optimize() async {
    if (!_isInitialized) {
      return;
    }

    // Web環境では最適化は不要
    if (kIsWeb) {
      return;
    }

    // ネイティブ環境での最適化
    // Isarは自動的に最適化されるため、現時点では特別な処理は不要
  }
}

/// データベース関連の例外
class DatabaseException implements Exception {
  const DatabaseException(this.message);
  final String message;

  @override
  String toString() => 'DatabaseException: $message';
}

/// データベース統計情報
class DatabaseStats {
  DatabaseStats({
    required this.userCount,
    required this.taskCount,
    required this.journalEntryCount,
    required this.scoreCount,
    required this.totalSize,
  });
  final int userCount;
  final int taskCount;
  final int journalEntryCount;
  final int scoreCount;
  final int totalSize;

  @override
  String toString() => 'DatabaseStats{users: $userCount, tasks: $taskCount, '
      'journals: $journalEntryCount, scores: $scoreCount, total: $totalSize}';
}
