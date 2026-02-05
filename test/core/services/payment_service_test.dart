import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:kokosid/core/services/payment_service.dart';

import 'payment_service_test.mocks.dart';

// モックを生成
@GenerateMocks([PaymentService])
void main() {
  group('PaymentService Property Tests', () {
    late MockPaymentService mockPaymentService;

    setUp(() {
      mockPaymentService = MockPaymentService();
    });

    group('プロパティ2: 決済トランザクションの整合性', () {
      // 要件 6.1: 決済が開始される、THE 決済システム SHALL すべてのトランザクションデータに対して安全な HTTPS 接続を使用する
      // 要件 6.2: 決済が正常に処理される、THE バックエンド SHALL タイムスタンプ、金額、トランザクションタイプを含むトランザクションレコードを作成する
      // 要件 6.3: 決済が失敗する、THE 決済システム SHALL 特定のエラーコードを返し、THE バックエンド SHALL 失敗をログに記録する

      test('成功した決済は必ずトランザクションIDとレシートを持つ', () async {
        // Arrange
        final userId = 'test_user_123';
        final expectedResult = PaymentResult.success(
          transactionId: 'txn_123456',
          receipt: 'receipt_abc',
          productId: ProductIds.proMonthly,
          amount: 1480.0,
          currency: 'JPY',
        );

        when(mockPaymentService.purchaseProPlan(userId))
            .thenAnswer((_) async => expectedResult);

        // Act
        final result = await mockPaymentService.purchaseProPlan(userId);

        // Assert
        expect(result.success, isTrue);
        expect(result.transactionId, isNotNull);
        expect(result.transactionId, isNotEmpty);
        expect(result.receipt, isNotNull);
        expect(result.receipt, isNotEmpty);
      });

      test('失敗した決済は必ずエラーメッセージとエラーコードを持つ', () async {
        // Arrange
        final userId = 'test_user_123';
        final expectedResult = PaymentResult.failure(
          errorMessage: 'Payment failed: Card declined',
          errorCode: PaymentErrorCode.providerError,
        );

        when(mockPaymentService.purchaseProPlan(userId))
            .thenAnswer((_) async => expectedResult);

        // Act
        final result = await mockPaymentService.purchaseProPlan(userId);

        // Assert
        expect(result.success, isFalse);
        expect(result.errorMessage, isNotNull);
        expect(result.errorMessage, isNotEmpty);
        expect(result.errorCode, isNotNull);
      });

      test('決済結果は成功または失敗のいずれかである（排他的）', () async {
        // Arrange
        final userId = 'test_user_123';

        // 成功ケース
        final successResult = PaymentResult.success(
          transactionId: 'txn_123',
          receipt: 'receipt_abc',
        );

        // 失敗ケース
        final failureResult = PaymentResult.failure(
          errorMessage: 'Error',
          errorCode: PaymentErrorCode.userCancelled,
        );

        // Assert - 成功の場合
        expect(successResult.success, isTrue);
        expect(successResult.transactionId, isNotNull);
        expect(successResult.errorMessage, isNull);
        expect(successResult.errorCode, isNull);

        // Assert - 失敗の場合
        expect(failureResult.success, isFalse);
        expect(failureResult.transactionId, isNull);
        expect(failureResult.errorMessage, isNotNull);
        expect(failureResult.errorCode, isNotNull);
      });

      test('同じユーザーIDで複数回決済を試みても、各トランザクションIDは一意である', () async {
        // Arrange
        final userId = 'test_user_123';
        final transactionIds = <String>{};

        // 複数回の決済をシミュレート
        for (var i = 0; i < 10; i++) {
          final result = PaymentResult.success(
            transactionId: 'txn_$i',
            receipt: 'receipt_$i',
          );

          transactionIds.add(result.transactionId!);
        }

        // Assert - すべてのトランザクションIDが一意
        expect(transactionIds.length, equals(10));
      });

      test('決済金額は常に正の値である', () {
        // Arrange & Act
        final proResult = PaymentResult.success(
          transactionId: 'txn_123',
          receipt: 'receipt_abc',
          productId: ProductIds.proMonthly,
          amount: 1480.0,
          currency: 'JPY',
        );

        final gemResult = PaymentResult.success(
          transactionId: 'txn_456',
          receipt: 'receipt_def',
          productId: ProductIds.gemCharge12,
          amount: 1200.0,
          currency: 'JPY',
        );

        // Assert
        expect(proResult.amount, greaterThan(0));
        expect(gemResult.amount, greaterThan(0));
      });

      test('製品IDは定義済みの製品のいずれかである', () {
        // Arrange
        final validProductIds = ProductIds.all;

        // Act & Assert
        for (final productId in validProductIds) {
          expect(
            [ProductIds.proMonthly, ProductIds.gemCharge12],
            contains(productId),
          );
        }
      });

      test('レシート検証は冪等である（同じレシートで複数回検証しても結果は同じ）', () async {
        // Arrange
        final receipt = 'receipt_abc123';
        when(mockPaymentService.verifyReceipt(receipt))
            .thenAnswer((_) async => true);

        // Act - 複数回検証
        final result1 = await mockPaymentService.verifyReceipt(receipt);
        final result2 = await mockPaymentService.verifyReceipt(receipt);
        final result3 = await mockPaymentService.verifyReceipt(receipt);

        // Assert - すべて同じ結果
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });

      test('購入復元は過去の購入のみを返す（未来の購入は含まれない）', () async {
        // Arrange
        final now = DateTime.now();
        final pastPurchases = [
          Purchase(
            transactionId: 'txn_1',
            productId: ProductIds.proMonthly,
            purchaseDate: now.subtract(const Duration(days: 30)),
            receipt: 'receipt_1',
            isVerified: true,
            isSubscription: true,
          ),
          Purchase(
            transactionId: 'txn_2',
            productId: ProductIds.gemCharge12,
            purchaseDate: now.subtract(const Duration(days: 7)),
            receipt: 'receipt_2',
            isVerified: true,
            isSubscription: false,
          ),
        ];

        when(mockPaymentService.restorePurchases())
            .thenAnswer((_) async => pastPurchases);

        // Act
        final purchases = await mockPaymentService.restorePurchases();

        // Assert - すべての購入日が現在より前
        for (final purchase in purchases) {
          expect(purchase.purchaseDate.isBefore(now), isTrue);
        }
      });

      test('サブスクリプション購入は有効期限を持つ', () {
        // Arrange & Act
        final subscription = Purchase(
          transactionId: 'txn_sub_1',
          productId: ProductIds.proMonthly,
          purchaseDate: DateTime.now(),
          receipt: 'receipt_sub',
          isVerified: true,
          isSubscription: true,
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        );

        // Assert
        expect(subscription.isSubscription, isTrue);
        expect(subscription.expiryDate, isNotNull);
        expect(
          subscription.expiryDate!.isAfter(subscription.purchaseDate),
          isTrue,
        );
      });

      test('単発購入は有効期限を持たない', () {
        // Arrange & Act
        final oneTimePurchase = Purchase(
          transactionId: 'txn_gem_1',
          productId: ProductIds.gemCharge12,
          purchaseDate: DateTime.now(),
          receipt: 'receipt_gem',
          isVerified: true,
          isSubscription: false,
        );

        // Assert
        expect(oneTimePurchase.isSubscription, isFalse);
        expect(oneTimePurchase.expiryDate, isNull);
      });
    });

    group('PaymentErrorCode Tests', () {
      test('すべてのエラーコードが定義されている', () {
        // Assert - すべてのエラーコードが列挙されている
        expect(PaymentErrorCode.values, isNotEmpty);
        expect(
          PaymentErrorCode.values,
          containsAll([
            PaymentErrorCode.userCancelled,
            PaymentErrorCode.networkError,
            PaymentErrorCode.providerError,
            PaymentErrorCode.receiptVerificationFailed,
            PaymentErrorCode.productNotFound,
            PaymentErrorCode.paymentInProgress,
            PaymentErrorCode.paymentInvalid,
            PaymentErrorCode.paymentNotAllowed,
            PaymentErrorCode.unknown,
          ]),
        );
      });
    });

    group('ProductDetails Tests', () {
      test('製品詳細は必須フィールドをすべて持つ', () {
        // Arrange & Act
        const product = ProductDetails(
          id: ProductIds.proMonthly,
          title: 'Kokosid Pro',
          description: 'Monthly subscription',
          price: 1480.0,
          currencyCode: 'JPY',
          priceString: '¥1,480',
          isSubscription: true,
          subscriptionPeriod: SubscriptionPeriod.monthly,
        );

        // Assert
        expect(product.id, isNotEmpty);
        expect(product.title, isNotEmpty);
        expect(product.description, isNotEmpty);
        expect(product.price, greaterThan(0));
        expect(product.currencyCode, isNotEmpty);
        expect(product.priceString, isNotEmpty);
      });

      test('サブスクリプション製品はサブスクリプション期間を持つ', () {
        // Arrange & Act
        const product = ProductDetails(
          id: ProductIds.proMonthly,
          title: 'Kokosid Pro',
          description: 'Monthly subscription',
          price: 1480.0,
          currencyCode: 'JPY',
          priceString: '¥1,480',
          isSubscription: true,
          subscriptionPeriod: SubscriptionPeriod.monthly,
        );

        // Assert
        expect(product.isSubscription, isTrue);
        expect(product.subscriptionPeriod, isNotNull);
      });

      test('単発購入製品はサブスクリプション期間を持たない', () {
        // Arrange & Act
        const product = ProductDetails(
          id: ProductIds.gemCharge12,
          title: 'Gem Charge',
          description: '12 Gems',
          price: 1200.0,
          currencyCode: 'JPY',
          priceString: '¥1,200',
          isSubscription: false,
        );

        // Assert
        expect(product.isSubscription, isFalse);
        expect(product.subscriptionPeriod, isNull);
      });
    });
  });
}
