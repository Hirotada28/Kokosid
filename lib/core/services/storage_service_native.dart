import 'local_storage_service.dart';
import 'isar_storage_service.dart';

/// ネイティブプラットフォーム用のストレージサービス生成
LocalStorageService createStorageService() => IsarStorageService();
