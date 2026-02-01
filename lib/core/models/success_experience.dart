import 'package:isar/isar.dart';

part 'success_experience.g.dart';

/// 成功体験モデル
@collection
class SuccessExperience {
  /// 成功体験を作成
  SuccessExperience();

  /// 名前付きコンストラクタ
  SuccessExperience.create({
    required this.uuid,
    required this.userUuid,
    required this.title,
    required this.description,
    this.taskUuid,
    this.emotionBefore,
    this.emotionAfter,
    this.lessonsLearned,
    this.tags,
  }) {
    createdAt = DateTime.now();
  }

  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String userUuid;

  /// 成功体験のタイトル
  late String title;

  /// 成功体験の詳細説明
  late String description;

  /// 関連するタスクのUUID（オプション）
  String? taskUuid;

  /// 成功前の感情状態
  String? emotionBefore;

  /// 成功後の感情状態
  String? emotionAfter;

  /// 学んだこと・気づき
  String? lessonsLearned;

  /// タグ（カンマ区切り）
  String? tags;

  /// 作成日時
  @Index()
  DateTime createdAt = DateTime.now();

  /// 最後に参照された日時
  DateTime? lastReferencedAt;

  /// 参照回数
  int referenceCount = 0;

  /// 成功体験を参照
  void reference() {
    lastReferencedAt = DateTime.now();
    referenceCount++;
  }

  /// タグのリストを取得
  List<String> get tagList {
    if (tags == null || tags!.isEmpty) {
      return [];
    }
    return tags!.split(',').map((tag) => tag.trim()).toList();
  }

  /// タグのリストを設定
  set tagList(List<String> tagList) {
    tags = tagList.join(',');
  }

  @override
  String toString() =>
      'SuccessExperience{uuid: $uuid, title: $title, createdAt: $createdAt}';
}
