import 'package:isar/isar.dart';
import '../models/user.dart';
import '../services/database_service.dart';

/// ユーザーデータリポジトリ
class UserRepository {
  UserRepository(this._databaseService);
  final DatabaseService _databaseService;

  /// ユーザーを作成
  Future<User> createUser(User user) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.users.put(user);
    });

    return user;
  }

  /// UUIDでユーザーを取得
  Future<User?> getUserByUuid(String uuid) async {
    final isar = _databaseService.isar;

    return isar.users.filter().uuidEqualTo(uuid).findFirst();
  }

  /// 全ユーザーを取得
  Future<List<User>> getAllUsers() async {
    final isar = _databaseService.isar;

    return isar.users.where().findAll();
  }

  /// ユーザーを更新
  Future<User> updateUser(User user) async {
    final isar = _databaseService.isar;

    await isar.writeTxn(() async {
      await isar.users.put(user);
    });

    return user;
  }

  /// ユーザーを削除
  Future<bool> deleteUser(String uuid) async {
    final isar = _databaseService.isar;

    return isar.writeTxn(
        () async => isar.users.filter().uuidEqualTo(uuid).deleteFirst());
  }

  /// 最初のユーザーを取得（シングルユーザーアプリの場合）
  Future<User?> getFirstUser() async {
    final isar = _databaseService.isar;

    return isar.users.where().findFirst();
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
