import 'local_storage_service.dart';
import 'web_storage_service.dart';

/// Web用のストレージサービス生成
LocalStorageService createStorageService() {
  return WebStorageService();
}
