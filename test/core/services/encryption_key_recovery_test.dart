import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/services/encryption_key_recovery.dart';
import 'package:kokosid/core/services/encryption_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EncryptionKeyRecovery', () {
    late EncryptionService encryptionService;
    late EncryptionKeyRecovery recovery;

    setUp(() async {
      encryptionService = EncryptionService();
      recovery = EncryptionKeyRecovery(
        encryptionService: encryptionService,
      );
    });

    test('EncryptionKeyRecoveryインスタンスを作成できる', () {
      // Then: インスタンスが作成される
      expect(recovery, isNotNull);
      expect(recovery, isA<EncryptionKeyRecovery>());
    });

    test('EncryptionKeyRecoveryExceptionを生成できる', () {
      // When: 例外を生成
      final exception = EncryptionKeyRecoveryException('テストエラー');

      // Then: 例外が正しく生成される
      expect(exception.message, 'テストエラー');
      expect(exception.toString(), contains('EncryptionKeyRecoveryException'));
      expect(exception.toString(), contains('テストエラー'));
    });

    testWidgets('キー紛失ダイアログが表示される', (tester) async {
      // Given: テスト用のウィジェット
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await recovery.handleKeyLoss(context);
                    },
                    child: const Text('Test'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // When: ボタンをタップ
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      // Then: ダイアログが表示される
      expect(find.text('暗号化キーが見つかりません'), findsOneWidget);
      expect(find.text('続ける'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
    });

    testWidgets('キャンセルボタンで処理を中断できる', (tester) async {
      // Given: テスト用のウィジェット
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await recovery.handleKeyLoss(context);
                    },
                    child: const Text('Test'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // When: ボタンをタップしてキャンセル
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // Then: ダイアログが閉じる
      expect(find.text('暗号化キーが見つかりません'), findsNothing);
    });

    testWidgets('データ復旧不可能の警告が表示される', (tester) async {
      // Given: テスト用のウィジェット
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await recovery.handleKeyLoss(context);
                    },
                    child: const Text('Test'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // When: 最初のダイアログで続けるを選択
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('続ける'));
      await tester.pumpAndSettle();

      // Then: 警告ダイアログが表示される
      expect(find.text('重要な警告'), findsOneWidget);
      expect(find.text('以下のデータは復旧できません：'), findsOneWidget);
      expect(find.text('理解しました。続けます'), findsOneWidget);
    });
  });
}
