import 'package:isar/isar.dart';

part 'user.g.dart';

/// ユーザーモデル
@collection
class User {
  // ja, en

  /// ユーザーを作成
  User();

  /// 名前付きコンストラクタ
  User.create({
    required this.uuid,
    this.name,
    this.timezone = 'Asia/Tokyo',
    this.onboardingCompleted = false,
    this.preferredLanguage = 'ja',
  }) {
    createdAt = DateTime.now();
    lastActiveAt = DateTime.now();
  }
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid; // UUID v4

  String? name;
  String? timezone; // 例: Asia/Tokyo
  bool onboardingCompleted = false;
  DateTime createdAt = DateTime.now();
  DateTime? lastActiveAt;

  // 設定
  bool notificationsEnabled = true;
  String? preferredLanguage;

  /// 最終アクティブ時刻を更新
  void updateLastActive() {
    lastActiveAt = DateTime.now();
  }

  /// オンボーディング完了
  void completeOnboarding() {
    onboardingCompleted = true;
  }

  @override
  String toString() =>
      'User{uuid: $uuid, name: $name, onboardingCompleted: $onboardingCompleted}';
}
