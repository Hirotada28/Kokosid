import 'dart:async';

/// 決済処理を抽象化するサービスインターフェース
/// プラットフォーム固有の実装（iOS、Android、Web）を統一的に扱う
abstract class PaymentService {
  /// 決済プロバイダーを初期化
  /// アプリ起動時に呼び出される
  Future<void> initialize();

  /// Proプランを購入
  /// 月額¥1,480のサブスクリプション
  Future<PaymentResult> purchaseProPlan(String userId);

  /// ジェムを購入
  /// ¥1,200で12 Gems
  Future<PaymentResult> purchaseGems(String userId);

  /// レシートを検証
  /// プラットフォームの検証サービスを使用
  Future<bool> verifyReceipt(String receipt);

  /// 返金を処理
  /// 購入から7日以内の返金リクエストに対応
  Future<void> processRefund(String transactionId);

  /// 購入を復元
  /// ユーザーの過去の購入履歴を取得
  Future<List<Purchase>> restorePurchases();

  /// 決済プロバイダーを破棄
  /// アプリ終了時に呼び出される
  Future<void> dispose();
}

/// 決済結果を表すクラス
class PaymentResult {
  /// 決済が成功したかどうか
  final bool success;

  /// トランザクションID（成功時）
  final String? transactionId;

  /// レシート（成功時）
  final String? receipt;

  /// エラーメッセージ（失敗時）
  final String? errorMessage;

  /// エラーコード（失敗時）
  final PaymentErrorCode? errorCode;

  /// 購入した製品ID
  final String? productId;

  /// 購入金額
  final double? amount;

  /// 通貨コード
  final String? currency;

  const PaymentResult({
    required this.success,
    this.transactionId,
    this.receipt,
    this.errorMessage,
    this.errorCode,
    this.productId,
    this.amount,
    this.currency,
  });

  /// 成功結果を作成
  factory PaymentResult.success({
    required String transactionId,
    required String receipt,
    String? productId,
    double? amount,
    String? currency,
  }) {
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      receipt: receipt,
      productId: productId,
      amount: amount,
      currency: currency,
    );
  }

  /// 失敗結果を作成
  factory PaymentResult.failure({
    required String errorMessage,
    PaymentErrorCode? errorCode,
  }) {
    return PaymentResult(
      success: false,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }
}

/// 購入情報を表すクラス
class Purchase {
  /// トランザクションID
  final String transactionId;

  /// 製品ID
  final String productId;

  /// 購入日時
  final DateTime purchaseDate;

  /// レシート
  final String receipt;

  /// 検証済みかどうか
  final bool isVerified;

  /// サブスクリプションかどうか
  final bool isSubscription;

  /// サブスクリプションの有効期限（サブスクリプションの場合）
  final DateTime? expiryDate;

  const Purchase({
    required this.transactionId,
    required this.productId,
    required this.purchaseDate,
    required this.receipt,
    required this.isVerified,
    required this.isSubscription,
    this.expiryDate,
  });
}

/// 決済エラーコード
enum PaymentErrorCode {
  /// ユーザーがキャンセル
  userCancelled,

  /// ネットワークエラー
  networkError,

  /// 決済プロバイダーエラー
  providerError,

  /// レシート検証失敗
  receiptVerificationFailed,

  /// 製品が見つからない
  productNotFound,

  /// 決済が既に進行中
  paymentInProgress,

  /// 決済が無効
  paymentInvalid,

  /// 決済が許可されていない
  paymentNotAllowed,

  /// 不明なエラー
  unknown,
}

/// 製品情報を表すクラス
class ProductDetails {
  /// 製品ID
  final String id;

  /// 製品名
  final String title;

  /// 製品説明
  final String description;

  /// 価格
  final double price;

  /// 通貨コード
  final String currencyCode;

  /// フォーマットされた価格文字列
  final String priceString;

  /// サブスクリプションかどうか
  final bool isSubscription;

  /// サブスクリプション期間（サブスクリプションの場合）
  final SubscriptionPeriod? subscriptionPeriod;

  const ProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.priceString,
    required this.isSubscription,
    this.subscriptionPeriod,
  });
}

/// サブスクリプション期間
enum SubscriptionPeriod {
  /// 月次
  monthly,

  /// 年次
  yearly,
}

/// 製品ID定数
class ProductIds {
  /// Proプラン（月額）
  static const String proMonthly = 'kokosid_pro_monthly';

  /// ジェムチャージ（12 Gems）
  static const String gemCharge12 = 'kokosid_gem_charge_12';

  /// すべての製品ID
  static const List<String> all = [
    proMonthly,
    gemCharge12,
  ];
}
