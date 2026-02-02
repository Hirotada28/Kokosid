# 環境変数の設定方法

このアプリケーションは `.env` と `.env.local` ファイルを使用して環境変数を管理します。

## ファイルの優先順位

1. `.env.local` - ローカル開発用（優先）
2. `.env` - デフォルト設定（テンプレート）

`.env.local` が存在する場合、そちらが優先的に読み込まれます。

## セットアップ手順

### 1. .env ファイルの作成

プロジェクトのルートディレクトリに `.env` ファイルを作成し、以下のテンプレートを使用します：

```env
# Anthropic Claude API
CLAUDE_API_KEY=

# OpenAI Whisper API
WHISPER_API_KEY=

# Supabase 設定
SUPABASE_URL=
SUPABASE_ANON_KEY=

# デバッグ設定
DEBUG_MODE=false
ENABLE_LOGGING=true
```

### 2. .env.local ファイルの作成

ローカル開発用に `.env.local` ファイルを作成し、実際のAPIキーを設定します：

```env
# Anthropic Claude API
CLAUDE_API_KEY=your-actual-claude-api-key

# OpenAI Whisper API
WHISPER_API_KEY=your-actual-whisper-api-key

# Supabase 設定
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-actual-supabase-anon-key

# デバッグ設定
DEBUG_MODE=true
ENABLE_LOGGING=true
```

### 3. Git管理

- `.env` - バージョン管理に含める（テンプレートとして）
- `.env.local` - `.gitignore` に追加済み（個人の設定を保護）

## 使用方法

### アプリケーション内での使用

```dart
import 'package:provider/provider.dart';
import 'package:kokosid/core/services/app_config_service.dart';

// Providerから取得
final config = context.read<AppConfigService>();

// APIキーの取得
final claudeKey = config.getClaudeApiKey();
final whisperKey = config.getWhisperApiKey();
final supabaseUrl = config.getSupabaseUrl();

// 設定の確認
if (config.hasClaudeApiKey) {
  // Claude APIを使用する処理
}
```

### 初期化

アプリケーション起動時に自動的に初期化されます（`main.dart`）：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 環境変数の初期化（.env.local を優先）
  final appConfig = AppConfigService();
  await appConfig.initialize();

  // ...
}
```

## トラブルシューティング

### 環境変数が読み込まれない場合

1. ファイル名が正しいか確認（`.env` または `.env.local`）
2. ファイルがプロジェクトのルートディレクトリにあるか確認
3. `flutter pub get` を実行してパッケージを更新
4. アプリを再起動

### APIキーのエラー

```dart
try {
  final apiKey = config.getClaudeApiKey();
} catch (e) {
  // ConfigurationException がスローされます
  print('APIキーが設定されていません: $e');
}
```

## セキュリティ注意事項

- `.env.local` ファイルは絶対にGitにコミットしないでください
- APIキーは他人と共有しないでください
- 本番環境では適切な環境変数管理システムを使用してください
