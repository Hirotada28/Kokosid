import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// ネットワーク状態管理サービス
/// オンライン/オフライン状態の検出と通知
class NetworkService {
  NetworkService._();

  static NetworkService? _instance;
  static NetworkService get instance => _instance ??= NetworkService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool _isOnline = true;
  final _onlineController = StreamController<bool>.broadcast();

  /// オンライン状態のストリーム
  Stream<bool> get onlineStream => _onlineController.stream;

  /// 現在のオンライン状態
  bool get isOnline => _isOnline;

  /// オフライン状態
  bool get isOffline => !_isOnline;

  /// ネットワーク監視を開始
  Future<void> initialize() async {
    // 初期状態を確認
    await _checkConnectivity();

    // 接続状態の変更を監視
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// 接続状態を確認
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      // エラー時はオフラインとみなす
      _updateOnlineStatus(false);
    }
  }

  /// 接続状態を更新
  void _updateConnectionStatus(ConnectivityResult result) {
    // 接続がある場合はオンライン
    final hasConnection = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;

    _updateOnlineStatus(hasConnection);
  }

  /// オンライン状態を更新
  void _updateOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      _onlineController.add(_isOnline);
    }
  }

  /// 手動で接続状態を再確認
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  /// サービスを破棄
  void dispose() {
    _connectivitySubscription?.cancel();
    _onlineController.close();
  }
}
