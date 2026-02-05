import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'payment_service.dart';

/// Web決済の実装（Stripe統合）
/// Stripe APIを使用してWeb決済を処理
class WebPaymentService extends PaymentService {
  /// Stripe公開可能キー
  String? _publishableKey;

  /// バックエンドAPIのベースURL
  String? _backendUrl;

  /// 環境設定（サンドボックス/プロダクション）
  bool _isSandbox = false;

  /// 購入完了コールバック
  void Function(Purchase)? onPurchaseCompleted;

  /// 購入エラーコールバック
  void Function(String)? onPurchaseError;

  /// 進行中の購入
  final Set<String> _pendingPurchases = {};

  @override
  Future<void> initialize() async {
    // 環境変数から設定を読み込む
    // 実際の実装では、flutter_dotenvなどを使用
    _isSandbox = !const bool.fromEnvironment('dart.vm.product');

    if (_isSandbox) {
      // テスト環境のキー
      _publishableKey = 'pk_test_...'; // 実際のテストキーに置き換え
    } else {
      // プロダクション環境のキー
      _publishableKey = 'pk_live_...'; // 実際のライブキーに置き換え
    }

    // バックエンドAPIのURL
    _backendUrl =
        _isSandbox ? 'https://api-dev.kokosid.app' : 'https://api.kokosid.app';
  }

  @override
  Future<PaymentResult> purchaseProPlan(String userId) async {
    return _createCheckoutSession(
      userId: userId,
      productId: ProductIds.proMonthly,
      amount: 1480,
      currency: 'jpy',
      isSubscription: true,
    );
  }

  @override
  Future<PaymentResult> purchaseGems(String userId) async {
    return _createCheckoutSession(
      userId: userId,
      productId: ProductIds.gemCharge12,
      amount: 1200,
      currency: 'jpy',
      isSubscription: false,
    );
  }

