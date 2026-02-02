import '../models/journal_entry.dart';
import '../models/self_esteem_score.dart';
import '../models/success_experience.dart';
import '../models/task.dart';
import '../models/user.dart';

/// ローカルストレージの抽象インターフェース
/// プラットフォームに依存しない共通APIを定義
abstract class LocalStorageService {
  /// ストレージの初期化
  Future<void> initialize();

  /// ストレージを閉じる
  Future<void> close();

  /// 初期化状態を確認
  bool get isInitialized;

  /// 全データを削除
  Future<void> clearAllData();

  /// 特定ユーザーのデータを削除
  Future<void> clearUserData(String userUuid);

  /// データベースサイズ（レコード数）を取得
  Future<int> getDatabaseSize();

  // =====================
  // User操作
  // =====================

  /// ユーザーを保存（作成・更新）
  Future<User> putUser(User user);

  /// UUIDでユーザーを取得
  Future<User?> getUserByUuid(String uuid);

  /// 全ユーザーを取得
  Future<List<User>> getAllUsers();

  /// 最初のユーザーを取得
  Future<User?> getFirstUser();

  /// ユーザーを削除
  Future<bool> deleteUserByUuid(String uuid);

  // =====================
  // Task操作
  // =====================

  /// タスクを保存（作成・更新）
  Future<Task> putTask(Task task);

  /// UUIDでタスクを取得
  Future<Task?> getTaskByUuid(String uuid);

  /// ユーザーの全タスクを取得
  Future<List<Task>> getTasksByUserUuid(String userUuid);

  /// ユーザーの未完了タスクを取得
  Future<List<Task>> getPendingTasksByUserUuid(String userUuid);

  /// ユーザーの完了済みタスクを取得
  Future<List<Task>> getCompletedTasksByUserUuid(String userUuid);

  /// 今日のタスクを取得
  Future<List<Task>> getTodayTasksByUserUuid(String userUuid);

  /// マイクロタスクを取得（親タスクUUID指定）
  Future<List<Task>> getMicroTasksByOriginalUuid(String originalUuid);

  /// タスクを削除
  Future<bool> deleteTaskByUuid(String uuid);

  /// ユーザーの全タスクを削除
  Future<int> deleteAllTasksByUserUuid(String userUuid);

  /// 期間内のタスクを取得
  Future<List<Task>> getTasksByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  /// 期間内の完了タスク数を取得
  Future<int> getCompletedTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  /// 期間内の総タスク数を取得
  Future<int> getTotalTaskCountByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  // =====================
  // JournalEntry操作
  // =====================

  /// 日記エントリを保存（作成・更新）
  Future<JournalEntry> putJournalEntry(JournalEntry entry);

  /// UUIDで日記エントリを取得
  Future<JournalEntry?> getJournalEntryByUuid(String uuid);

  /// ユーザーの全日記エントリを取得
  Future<List<JournalEntry>> getJournalEntriesByUserUuid(String userUuid);

  /// ユーザーの日記エントリを期間で取得
  Future<List<JournalEntry>> getJournalEntriesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  /// 今日の日記エントリを取得
  Future<List<JournalEntry>> getTodayJournalEntriesByUserUuid(String userUuid);

  /// 日記エントリを削除
  Future<bool> deleteJournalEntryByUuid(String uuid);

  /// ユーザーの全日記エントリを削除
  Future<int> deleteAllJournalEntriesByUserUuid(String userUuid);

  // =====================
  // SelfEsteemScore操作
  // =====================

  /// 自己肯定感スコアを保存（作成・更新）
  Future<SelfEsteemScore> putSelfEsteemScore(SelfEsteemScore score);

  /// UUIDでスコアを取得
  Future<SelfEsteemScore?> getSelfEsteemScoreByUuid(String uuid);

  /// ユーザーの全スコアを取得
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuid(String userUuid);

  /// ユーザーのスコアを期間で取得
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  /// ユーザーの最新スコアを取得
  Future<SelfEsteemScore?> getLatestSelfEsteemScoreByUserUuid(String userUuid);

  /// スコアを削除
  Future<bool> deleteSelfEsteemScoreByUuid(String uuid);

  /// ユーザーの全スコアを削除
  Future<int> deleteAllSelfEsteemScoresByUserUuid(String userUuid);

  // =====================
  // SuccessExperience操作
  // =====================

  /// 成功体験を保存（作成・更新）
  Future<SuccessExperience> putSuccessExperience(SuccessExperience experience);

  /// UUIDで成功体験を取得
  Future<SuccessExperience?> getSuccessExperienceByUuid(String uuid);

  /// ユーザーの全成功体験を取得
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuid(
      String userUuid);

  /// ユーザーの成功体験を期間で取得
  Future<List<SuccessExperience>> getSuccessExperiencesByUserUuidAndDateRange(
    String userUuid,
    DateTime start,
    DateTime end,
  );

  /// 最近の成功体験を取得
  Future<List<SuccessExperience>> getRecentSuccessExperiencesByUserUuid(
    String userUuid, {
    int limit = 10,
  });

  /// タグで成功体験を検索
  Future<List<SuccessExperience>> searchSuccessExperiencesByTag(
    String userUuid,
    String tag,
  );

  /// 感情で成功体験を検索
  Future<List<SuccessExperience>> searchSuccessExperiencesByEmotion(
    String userUuid,
    String emotion,
  );

  /// 参照回数の多い成功体験を取得
  Future<List<SuccessExperience>> getMostReferencedSuccessExperiences(
    String userUuid, {
    int limit = 5,
  });

  /// 成功体験を削除
  Future<bool> deleteSuccessExperienceByUuid(String uuid);

  /// ユーザーの全成功体験を削除
  Future<int> deleteAllSuccessExperiencesByUserUuid(String userUuid);
}

/// ストレージ関連の例外
class StorageException implements Exception {
  const StorageException(this.message);
  final String message;

  @override
  String toString() => 'StorageException: $message';
}
