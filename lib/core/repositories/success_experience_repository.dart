import '../models/success_experience.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';

/// 成功体験リポジトリ
class SuccessExperienceRepository {
  SuccessExperienceRepository({required DatabaseService databaseService})
      : _storage = databaseService.storage;

  final LocalStorageService _storage;

  /// 成功体験を作成
  Future<SuccessExperience> createSuccessExperience(
    SuccessExperience experience,
  ) async =>
      _storage.putSuccessExperience(experience);

  /// 成功体験を取得
  Future<SuccessExperience?> getSuccessExperience(String uuid) async =>
      _storage.getSuccessExperienceByUuid(uuid);

  /// ユーザーの全成功体験を取得
  Future<List<SuccessExperience>> getUserSuccessExperiences(
    String userUuid,
  ) async =>
      _storage.getSuccessExperiencesByUserUuid(userUuid);

  /// タグで成功体験を検索
  Future<List<SuccessExperience>> searchByTag(
    String userUuid,
    String tag,
  ) async =>
      _storage.searchSuccessExperiencesByTag(userUuid, tag);

  /// 感情状態で成功体験を検索
  Future<List<SuccessExperience>> searchByEmotion(
    String userUuid,
    String emotion,
  ) async =>
      _storage.searchSuccessExperiencesByEmotion(userUuid, emotion);

  /// 最近の成功体験を取得
  Future<List<SuccessExperience>> getRecentSuccessExperiences(
    String userUuid, {
    int limit = 10,
  }) async =>
      _storage.getRecentSuccessExperiencesByUserUuid(userUuid, limit: limit);

  /// よく参照される成功体験を取得
  Future<List<SuccessExperience>> getMostReferencedSuccessExperiences(
    String userUuid, {
    int limit = 5,
  }) async =>
      _storage.getMostReferencedSuccessExperiences(userUuid, limit: limit);

  /// 成功体験を更新
  Future<void> updateSuccessExperience(SuccessExperience experience) async {
    await _storage.putSuccessExperience(experience);
  }

  /// 成功体験を削除
  Future<void> deleteSuccessExperience(String uuid) async {
    await _storage.deleteSuccessExperienceByUuid(uuid);
  }

  /// 成功体験の参照を記録
  Future<void> recordReference(String uuid) async {
    final experience = await getSuccessExperience(uuid);
    if (experience != null) {
      experience.reference();
      await updateSuccessExperience(experience);
    }
  }
}
