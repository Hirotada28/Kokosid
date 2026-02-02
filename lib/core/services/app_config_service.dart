import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// アプリケーション設定サービス
/// API キーや環境変数を安全に管理
class AppConfigService {
  // シングルトンパターン
  AppConfigService._internal();
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;

  bool _initialized = false;

  /// 環境変数を初期化（.env.local を優先）
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // .env.local が存在する場合は優先的に読み込む
      final localEnvExists = await _fileExists('.env.local');
      if (localEnvExists) {
        await dotenv.load(fileName: '.env.local');
      } else {
        // .env.local がない場合は .env を読み込む
        await dotenv.load(fileName: '.env');
      }
      _initialized = true;
    } catch (e) {
      // 環境変数ファイルが見つからない場合は警告のみ
      print('警告: 環境変数ファイルの読み込みに失敗しました: $e');
    }
  }

  /// ファイルが存在するかチェック
  Future<bool> _fileExists(String fileName) async {
    try {
      await rootBundle.load(fileName);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Anthropic Claude API キー
  String get claudeApiKey => dotenv.get('CLAUDE_API_KEY', fallback: '');

  // OpenAI Whisper API キー
  String get whisperApiKey => dotenv.get('WHISPER_API_KEY', fallback: '');

  // Supabase 設定
  String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: '');

  String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY', fallback: '');

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
  bool get isDebugMode => dotenv.get('DEBUG_MODE', fallback: 'false') == 'true';

  /// ログ出力するかどうか
  bool get enableLogging =>
      dotenv.get('ENABLE_LOGGING', fallback: 'true') == 'true';
}

/// 設定エラー例外
class ConfigurationException implements Exception {
  ConfigurationException(this.message);
  final String message;

  @override
  String toString() => 'ConfigurationException: $message';
}
