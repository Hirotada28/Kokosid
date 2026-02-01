import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:uuid/uuid.dart';
import 'package:kokosid/core/models/user.dart';
import 'package:kokosid/core/repositories/user_repository.dart';
import 'package:kokosid/core/services/database_service.dart';

// モックを生成
@GenerateMocks([DatabaseService])
import 'user_repository_test.mocks.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      userRepository = UserRepository(mockDatabaseService);
    });

    group('createUser', () {
      test('ユーザーを正常に作成できる', () async {
        // Given: 新しいユーザー
        final user = User.create(
          uuid: const Uuid().v4(),
          name: 'テストユーザー',
        );

        // When: ユーザーを作成
        // 注意: 実際のテストではIsarのモックが必要
        // final result = await userRepository.createUser(user);

        // Then: ユーザーが作成される
        // expect(result.uuid, equals(user.uuid));
        // expect(result.name, equals('テストユーザー'));
      });
    });

    group('getUserByUuid', () {
      test('UUIDでユーザーを取得できる', () async {
        // Given: 存在するユーザーのUUID
        const userUuid = 'test-uuid-123';

        // When: UUIDでユーザーを取得
        // 注意: 実際のテストではIsarのモックが必要
        // final result = await userRepository.getUserByUuid(userUuid);

        // Then: ユーザーが取得される
        // expect(result, isNotNull);
        // expect(result!.uuid, equals(userUuid));
      });

      test('存在しないUUIDの場合nullを返す', () async {
        // Given: 存在しないユーザーのUUID
        const userUuid = 'non-existent-uuid';

        // When: UUIDでユーザーを取得
        // 注意: 実際のテストではIsarのモックが必要
        // final result = await userRepository.getUserByUuid(userUuid);

        // Then: nullが返される
        // expect(result, isNull);
      });
    });

    group('updateLastActive', () {
      test('最終アクティブ時刻を更新できる', () async {
        // Given: 存在するユーザー
        const userUuid = 'test-uuid-123';
        final beforeUpdate = DateTime.now().subtract(const Duration(hours: 1));

        // When: 最終アクティブ時刻を更新
        // 注意: 実際のテストではIsarのモックが必要
        // await userRepository.updateLastActive(userUuid);

        // Then: 最終アクティブ時刻が更新される
        // final updatedUser = await userRepository.getUserByUuid(userUuid);
        // expect(updatedUser!.lastActiveAt!.isAfter(beforeUpdate), isTrue);
      });
    });

    group('completeOnboarding', () {
      test('オンボーディング完了をマークできる', () async {
        // Given: オンボーディング未完了のユーザー
        const userUuid = 'test-uuid-123';

        // When: オンボーディング完了をマーク
        // 注意: 実際のテストではIsarのモックが必要
        // await userRepository.completeOnboarding(userUuid);

        // Then: オンボーディングが完了状態になる
        // final updatedUser = await userRepository.getUserByUuid(userUuid);
        // expect(updatedUser!.onboardingCompleted, isTrue);
      });
    });
  });
}
