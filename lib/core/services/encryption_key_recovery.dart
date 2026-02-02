import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'encryption_service.dart';

/// 暗号化キー紛失時の回復機能
/// キー紛失を検出し、ユーザーに状況を説明して新しいセッションを開始
class EncryptionKeyRecovery {
  EncryptionKeyRecovery({
    required EncryptionService encryptionService,
  }) : _encryptionService = encryptionService;

  final EncryptionService _encryptionService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _keyStorageKey = 'kokosid_encryption_key';
  static const String _ivStorageKey = 'kokosid_encryption_iv';
  static const String _keyLossDetectedKey = 'kokosid_key_loss_detected';

  /// 暗号化キーの存在を確認
  Future<bool> hasEncryptionKey() async {
    try {
      final key = await _secureStorage.read(key: _keyStorageKey);
      final iv = await _secureStorage.read(key: _ivStorageKey);
      return key != null && iv != null;
    } catch (e) {
      return false;
    }
  }

  /// キー紛失を検出
  Future<bool> detectKeyLoss() async {
    try {
      // Secure Storageにキーが存在するか確認
      final hasKey = await hasEncryptionKey();

      if (!hasKey) {
        // キー紛失を記録
        await _secureStorage.write(
          key: _keyLossDetectedKey,
          value: DateTime.now().toIso8601String(),
        );
        return true;
      }

      return false;
    } catch (e) {
      // Secure Storageへのアクセスに失敗した場合もキー紛失とみなす
      return true;
    }
  }

  /// キー紛失の履歴を確認
  Future<DateTime?> getKeyLossDetectionTime() async {
    try {
      final timeString = await _secureStorage.read(key: _keyLossDetectedKey);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// キー紛失時の回復処理を実行
  Future<void> handleKeyLoss(BuildContext context) async {
    // 1. ユーザーに状況を説明
    final shouldContinue = await _showKeyLossDialog(context);

    if (!shouldContinue) {
      return;
    }

    // 2. データ復旧不可能の警告を表示
    final confirmedDataLoss = await _showDataLossWarning(context);

    if (!confirmedDataLoss) {
      return;
    }

    // 3. 新しい暗号化キーを生成
    await _generateNewEncryptionKey();

    // 4. 新しいセッションとして初期化
    await _initializeNewSession(context);
  }

  /// キー紛失説明ダイアログを表示
  Future<bool> _showKeyLossDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('暗号化キーが見つかりません'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'デバイスに保存されていた暗号化キーが見つかりませんでした。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('考えられる原因：'),
              SizedBox(height: 8),
              Text('• アプリの再インストール'),
              Text('• デバイスのセキュリティ設定の変更'),
              Text('• システムアップデート'),
              Text('• ストレージの初期化'),
              SizedBox(height: 16),
              Text(
                '暗号化キーがないと、以前のデータを復号化することができません。',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('続ける'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// データ復旧不可能の警告を表示
  Future<bool> _showDataLossWarning(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('重要な警告'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '以下のデータは復旧できません：',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 12),
              Text('• 過去のタスクと完了履歴'),
              Text('• 日記エントリと音声記録'),
              Text('• 自己肯定感スコアの履歴'),
              Text('• AI対話の履歴'),
              SizedBox(height: 16),
              Text(
                '新しい暗号化キーを生成して、新しいセッションとして開始します。',
              ),
              SizedBox(height: 16),
              Text(
                'この操作は取り消せません。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('理解しました。続けます'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// 新しい暗号化キーを生成
  Future<void> _generateNewEncryptionKey() async {
    try {
      // 既存のキーを削除
      await _encryptionService.deleteEncryptionKey();

      // 新しいキーを生成
      await _encryptionService.initialize();

      print('✅ 新しい暗号化キーを生成しました');
    } catch (e) {
      throw EncryptionKeyRecoveryException('暗号化キーの生成に失敗しました: $e');
    }
  }

  /// 新しいセッションとして初期化
  Future<void> _initializeNewSession(BuildContext context) async {
    try {
      // キー紛失検出フラグをクリア
      await _secureStorage.delete(key: _keyLossDetectedKey);

      // 成功メッセージを表示
      if (context.mounted) {
        await _showSuccessDialog(context);
      }

      print('✅ 新しいセッションを開始しました');
    } catch (e) {
      throw EncryptionKeyRecoveryException('新しいセッションの初期化に失敗しました: $e');
    }
  }

  /// 成功ダイアログを表示
  Future<void> _showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('セットアップ完了'),
          ],
        ),
        content: const Text(
          '新しい暗号化キーが生成され、新しいセッションが開始されました。\n\n'
          'これからKokosidを安全にご利用いただけます。',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('開始する'),
          ),
        ],
      ),
    );
  }

  /// 自動回復を試みる（アプリ起動時に呼び出し）
  Future<bool> attemptAutoRecovery(BuildContext context) async {
    try {
      // キー紛失を検出
      final keyLost = await detectKeyLoss();

      if (keyLost) {
        // キー紛失時の回復処理を実行
        await handleKeyLoss(context);
        return true;
      }

      return false;
    } catch (e) {
      print('⚠️ 自動回復に失敗しました: $e');
      return false;
    }
  }

  /// 手動でキーをリセット（デバッグ用）
  Future<void> manualKeyReset() async {
    try {
      await _secureStorage.delete(key: _keyStorageKey);
      await _secureStorage.delete(key: _ivStorageKey);
      await _secureStorage.delete(key: _keyLossDetectedKey);
      print('✅ 暗号化キーを手動でリセットしました');
    } catch (e) {
      throw EncryptionKeyRecoveryException('キーのリセットに失敗しました: $e');
    }
  }
}

/// 暗号化キー回復関連の例外
class EncryptionKeyRecoveryException implements Exception {
  EncryptionKeyRecoveryException(this.message);
  final String message;

  @override
  String toString() => 'EncryptionKeyRecoveryException: $message';
}
