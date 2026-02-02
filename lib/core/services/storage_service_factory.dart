import 'package:flutter/foundation.dart' show kIsWeb;

import 'local_storage_service.dart';

// 条件付きインポート: プラットフォームに応じた実装を選択
import 'storage_service_native.dart'
    if (dart.library.html) 'storage_service_web.dart' as platform_storage;

/// プラットフォームに応じたストレージサービスを提供するファクトリー
class StorageServiceFactory {
  static LocalStorageService? _instance;

  /// シングルトンインスタンスを取得
  /// Web環境ではWebStorageService、それ以外ではIsarStorageServiceを返す
  static LocalStorageService get instance {
    _instance ??= platform_storage.createStorageService();
    return _instance!;
  }

  /// インスタンスをリセット（テスト用）
  static void resetInstance() {
    _instance = null;
  }

  /// 明示的にインスタンスを設定（テスト用）
  static void setInstance(LocalStorageService service) {
    _instance = service;
  }

  /// 現在のプラットフォームがWebかどうか
  static bool get isWeb => kIsWeb;
}
