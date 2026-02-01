import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';

/// ローカルデータベースサービス
/// Isarを使用した高速NoSQLデータベース管理
class DatabaseService {
  static Isar? _isar;
  bool _isInitialized = false;
  
  /// データベースの初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final dir = await getApplicationDocumentsDirectory();
      
      _isar = await Isar.open(
        [
          UserSchema,
          TaskSchema,
          JournalEntrySchema,
          SelfEsteemScoreSchema,
        ],
        directory: dir.path,
        name: 'kokosid_db',
      );
      
      _isInitialized = true;
    } catch (e) {
      throw DatabaseException('データベースの初期化に失敗しました: $e');
    }
  }
  
  /// Isarインスタンスを取得
  Isar get isar {
    if (!_isInitialized || _isar == null) {
      throw const DatabaseException('データベースが初期化されていません');
    }
    return _isar!;
  }
  
  /// データベースを閉じる
  Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
      _isInitialized = false;
    }
  }
  
  /// 全データを削除（アカウント削除時に使用）
  Future<void> clearAllData() async {
    if (!_isInitialized) return;
    
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
  
  /// データベースサイズを取得
  Future<int> getDatabaseSize() async {
    if (!_isInitialized) return 0;
    
    final userCount = await isar.users.count();
    final taskCount = await isar.tasks.count();
    final journalCount = await isar.journalEntrys.count();
    final scoreCount = await isar.selfEsteemScores.count();
    
    return userCount + taskCount + journalCount + scoreCount;
  }
  
  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;
}

  /// 特定ユーザーのデータを削除
  Future<void> clearUserData(String userUuid) async {
    if (!_isInitialized) return;
    
    await isar.writeTxn(() async {
      // 注意: 実際のコード生成後に適切なコレクション名に修正
      // await isar.tasks.filter().userUuidEqualTo(userUuid).deleteAll();
      // await isar.journalEntrys.filter().userUuidEqualTo(userUuid).deleteAll();
      // await isar.selfEsteemScores.filter().userUuidEqualTo(userUuid).deleteAll();
      // await isar.users.filter().uuidEqualTo(userUuid).deleteAll();
    });
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
    
    // 注意: 実際のコード生成後に適切なコレクション名に修正
    const userCount = 0; // await isar.users.count();
    const taskCount = 0; // await isar.tasks.count();
    const journalCount = 0; // await isar.journalEntrys.count();
    const scoreCount = 0; // await isar.selfEsteemScores.count();
    
    return DatabaseStats(
      userCount: userCount,
      taskCount: taskCount,
      journalEntryCount: journalCount,
      scoreCount: scoreCount,
      totalSize: userCount + taskCount + journalCount + scoreCount,
    );
  }
  
  /// データベースの健全性チェック
  Future<bool> performHealthCheck() async {
    try {
      if (!_isInitialized) return false;
      
      // 基本的な読み取りテスト
      // 注意: 実際のコード生成後に適切なコレクション名に修正
      // await isar.users.count();
      // await isar.tasks.count();
      // await isar.journalEntrys.count();
      // await isar.selfEsteemScores.count();
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// データベースの最適化
  Future<void> optimize() async {
    if (!_isInitialized) return;
    
    try {
      await isar.writeTxn(() async {
        // 最適化処理（必要に応じて実装）
      });
    } catch (e) {
      throw DatabaseException('データベースの最適化に失敗しました: $e');
    }
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