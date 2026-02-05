import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'payment_service.dart' as payment_svc hide ProductDetails;

/// Android Google Play Billing決済の実装
/// in_app_purchaseパッケージを使用してGoogle Play Console製品を統合
class AndroidPaymentService extends payment_svc.PaymentService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// 購入完了コールバック
  void Function(PurchaseDetails)? onPurchaseCompleted;

  /// 購入エラーコールバック
  void Function(String)? onPurchaseError;

  /// 環境設定（サンドボックス/プロダクション）
  bool _isSandbox = false;

  /// 利用可能な製品
  Map<String, ProductDetails> _products = {};

  /// 進行中の購入
  final Set<String> _pendingPurchases = {};

  @override
  Future<void> initialize() async {
    // プラットフォームチェック
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'AndroidPaymentService is only supported on Android',
      );
    }

    // Android固有の設定
    if (InAppPurchase.instance is InAppPurchaseAndroidPlatformAddition) {
      // 保留中の購入を有効化（Android 3.0以降は不要だが互換性のため残す）
      // final androidAddition =
      //     InAppPurchase.instance as InAppPurchaseAndroidPlatformAddition;
      // await androidAddition.enablePendingPurchases();
    }

    // 購入可能かチェック
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchases are not available on this device');
    }

    // 購入ストリームをリッスン
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        onPurchaseError?.call('Purchase stream error: $error');
      },
    );

    // 製品情報を取得
    await _loadProducts();

    // 環境を検出（サンドボックスかプロダクションか）
    await _detectEnvironment();
  }

  /// 製品情報を読み込む
  Future<void> _loadProducts() async {
    final productIds = payment_svc.ProductIds.all.toSet();
    final response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.error != null) {
      throw Exception('Failed to load products: ${response.error}');
    }

    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Products not found: ${response.notFoundIDs}');
    }

    _products = {
      for (final product in response.productDetails) product.id: product,
    };
  }

  /// 環境を検出（サンドボックスかプロダクションか）
  Future<void> _detectEnvironment() async {
    // Androidでは、テストアカウントを使用している場合はサンドボックス
    // 実際の実装では、ビルド設定やテストアカウントの有無で判定
    _isSandbox = !const bool.fromEnvironment('dart.vm.product');
  }

  /// 購入更新を処理
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  /// 個別の購入を処理
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    // 進行中の購入から削除
    _pendingPurchases.remove(purchaseDetails.productID);

    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // 購入成功
      onPurchaseCompleted?.call(purchaseDetails);

      // トランザクションを完了
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      // 購入エラー
      final error = purchaseDetails.error;
      onPurchaseError?.call(
        'Purchase failed: ${error?.message ?? "Unknown error"}',
      );
    } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      // ユーザーがキャンセル
      onPurchaseError?.call('Purchase cancelled by user');
    } else if (purchaseDetails.status == PurchaseStatus.pending) {
      // 保留中（Androidの場合、支払い方法の確認待ちなど）
      // 何もしない（後で完了通知が来る）
    }
  }

  @override
  Future<payment_svc.PaymentResult> purchaseProPlan(String userId) async {
    return _purchaseProduct(payment_svc.ProductIds.proMonthly);
  }

  @override
  Future<payment_svc.PaymentResult> purchaseGems(String userId) async {
    return _purchaseProduct(payment_svc.ProductIds.gemCharge12);
  }

  /// 製品を購入
  Future<payment_svc.PaymentResult> _purchaseProduct(String productId) async {
    // 既に進行中の購入があるかチェック
    if (_pendingPurchases.contains(productId)) {
      return payment_svc.PaymentResult.failure(
        errorMessage: 'Purchase already in progress',
        errorCode: payment_svc.PaymentErrorCode.paymentInProgress,
      );
    }

    // 製品情報を取得
    final product = _products[productId];
    if (product == null) {
      return payment_svc.PaymentResult.failure(
        errorMessage: 'Product not found: $productId',
        errorCode: payment_svc.PaymentErrorCode.productNotFound,
      );
    }

    // 購入を開始
    _pendingPurchases.add(productId);

    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      final success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        _pendingPurchases.remove(productId);
        return payment_svc.PaymentResult.failure(
          errorMessage: 'Failed to initiate purchase',
          errorCode: payment_svc.PaymentErrorCode.providerError,
        );
      }

      // 購入結果は_onPurchaseUpdateで処理される
      // ここでは購入開始の成功を返す
      return payment_svc.PaymentResult.success(
        transactionId: 'pending',
        receipt: 'pending',
        productId: productId,
      );
    } catch (e) {
      _pendingPurchases.remove(productId);
      return payment_svc.PaymentResult.failure(
        errorMessage: 'Purchase error: $e',
        errorCode: payment_svc.PaymentErrorCode.unknown,
      );
    }
  }

  @override
  Future<bool> verifyReceipt(String receipt) async {
    try {
      // Google Play レシート検証
      // 実際の実装では、バックエンドサーバーでレシート検証を行う
      // Google Play Developer APIを使用してレシートを検証

      // セキュリティ上の理由から、実際にはバックエンドサーバーで検証すべき
      // ここでは簡易的にtrueを返す
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> processRefund(String transactionId) async {
    // Android では、返金はGoogle Play Consoleから手動で処理される
    // アプリ側では返金を直接処理できない
    // ここでは、バックエンドに返金リクエストを送信する処理を想定
    throw UnimplementedError(
      'Refunds must be processed through Google Play Console',
    );
  }

  @override
  Future<List<payment_svc.Purchase>> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();

      // 復元された購入は_onPurchaseUpdateで処理される
      // ここでは空のリストを返す（実際の購入はコールバックで処理）
      return [];
    } catch (e) {
      throw Exception('Failed to restore purchases: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _pendingPurchases.clear();
  }

  /// 製品情報を取得
  ProductDetails? getProduct(String productId) {
    return _products[productId];
  }

  /// すべての製品情報を取得
  List<ProductDetails> getAllProducts() {
    return _products.values.toList();
  }

  /// サンドボックス環境かどうか
  bool get isSandbox => _isSandbox;

  /// 環境を切り替え（テスト用）
  set isSandbox(bool value) {
    _isSandbox = value;
  }

  /// 保留中の購入を確認
  /// Androidでは、支払い方法の確認待ちなどで購入が保留される場合がある
  Future<List<PurchaseDetails>> checkPendingPurchases() async {
    if (InAppPurchase.instance is InAppPurchaseAndroidPlatformAddition) {
      final androidAddition =
          InAppPurchase.instance as InAppPurchaseAndroidPlatformAddition;

      // 保留中の購入を取得
      final response = await androidAddition.queryPastPurchases();
      return response.pastPurchases
          .where((p) => p.status == PurchaseStatus.pending)
          .toList();
    }

    return [];
  }

  /// 消費型製品を消費
  /// ジェムなどの消費型アイテムの場合に使用
  Future<void> consumePurchase(PurchaseDetails purchaseDetails) async {
    if (InAppPurchase.instance is InAppPurchaseAndroidPlatformAddition) {
      final androidAddition =
          InAppPurchase.instance as InAppPurchaseAndroidPlatformAddition;

      // 購入を消費
      await androidAddition.consumePurchase(purchaseDetails);
    }
  }
}
