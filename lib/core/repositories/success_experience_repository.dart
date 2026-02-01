import 'package:isar/isar.dart';

import '../models/success_experience.dart';

/// 成功体験リポジトリ
class SuccessExperienceRepository {
  SuccessExperienceRepository({required Isar isar}) : _isar = isar;

  final Isar _isar;

  /// 成功体験を作成
  Future<SuccessExperience> createSuccessExperience(
    SuccessExperience experience,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.successExperiences.put(experience);
    });
    return experience;
  }

  /// 成功体験を取得
  Future<SuccessExperience?> getSuccessExperience(String uuid) async {
    return _isar.successExperiences.filter().uuidEqualTo(uuid).findFirst();
  }

  /// ユーザーの全成功体験を取得
  Future<List<SuccessExperience>> getUserSuccessExperiences(
    String userUuid,
  ) async {
    return _isar.successExperiences
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// タグで成功体験を検索
  Future<List<SuccessExperience>> searchByTag(
    String userUuid,
    String tag,
  ) async {
    return _isar.successExperiences
        .filter()
        .userUuidEqualTo(userUuid)
        .tagsContains(tag)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 感情状態で成功体験を検索
  Future<List<SuccessExperience>> searchByEmotion(
    String userUuid,
    String emotion,
  ) async {
    return _isar.successExperiences
        .filter()
        .userUuidEqualTo(userUuid)
        .group((q) =>
            q.emotionBeforeContains(emotion).or().emotionAfterContains(emotion))
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 最近の成功体験を取得
  Future<List<SuccessExperience>> getRecentSuccessExperiences(
    String userUuid, {
    int limit = 10,
  }) async {
    return _isar.successExperiences
        .filter()
        .userUuidEqualTo(userUuid)
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
  }

  /// よく参照される成功体験を取得
  Future<List<SuccessExperience>> getMostReferencedSuccessExperiences(
    String userUuid, {
    int limit = 5,
  }) async {
    final experiences = await _isar.successExperiences
        .filter()
        .userUuidEqualTo(userUuid)
        .findAll();

    experiences.sort((a, b) => b.referenceCount.compareTo(a.referenceCount));
    return experiences.take(limit).toList();
  }

  /// 成功体験を更新
  Future<void> updateSuccessExperience(SuccessExperience experience) async {
    await _isar.writeTxn(() async {
      await _isar.successExperiences.put(experience);
    });
  }

  /// 成功体験を削除
  Future<void> deleteSuccessExperience(String uuid) async {
    await _isar.writeTxn(() async {
      await _isar.successExperiences.filter().uuidEqualTo(uuid).deleteFirst();
    });
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
