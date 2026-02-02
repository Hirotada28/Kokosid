import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/user.dart';

void main() {
  group('User Model', () {
    group('create', () {
      test('ユーザーを正常に作成できる', () {
        // Given: 新しいユーザー情報
        const uuid = 'test-uuid-123';
        const name = 'テストユーザー';

        // When: ユーザーを作成
        final user = User.create(
          uuid: uuid,
          name: name,
        );

        // Then: ユーザーが正しく作成される
        expect(user.uuid, equals(uuid));
        expect(user.name, equals(name));
        expect(user.timezone, equals('Asia/Tokyo'));
        expect(user.onboardingCompleted, isFalse);
        expect(user.preferredLanguage, equals('ja'));
        expect(user.createdAt, isNotNull);
        expect(user.lastActiveAt, isNotNull);
      });

      test('デフォルト値が正しく設定される', () {
        // Given & When: 最小限の情報でユーザーを作成
        final user = User.create(
          uuid: 'test-uuid',
        );

        // Then: デフォルト値が設定される
        expect(user.name, isNull);
        expect(user.timezone, equals('Asia/Tokyo'));
        expect(user.onboardingCompleted, isFalse);
        expect(user.preferredLanguage, equals('ja'));
        expect(user.notificationsEnabled, isTrue);
      });

      test('カスタム値が正しく設定される', () {
        // Given & When: カスタム値でユーザーを作成
        final user = User.create(
          uuid: 'test-uuid',
          name: 'カスタムユーザー',
          timezone: 'America/New_York',
          onboardingCompleted: true,
          preferredLanguage: 'en',
        );

        // Then: カスタム値が設定される
        expect(user.name, equals('カスタムユーザー'));
        expect(user.timezone, equals('America/New_York'));
        expect(user.onboardingCompleted, isTrue);
        expect(user.preferredLanguage, equals('en'));
      });
    });

    group('updateLastActive', () {
      test('最終アクティブ時刻を更新できる', () {
        // Given: 作成されたユーザー
        final user = User.create(uuid: 'test-uuid');
        final beforeUpdate = user.lastActiveAt;

        // When: 最終アクティブ時刻を更新
        user.updateLastActive();

        // Then: 最終アクティブ時刻が更新される
        expect(user.lastActiveAt, isNotNull);
        expect(
          user.lastActiveAt!.isAfter(beforeUpdate!) ||
              user.lastActiveAt!.isAtSameMomentAs(beforeUpdate),
          isTrue,
        );
      });
    });

    group('completeOnboarding', () {
      test('オンボーディング完了をマークできる', () {
        // Given: オンボーディング未完了のユーザー
        final user = User.create(uuid: 'test-uuid');
        expect(user.onboardingCompleted, isFalse);

        // When: オンボーディング完了をマーク
        user.completeOnboarding();

        // Then: オンボーディングが完了状態になる
        expect(user.onboardingCompleted, isTrue);
      });

      test('既に完了済みでも問題なく処理される', () {
        // Given: オンボーディング完了済みのユーザー
        final user = User.create(
          uuid: 'test-uuid',
          onboardingCompleted: true,
        );

        // When: 再度オンボーディング完了をマーク
        user.completeOnboarding();

        // Then: 完了状態が維持される
        expect(user.onboardingCompleted, isTrue);
      });
    });

    group('toString', () {
      test('適切な文字列表現を返す', () {
        // Given: ユーザー
        final user = User.create(
          uuid: 'test-uuid-123',
          name: 'テストユーザー',
        );

        // When: toString を呼び出す
        final result = user.toString();

        // Then: 適切な文字列表現が返される
        expect(result, contains('test-uuid-123'));
        expect(result, contains('テストユーザー'));
        expect(result, contains('onboardingCompleted'));
      });
    });
  });
}