  /// Stripe Checkout セッションを作成
  Future<PaymentResult> _createCheckoutSession({
    required String userId,
    required String productId,
    required int amount,
    required String currency,
    required bool isSubscription,
  }) async {
    // 既に進行中の購入があるかチェック
    if (_pendingPurchases.contains(productId)) {
      return PaymentResult.failure(
        errorMessage: 'Purchase already in progress',
        errorCode: PaymentErrorCode.paymentInProgress,
      );
    }

    _pendingPurchases.add(productId);

    try {
      // バックエンドAPIにCheckoutセッション作成をリクエスト
      final response = await http.post(
        Uri.parse('$_backendUrl/api/payments/create-checkout-session'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
          'amount': amount,
          'currency': currency,
          'is_subscription': isSubscription,
          'success_url': '${_getAppUrl()}/payment/success',
          'cancel_url': '${_getAppUrl()}/payment/cancel',
        }),
      );

      if (response.statusCode != 200) {
        _pendingPurchases.remove(productId);
        return PaymentResult.failure(
          errorMessage: 'Failed to create checkout session: ${response.body}',
          errorCode: PaymentErrorCode.providerError,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final sessionId = data['session_id'] as String;

      // Checkout URLをブラウザで開く
      // 実際の実装では、url_launcherなどを使用
      // final checkoutUrl = data['checkout_url'] as String;
      // await launchUrl(Uri.parse(checkoutUrl));

      return PaymentResult.success(
        transactionId: sessionId,
        receipt: sessionId,
        productId: productId,
        amount: amount.toDouble(),
        currency: currency,
      );
    } catch (e) {
      _pendingPurchases.remove(productId);
      return PaymentResult.failure(
        errorMessage: 'Checkout session error: $e',
        errorCode: PaymentErrorCode.unknown,
      );
    }
  }

  @override
  Future<bool> verifyReceipt(String receipt) async {
    try {
      // Stripeセッションを検証
      final response = await http.get(
        Uri.parse('$_backendUrl/api/payments/verify-session/$receipt'),
        headers: {
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['verified'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> processRefund(String transactionId) async {
    try {
      // バックエンドAPIに返金をリクエスト
      final response = await http.post(
        Uri.parse('$_backendUrl/api/payments/refund'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({
          'transaction_id': transactionId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to process refund: ${response.body}');
      }
    } catch (e) {
      throw Exception('Refund error: $e');
    }
  }

  @override
  Future<List<Purchase>> restorePurchases() async {
    try {
      // バックエンドAPIから購入履歴を取得
      final response = await http.get(
        Uri.parse('$_backendUrl/api/payments/purchases'),
        headers: {
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to restore purchases: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final purchases = data['purchases'] as List<dynamic>;

      return purchases.map((p) {
        final purchase = p as Map<String, dynamic>;
        return Purchase(
          transactionId: purchase['transaction_id'] as String,
          productId: purchase['product_id'] as String,
          purchaseDate: DateTime.parse(purchase['purchase_date'] as String),
          receipt: purchase['receipt'] as String,
          isVerified: purchase['is_verified'] as bool,
          isSubscription: purchase['is_subscription'] as bool,
          expiryDate: purchase['expiry_date'] != null
              ? DateTime.parse(purchase['expiry_date'] as String)
              : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to restore purchases: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _pendingPurchases.clear();
  }

  /// Webhookイベントを処理
  /// Stripeからのwebhookを受信して処理
  Future<void> handleWebhook(String payload, String signature) async {
    try {
      // Webhookシグネチャを検証
      if (!_verifyWebhookSignature(payload, signature)) {
        throw Exception('Invalid webhook signature');
      }

      final event = jsonDecode(payload) as Map<String, dynamic>;
      final eventType = event['type'] as String;

      switch (eventType) {
        case 'checkout.session.completed':
          await _handleCheckoutCompleted(event);
          break;
        case 'payment_intent.succeeded':
          await _handlePaymentSucceeded(event);
          break;
        case 'payment_intent.payment_failed':
          await _handlePaymentFailed(event);
          break;
        case 'customer.subscription.created':
          await _handleSubscriptionCreated(event);
          break;
        case 'customer.subscription.updated':
          await _handleSubscriptionUpdated(event);
          break;
        case 'customer.subscription.deleted':
          await _handleSubscriptionDeleted(event);
          break;
        default:
          // 未処理のイベントタイプ
          break;
      }
    } catch (e) {
      throw Exception('Webhook handling error: $e');
    }
  }

  /// Checkoutセッション完了を処理
  Future<void> _handleCheckoutCompleted(Map<String, dynamic> event) async {
    final session = event['data']['object'] as Map<String, dynamic>;
    final sessionId = session['id'] as String;

    _pendingPurchases.remove(sessionId);

    // 購入完了コールバックを呼び出す
    // 実際の実装では、Purchaseオブジェクトを作成して渡す
  }

  /// 決済成功を処理
  Future<void> _handlePaymentSucceeded(Map<String, dynamic> event) async {
    // 決済成功の処理
  }

  /// 決済失敗を処理
  Future<void> _handlePaymentFailed(Map<String, dynamic> event) async {
    final paymentIntent = event['data']['object'] as Map<String, dynamic>;
    final error = paymentIntent['last_payment_error'] as Map<String, dynamic>?;

    onPurchaseError?.call(
      'Payment failed: ${error?['message'] ?? "Unknown error"}',
    );
  }

  /// サブスクリプション作成を処理
  Future<void> _handleSubscriptionCreated(Map<String, dynamic> event) async {
    // サブスクリプション作成の処理
  }

  /// サブスクリプション更新を処理
  Future<void> _handleSubscriptionUpdated(Map<String, dynamic> event) async {
    // サブスクリプション更新の処理
  }

  /// サブスクリプション削除を処理
  Future<void> _handleSubscriptionDeleted(Map<String, dynamic> event) async {
    // サブスクリプション削除の処理
  }

  /// Webhookシグネチャを検証
  bool _verifyWebhookSignature(String payload, String signature) {
    // 実際の実装では、Stripeのシグネチャ検証アルゴリズムを使用
    // ここでは簡易的にtrueを返す
    return true;
  }

  /// 認証トークンを取得
  Future<String> _getAuthToken() async {
    // 実際の実装では、ユーザーの認証トークンを取得
    return 'dummy_token';
  }

  /// アプリのURLを取得
  String _getAppUrl() {
    return _isSandbox ? 'https://dev.kokosid.app' : 'https://kokosid.app';
  }

  /// サンドボックス環境かどうか
  bool get isSandbox => _isSandbox;

  /// 環境を切り替え（テスト用）
  set isSandbox(bool value) {
    _isSandbox = value;
  }

  /// Stripe公開可能キーを取得
  String? get publishableKey => _publishableKey;

  /// バックエンドURLを取得
  String? get backendUrl => _backendUrl;
}
