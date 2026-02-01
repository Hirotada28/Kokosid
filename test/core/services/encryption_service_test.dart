import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/services/encryption_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EncryptionService', () {
    late EncryptionService encryptionService;
    final mockStorage = <String, String>{};

    setUp(() {
      mockStorage.clear();
      // flutter_secure_storage のモック設定
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'read') {
            final key = methodCall.arguments['key'] as String?;
            return key != null ? mockStorage[key] : null;
          }
          if (methodCall.method == 'write') {
            final key = methodCall.arguments['key'] as String?;
            final value = methodCall.arguments['value'] as String?;
            if (key != null && value != null) {
              mockStorage[key] = value;
            }
            return null;
          }
          if (methodCall.method == 'delete') {
            final key = methodCall.arguments['key'] as String?;
            if (key != null) {
              mockStorage.remove(key);
            }
            return null;
          }
          return null;
        },
      );
      encryptionService = EncryptionService();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        null,
      );
    });

    test('初期化後に暗号化キーが存在する', () async {
      // Given: 新しい暗号化サービス
      expect(encryptionService.isInitialized, false);

      // When: 初期化を実行
      await encryptionService.initialize();

      // Then: 初期化が完了し、キーが存在する
      expect(encryptionService.isInitialized, true);
      expect(await encryptionService.hasEncryptionKey(), true);
    });

    test('データの暗号化と復号化が正しく動作する', () async {
      // Given: 初期化済みの暗号化サービス
      await encryptionService.initialize();
      const testData = 'これはテストデータです';

      // When: データを暗号化
      final encrypted = encryptionService.encrypt(testData);

      // Then: 暗号化されたデータは元データと異なる
      expect(encrypted, isNot(equals(testData)));
      expect(encrypted.isNotEmpty, true);

      // When: データを復号化
      final decrypted = encryptionService.decrypt(encrypted);

      // Then: 復号化されたデータは元データと同じ
      expect(decrypted, equals(testData));
    });

    test('JSONデータの暗号化と復号化が正しく動作する', () async {
      // Given: 初期化済みの暗号化サービス
      await encryptionService.initialize();
      final testJson = {
        'name': '太郎',
        'age': 25,
        'emotions': ['happy', 'excited'],
      };

      // When: JSONを暗号化
      final encrypted = encryptionService.encryptJson(testJson);

      // Then: 暗号化されたデータは文字列
      expect(encrypted, isA<String>());
      expect(encrypted.isNotEmpty, true);

      // When: JSONを復号化
      final decrypted = encryptionService.decryptJson(encrypted);

      // Then: 復号化されたJSONは元データと同じ
      expect(decrypted, equals(testJson));
    });

    test('ハッシュ生成が一貫している', () async {
      // Given: 初期化済みの暗号化サービス
      await encryptionService.initialize();
      const testData = 'ハッシュテストデータ';

      // When: 同じデータのハッシュを複数回生成
      final hash1 = encryptionService.generateHash(testData);
      final hash2 = encryptionService.generateHash(testData);

      // Then: ハッシュは一貫している
      expect(hash1, equals(hash2));
      expect(hash1.length, equals(64)); // SHA-256は64文字
    });

    test('初期化前の操作でエラーが発生する', () {
      // Given: 初期化されていない暗号化サービス
      expect(encryptionService.isInitialized, false);

      // When & Then: 初期化前の操作でエラーが発生
      expect(
        () => encryptionService.encrypt('test'),
        throwsA(isA<EncryptionException>()),
      );

      expect(
        () => encryptionService.decrypt('test'),
        throwsA(isA<EncryptionException>()),
      );
    });
  });
}
