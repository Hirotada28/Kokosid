import '../models/user.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';

/// ユーザーデータリポジトリ
class UserRepository {
  UserRepository(this._databaseService);
  final DatabaseService _databaseService;

  /// ストレージサービスを取得
  LocalStorageService get _storage => _databaseService.storage;

  /// ユーザーを作成
  Future<User> createUser(User user) async {
    await _storage.putUser(user);
    return user;
  }

  /// UUIDでユーザーを取得
  Future<User?> getUserByUuid(String uuid) async =>
      _storage.getUserByUuid(uuid);

  /// 全ユーザーを取得
  Future<List<User>> getAllUsers() async => _storage.getAllUsers();

  /// ユーザーを更新
  Future<User> updateUser(User user) async {
    await _storage.putUser(user);
    return user;
  }

  /// ユーザーを削除
  Future<bool> deleteUser(String uuid) async => _storage.deleteUserByUuid(uuid);

  /// 最初のユーザーを取得（シングルユーザーアプリの場合）
  Future<User?> getFirstUser() async {
    final users = await _storage.getAllUsers();
    return users.isEmpty ? null : users.first;
  }

  /// ユーザーの最終アクティブ時刻を更新
  Future<void> updateLastActive(String uuid) async {
    final user = await getUserByUuid(uuid);
    if (user != null) {
      user.updateLastActive();
      await updateUser(user);
    }
  }

  /// オンボーディング完了をマーク
  Future<void> completeOnboarding(String uuid) async {
    final user = await getUserByUuid(uuid);
    if (user != null) {
      user.completeOnboarding();
      await updateUser(user);
    }
  }
}
