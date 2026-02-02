# Supabase セットアップガイド

このドキュメントでは、KokosidアプリケーションのためのSupabaseバックエンドのセットアップ手順を説明します。

## 前提条件

- Supabaseアカウント（https://supabase.com でサインアップ）
- PostgreSQL の基本知識

## セットアップ手順

### 1. Supabaseプロジェクトの作成

1. Supabaseダッシュボードにログイン
2. 「New Project」をクリック
3. プロジェクト名を入力（例: kokosid-production）
4. データベースパスワードを設定（強力なパスワードを使用）
5. リージョンを選択（日本の場合: Northeast Asia (Tokyo)）
6. 「Create new project」をクリック

### 2. データベーススキーマの適用

1. Supabaseダッシュボードで「SQL Editor」を開く
2. `supabase_schema.sql` ファイルの内容をコピー
3. SQL Editorに貼り付け
4. 「Run」をクリックしてスキーマを適用

### 3. 認証設定

#### 匿名認証の有効化

1. 「Authentication」→「Settings」を開く
2. 「Enable anonymous sign-ins」をONにする
3. 「Save」をクリック

#### Row Level Security (RLS) の確認

スキーマ適用時に自動的に設定されますが、以下を確認してください：

- 各テーブルでRLSが有効化されている
- ユーザーは自分のデータのみアクセス可能
- `auth.uid()` を使用したポリシーが適用されている

### 4. API キーの取得

1. 「Settings」→「API」を開く
2. 以下の情報をコピー：
   - Project URL
   - anon public key

### 5. Flutter アプリケーションの設定

#### 環境変数の設定

`.env` ファイルを作成（プロジェクトルート）：

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

#### アプリケーションコードでの初期化

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kokosid/core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 環境変数の読み込み
  await dotenv.load(fileName: ".env");
  
  // Supabaseの初期化
  await SupabaseService.instance.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  // 匿名サインイン
  await SupabaseService.instance.signInAnonymously();
  
  runApp(MyApp());
}
```

## データベーススキーマ

### テーブル構造

#### users テーブル
- ユーザー基本情報
- タイムゾーン、言語設定
- オンボーディング状態

#### tasks テーブル
- タスク情報（エンドツーエンド暗号化）
- タイトル、説明、コンテキストは暗号化済み
- マイクロタスク対応

#### journal_entries テーブル
- 日記エントリ（エンドツーエンド暗号化）
- 音声URL、感情分析結果
- AI応答（暗号化済み）

#### self_esteem_scores テーブル
- 自己肯定感スコア
- 計算根拠データ
- 構成要素（完了率、感情比率、継続日数、対話頻度）

#### deletion_requests テーブル
- アカウント削除リクエスト
- GDPR準拠（30日間の猶予期間）

## セキュリティ

### エンドツーエンド暗号化

- クライアント側でAES-256暗号化
- サーバーには暗号化データのみ保存
- 復号化キーはデバイスのSecure Storageに保存

### Row Level Security (RLS)

- 全テーブルでRLS有効化
- ユーザーは自分のデータのみアクセス可能
- `auth.uid()` による認証チェック

### データ削除

- 30日間の猶予期間
- 自動削除処理（`process_deletion_requests()` 関数）
- ローカルとサーバー両方から完全削除

## CRDT 競合解決戦略

### タスク完了の競合（Add-Wins）
- 完了を優先
- 両方完了の場合、早い方を優先

### ユーザー設定の競合（Last-Write-Wins）
- 最新の更新を優先
- `updated_at` タイムスタンプで判定

### 日記エントリの競合（Multi-Value）
- 両方を保持
- UUIDを変更して重複を回避

## 同期キュー

### オフライン対応

```dart
import 'package:kokosid/core/services/sync_queue_service.dart';

// データ変更をキューに追加
SyncQueueService.instance.enqueueTaskSync(task);

// オンライン復帰時に同期
final result = await SyncQueueService.instance.sync();
print('同期完了: ${result.syncedCount} 件');
```

### 自動同期

```dart
// 5分ごとに自動同期
SyncQueueService.instance.startAutoSync(
  interval: Duration(minutes: 5),
);

// 自動同期を停止
SyncQueueService.instance.stopAutoSync();
```

## トラブルシューティング

### 接続エラー

```
SupabaseServiceException: Supabaseの初期化に失敗しました
```

**解決方法:**
- Project URLとAnon Keyが正しいか確認
- ネットワーク接続を確認
- Supabaseプロジェクトが起動しているか確認

### 認証エラー

```
SupabaseServiceException: 認証されていません
```

**解決方法:**
- `signInAnonymously()` を呼び出す
- 匿名認証が有効化されているか確認

### RLSエラー

```
new row violates row-level security policy
```

**解決方法:**
- RLSポリシーが正しく設定されているか確認
- `auth_user_id` が正しく設定されているか確認

## メンテナンス

### 削除リクエストの処理

定期的に以下のSQL関数を実行：

```sql
SELECT process_deletion_requests();
```

Supabaseの「Database」→「Functions」で定期実行を設定可能。

### データベースの最適化

```sql
-- インデックスの再構築
REINDEX DATABASE postgres;

-- 統計情報の更新
ANALYZE;
```

## パフォーマンス最適化

### インデックスの確認

```sql
-- インデックスの使用状況を確認
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan;
```

### クエリパフォーマンスの分析

```sql
-- スロークエリの確認
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

## バックアップ

Supabaseは自動バックアップを提供していますが、重要なデータは定期的にエクスポートすることを推奨します。

### データエクスポート

1. Supabaseダッシュボードで「Database」→「Backups」を開く
2. 「Download backup」をクリック
3. バックアップファイルを安全な場所に保存

## サポート

問題が発生した場合：

1. Supabaseドキュメント: https://supabase.com/docs
2. Supabaseコミュニティ: https://github.com/supabase/supabase/discussions
3. プロジェクトのIssueトラッカー

## ライセンス

このスキーマとドキュメントは、Kokosidプロジェクトのライセンスに従います。
