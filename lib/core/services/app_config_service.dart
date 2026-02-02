/// アプリケーション設定サービス
/// API キーや環境変数を安全に管理
class AppConfigService {
  // シングルトンパターン
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;
  AppConfigService._internal();

  // コンパイル時の環境変数から取得（flutter run --dart-define で設定）
  // Anthropic Claude API キー
  static const String claudeApiKey = String.fromEnvironment(
    'CLAUDE_API_KEY',
    defaultValue: '',
  );

  // OpenAI Whisper API キー
  static const String whisperApiKey = String.fromEnvironment(
    'WHISPER_API_KEY',
    defaultValue: '',
  );

  // Supabase 設定
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// API キーが設定されているかチェック
  bool get hasClaudeApiKey => claudeApiKey.isNotEmpty;
  bool get hasWhisperApiKey => whisperApiKey.isNotEmpty;
  bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Claude API キーを取得（未設定の場合は例外）
  String getClaudeApiKey() {
    if (claudeApiKey.isEmpty) {
      throw ConfigurationException(
        'Claude API キーが設定されていません。'
        'flutter run --dart-define=CLAUDE_API_KEY=your-key で設定してください。',
      );
    }
    return claudeApiKey;
  }

  /// Whisper API キーを取得（未設定の場合は例外）
  String getWhisperApiKey() {
    if (whisperApiKey.isEmpty) {
      throw ConfigurationException(
        'Whisper API キーが設定されていません。'
        'flutter run --dart-define=WHISPER_API_KEY=your-key で設定してください。',
      );
    }
    return whisperApiKey;
  }

  /// Supabase URL を取得
  String getSupabaseUrl() {
    if (supabaseUrl.isEmpty) {
      throw ConfigurationException(
        'Supabase URL が設定されていません。'
        'flutter run --dart-define=SUPABASE_URL=your-url で設定してください。',
      );
    }
    return supabaseUrl;
  }

  /// Supabase Anon Key を取得
  String getSupabaseAnonKey() {
    if (supabaseAnonKey.isEmpty) {
      throw ConfigurationException(
        'Supabase Anon Key が設定されていません。'
        'flutter run --dart-define=SUPABASE_ANON_KEY=your-key で設定してください。',
      );
    }
    return supabaseAnonKey;
  }

  /// デバッグモードかどうか
  static const bool isDebugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: false,
  );

  /// ログ出力するかどうか
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
}

/// 設定エラー例外
class ConfigurationException implements Exception {
  ConfigurationException(this.message);
  final String message;

  @override
  String toString() => 'ConfigurationException: $message';
}
