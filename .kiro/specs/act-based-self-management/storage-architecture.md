# ストレージアーキテクチャ設計

## 概要

Kokosidは、マルチプラットフォーム対応（Web、Android、iOS、Windows、macOS、Linux）を実現するため、プラットフォーム別のストレージ抽象化レイヤーを採用しています。

## アーキテクチャ図

```
┌─────────────────────────────────────────────────────────────┐
│                    DatabaseService                          │
│   (プラットフォーム非依存のエントリーポイント)                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  LocalStorageService                        │
│              (抽象インターフェース)                          │
│   - User, Task, JournalEntry, SelfEsteemScore CRUD         │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────┐
│   IsarStorageService    │     │   WebStorageService     │
│      (ネイティブ用)      │     │       (Web用)           │
│                         │     │                         │
│  ・Android              │     │  ・Flutter Web          │
│  ・iOS                  │     │  ・PWA                  │
│  ・Windows              │     │                         │
│  ・macOS                │     │  技術: Hive + IndexedDB │
│  ・Linux                │     │                         │
│                         │     │                         │
│  技術: Isar Database    │     │                         │
└─────────────────────────┘     └─────────────────────────┘
```

## プラットフォーム判定

```dart
// storage_service_factory.dart
import 'storage_service_native.dart' if (dart.library.html) 'storage_service_web.dart'
    as platform_storage;

class StorageServiceFactory {
  static LocalStorageService get instance {
    return platform_storage.createStorageService();
  }
}
```

**条件付きインポート**を使用することで、コンパイル時にプラットフォームに応じた適切な実装が選択されます。

## ストレージ実装の比較

| 特性           | Isar (ネイティブ)        | Hive (Web)     |
| -------------- | ------------------------ | -------------- |
| パフォーマンス | 非常に高速 (SQLiteの5倍) | 良好           |
| インデックス   | ネイティブサポート       | 手動実装       |
| クエリ         | 豊富なクエリビルダー     | フィルタリング |
| ストレージ     | ファイルシステム         | IndexedDB      |
| オフライン     | 完全対応                 | 完全対応       |
| 暗号化         | オプション対応           | 手動実装必要   |

## ファイル構成

```
lib/core/services/
├── local_storage_service.dart      # 抽象インターフェース
├── isar_storage_service.dart       # ネイティブ実装 (Isar)
├── web_storage_service.dart        # Web実装 (Hive)
├── storage_service_factory.dart    # ファクトリー
├── storage_service_native.dart     # ネイティブ用ファクトリ関数
├── storage_service_web.dart        # Web用ファクトリ関数
└── database_service.dart           # 統合サービス (後方互換性維持)
```

## 抽象インターフェース

```dart
abstract class LocalStorageService {
  // ライフサイクル
  Future<void> initialize();
  Future<void> close();
  bool get isInitialized;
  Future<void> clearAllData();
  Future<void> clearUserData(String userUuid);
  Future<int> getDatabaseSize();

  // User操作
  Future<User> putUser(User user);
  Future<User?> getUserByUuid(String uuid);
  Future<List<User>> getAllUsers();
  Future<User?> getFirstUser();
  Future<bool> deleteUserByUuid(String uuid);

  // Task操作
  Future<Task> putTask(Task task);
  Future<Task?> getTaskByUuid(String uuid);
  Future<List<Task>> getTasksByUserUuid(String userUuid);
  Future<List<Task>> getPendingTasksByUserUuid(String userUuid);
  Future<List<Task>> getCompletedTasksByUserUuid(String userUuid);
  Future<List<Task>> getTodayTasksByUserUuid(String userUuid);
  Future<List<Task>> getMicroTasksByOriginalUuid(String originalUuid);
  Future<bool> deleteTaskByUuid(String uuid);
  Future<int> deleteAllTasksByUserUuid(String userUuid);

  // JournalEntry操作
  Future<JournalEntry> putJournalEntry(JournalEntry entry);
  Future<JournalEntry?> getJournalEntryByUuid(String uuid);
  Future<List<JournalEntry>> getJournalEntriesByUserUuid(String userUuid);
  Future<List<JournalEntry>> getJournalEntriesByUserUuidAndDateRange(...);
  Future<List<JournalEntry>> getTodayJournalEntriesByUserUuid(String userUuid);
  Future<bool> deleteJournalEntryByUuid(String uuid);
  Future<int> deleteAllJournalEntriesByUserUuid(String userUuid);

  // SelfEsteemScore操作
  Future<SelfEsteemScore> putSelfEsteemScore(SelfEsteemScore score);
  Future<SelfEsteemScore?> getSelfEsteemScoreByUuid(String uuid);
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuid(String userUuid);
  Future<List<SelfEsteemScore>> getSelfEsteemScoresByUserUuidAndDateRange(...);
  Future<SelfEsteemScore?> getLatestSelfEsteemScoreByUserUuid(String userUuid);
  Future<bool> deleteSelfEsteemScoreByUuid(String uuid);
  Future<int> deleteAllSelfEsteemScoresByUserUuid(String userUuid);
}
```

## 移行ガイド

### 既存コード（非推奨）

```dart
// 古いパターン - Isar直接アクセス
final isar = databaseService.isar;
await isar.writeTxn(() async {
  await isar.users.put(user);
});
```

### 新しいコード（推奨）

```dart
// 新しいパターン - 抽象インターフェース経由
final storage = databaseService.storage;
await storage.putUser(user);
```

## Web版の制限事項

| 機能                 | ネイティブ | Web                   | 備考                  |
| -------------------- | ---------- | --------------------- | --------------------- |
| ローカルストレージ   | ✅         | ✅                    | 実装方法が異なる      |
| オフライン動作       | ✅         | ✅ (制限あり)         | PWA対応が必要         |
| 音声録音             | ✅         | ✅                    | MediaRecorder API使用 |
| プッシュ通知         | ✅         | ⚠️ (要Service Worker) | Web Push API          |
| 生体認証             | ✅         | ❌                    | Web非対応             |
| バックグラウンド処理 | ✅         | ❌                    | Web非対応             |

## テスト戦略

### ユニットテスト

```dart
group('LocalStorageService', () {
  late LocalStorageService storage;

  setUp(() async {
    // テスト用にインメモリ実装またはモックを使用
    StorageServiceFactory.setInstance(MockStorageService());
    storage = StorageServiceFactory.instance;
    await storage.initialize();
  });

  test('User CRUDが正常に動作する', () async {
    final user = User.create(uuid: 'test-uuid', name: 'Test User');

    // Create
    await storage.putUser(user);

    // Read
    final retrieved = await storage.getUserByUuid('test-uuid');
    expect(retrieved?.name, equals('Test User'));

    // Delete
    await storage.deleteUserByUuid('test-uuid');
    final deleted = await storage.getUserByUuid('test-uuid');
    expect(deleted, isNull);
  });
});
```

### 統合テスト

各プラットフォームで実際のストレージ実装をテスト：

```dart
// integration_test/storage_integration_test.dart
testWidgets('ストレージが正常に初期化される', (tester) async {
  final storage = StorageServiceFactory.instance;
  await storage.initialize();

  expect(storage.isInitialized, isTrue);

  await storage.close();
});
```

## 関連ドキュメント

- [データモデル設計](data-models.md)
- [エラーハンドリング](ERROR_HANDLING_SUMMARY.md)
- [要件定義](requirements.md)
