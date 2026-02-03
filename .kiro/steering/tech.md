# 技術スタック

## フレームワーク & 言語

- **Flutter** 3.10.0+ (マルチプラットフォーム: iOS, Android, Web, Desktop)
- **Dart** 3.0.0+
- 主要ロケール: 日本語 (`ja`)

## コア依存関係

### データ & ストレージ
- **Isar Database** 3.1.0+ - 高性能NoSQLローカルデータベース（ネイティブプラットフォーム）
- **Hive** 2.2.3+ - キーバリューストレージ（Webプラットフォーム）
- **flutter_secure_storage** 9.0.0+ - セキュアな認証情報ストレージ
- **path_provider** - ファイルシステムアクセス

### バックエンド & 同期
- **Supabase Flutter** 2.3.4+ - リアルタイム同期機能付きPostgreSQLバックエンド
- **http** 1.1.0+ - API呼び出し用HTTPクライアント

### セキュリティ
- **encrypt** 5.0.1+ - AES-256暗号化
- **crypto** 3.0.3+ - 暗号化操作

### UI & 可視化
- **fl_chart** 0.68.0+ - チャートとデータ可視化
- **lottie** 2.7.0+ - アニメーション（紙吹雪、キラキラ、炎）
- **provider** 6.0.5+ - 状態管理

### オーディオ & 音声
- **record** 5.0.4+ - 音声録音
- **audioplayers** 5.2.1+ - 音声再生

### ユーティリティ
- **connectivity_plus** 5.0.2+ - ネットワーク状態監視
- **flutter_local_notifications** 16.3.2+ - ローカル通知
- **flutter_dotenv** 5.1.0+ - 環境変数管理
- **timezone** 0.9.2+ - タイムゾーン処理
- **uuid** 4.0.0+ - UUID生成

## コード生成

- **build_runner** 2.4.7+ - コード生成ランナー
- **json_serializable** 6.7.1+ - JSONシリアライゼーション
- **isar_generator** 3.1.0+ - Isarモデル生成

コード生成の実行:
```bash
flutter packages pub run build_runner build
```

開発中のウォッチモード:
```bash
flutter packages pub run build_runner watch
```

## テスト

- **flutter_test** - ユニットテストとウィジェットテスト
- **mockito** 5.4.2+ - モックフレームワーク

### テストコマンド

```bash
# 全テストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/core/services/act_dialogue_engine_test.dart

# カバレッジ付きでテストを実行
flutter test --coverage

# プロパティベーステストを実行
flutter test test/core/services/
```

## ビルド & 実行コマンド

```bash
# 依存関係をインストール
flutter pub get

# アプリを実行（デバッグモード）
flutter run

# 特定のデバイスで実行
flutter run -d chrome
flutter run -d windows
flutter run -d android

# プロダクション用にビルド
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build windows      # Windows

# ビルド成果物をクリーン
flutter clean
```

## 環境設定

環境変数は `.env` と `.env.local` ファイルで管理:
- `.env.local` が `.env` より優先される
- 両ファイルは `pubspec.yaml` の assets に記載する必要がある
- 設定へのアクセスには `AppConfigService` を使用

## リンティング & コードスタイル

- **flutter_lints** 3.0.0+ - 公式Flutterリンティングルール
- 設定は `analysis_options.yaml` に記載
- 生成ファイル（`*.g.dart`, `*.freezed.dart`）は解析から除外

主要なスタイル設定:
- 文字列にはシングルクォートを優先
- 可能な限りconstコンストラクタを優先
- ローカル変数とフィールドにはfinalを優先
- シンプルな関数には式関数本体を使用
- print文を避ける（適切なロギングを使用）
- クラス内でコンストラクタを最初にソート

## プラットフォーム固有の考慮事項

### ネイティブ（iOS/Android/Desktop）
- ローカルストレージにIsar Databaseを使用
- 完全な暗号化サポート
- ネイティブファイルシステムアクセス

### Web
- ローカルストレージにHiveを使用（IndexedDB）
- セキュアストレージ機能に制限あり
- API呼び出しにCORSの考慮が必要

## アーキテクチャパターン

- **サービスベースアーキテクチャ** - Providerによる依存性注入
- **リポジトリパターン** - データアクセスの抽象化
- **Model-View分離** - プレゼンテーション層をコアロジックから分離
- サービスはアプリ起動前に `main.dart` で初期化
