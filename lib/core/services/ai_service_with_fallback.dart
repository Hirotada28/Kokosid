import 'dart:io';

import 'ai_service.dart';
import 'local_ai_service.dart';

/// AI API障害時のフォールバック機能を持つAIサービス
/// ネットワーク障害やAPIクォータ超過時にローカルAIにフォールバック
class AIServiceWithFallback implements AIService {
  AIServiceWithFallback({
    required AIService cloudAI,
    LocalAIService? localAI,
  })  : _cloudAI = cloudAI,
        _localAI = localAI ?? LocalAIService();

  final AIService _cloudAI;
  final LocalAIService _localAI;

  bool _isInFallbackMode = false;
  DateTime? _lastFailureTime;
  int _consecutiveFailures = 0;

  static const int _maxConsecutiveFailures = 3;
  static const Duration _fallbackCooldown = Duration(minutes: 5);

  /// フォールバック状態を確認
  bool get isInFallbackMode => _isInFallbackMode;

  /// 最後の障害時刻を取得
  DateTime? get lastFailureTime => _lastFailureTime;

  @override
  Future<String> complete(String prompt) async {
    // フォールバックモードの自動復旧チェック
    if (_isInFallbackMode && _shouldAttemptRecovery()) {
      _attemptRecovery();
    }

    // フォールバックモード中はローカルAIを使用
    if (_isInFallbackMode) {
      return _localAI.generateFallbackResponse(prompt);
    }

    try {
      // クラウドAIを試行
      final response = await _cloudAI.complete(prompt);

      // 成功したら失敗カウントをリセット
      _consecutiveFailures = 0;

      return response;
    } on SocketException catch (e) {
      // ネットワーク障害時はローカルAIにフォールバック
      _handleFailure('ネットワーク接続エラー: ${e.message}');
      return _localAI.generateFallbackResponse(prompt);
    } on AIServiceException catch (e) {
      // APIクォータ超過やその他のAPI障害
      if (_isQuotaExceeded(e.message)) {
        _handleFailure('APIクォータ超過: ${e.message}');
        return _localAI.generateFallbackResponse(prompt);
      } else if (_isRateLimited(e.message)) {
        _handleFailure('レート制限: ${e.message}');
        return _localAI.generateFallbackResponse(prompt);
      } else {
        // その他のAPI障害
        _handleFailure('API障害: ${e.message}');
        return _localAI.generateFallbackResponse(prompt);
      }
    } catch (e) {
      // 予期しないエラー
      _handleFailure('予期しないエラー: $e');
      return _localAI.generateFallbackResponse(prompt);
    }
  }

  /// マイクロ・チャンキング用の完了メソッド
  Future<String> completeMicroChunking(String taskTitle) async {
    if (_isInFallbackMode && _shouldAttemptRecovery()) {
      _attemptRecovery();
    }

    if (_isInFallbackMode) {
      return _localAI.generateMicroChunkingFallback(taskTitle);
    }

    try {
      final prompt = _buildMicroChunkingPrompt(taskTitle);
      final response = await _cloudAI.complete(prompt);
      _consecutiveFailures = 0;
      return response;
    } catch (e) {
      _handleFailure('マイクロ・チャンキングエラー: $e');
      return _localAI.generateMicroChunkingFallback(taskTitle);
    }
  }

  /// ACT対話用の完了メソッド
  Future<String> completeACTDialogue(
      String userInput, String emotionType) async {
    if (_isInFallbackMode && _shouldAttemptRecovery()) {
      _attemptRecovery();
    }

    if (_isInFallbackMode) {
      return _localAI.generateACTFallback(emotionType);
    }

    try {
      final prompt = _buildACTDialoguePrompt(userInput, emotionType);
      final response = await _cloudAI.complete(prompt);
      _consecutiveFailures = 0;
      return response;
    } catch (e) {
      _handleFailure('ACT対話エラー: $e');
      return _localAI.generateACTFallback(emotionType);
    }
  }

  /// 障害を処理してフォールバックモードに移行
  void _handleFailure(String reason) {
    _consecutiveFailures++;
    _lastFailureTime = DateTime.now();

    // 連続失敗が閾値を超えたらフォールバックモードに移行
    if (_consecutiveFailures >= _maxConsecutiveFailures) {
      _isInFallbackMode = true;
      print('⚠️ フォールバックモードに移行: $reason');
    } else {
      print(
          '⚠️ AI API障害 ($_consecutiveFailures/$_maxConsecutiveFailures): $reason');
    }
  }

  /// 復旧を試みるべきか判定
  bool _shouldAttemptRecovery() {
    if (_lastFailureTime == null) return false;

    final timeSinceFailure = DateTime.now().difference(_lastFailureTime!);
    return timeSinceFailure >= _fallbackCooldown;
  }

  /// 復旧を試みる
  void _attemptRecovery() {
    print('🔄 クラウドAIへの復旧を試みます...');
    _isInFallbackMode = false;
    _consecutiveFailures = 0;
  }

  /// 手動でフォールバックモードを解除
  void forceRecovery() {
    _isInFallbackMode = false;
    _consecutiveFailures = 0;
    _lastFailureTime = null;
    print('✅ フォールバックモードを手動で解除しました');
  }

  /// APIクォータ超過を検出
  bool _isQuotaExceeded(String message) =>
      message.toLowerCase().contains('quota') ||
      message.toLowerCase().contains('limit exceeded') ||
      message.contains('429');

  /// レート制限を検出
  bool _isRateLimited(String message) =>
      message.toLowerCase().contains('rate limit') ||
      message.toLowerCase().contains('too many requests') ||
      message.contains('429');

  String _buildMicroChunkingPrompt(String taskTitle) => '''
あなたはADHD特性を持つ人のタスク分解専門家です。

【入力タスク】
タイトル: "$taskTitle"

【分解の原則】
1. 各ステップは5分以内で完了できる
2. 具体的な動詞で始める（「考える」ではなく「3つ書き出す」）
3. 成功条件が明確（チェックボックスで判定可能）
4. 最初のステップは「準備」ではなく「実行」から始める
5. 最大7ステップまで（認知負荷軽減）

JSON形式で出力してください。
''';

  String _buildACTDialoguePrompt(String userInput, String emotionType) => '''
あなたはACT（受容とコミットメント・セラピー）の専門家です。

【ユーザー入力】
$userInput

【検出された感情】
$emotionType

【対応方針】
ACTの6つのコアプロセスに基づいて、共感的で支援的な応答を生成してください。
''';
}

/// ネットワーク例外
class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// APIクォータ超過例外
class APIQuotaException implements Exception {
  APIQuotaException(this.message);
  final String message;

  @override
  String toString() => 'APIQuotaException: $message';
}
