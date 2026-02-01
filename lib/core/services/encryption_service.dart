import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// エンドツーエンド暗号化サービス
/// AES-256暗号化を使用してユーザーデータを保護
class EncryptionService {
  static const String _keyStorageKey = 'kokosid_encryption_key';
  static const String _ivStorageKey = 'kokosid_encryption_iv';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Encrypter? _encrypter;
  IV? _iv;
  bool _isInitialized = false;

  /// サービスの初期化
  /// デバイス初回起動時にAES-256暗号化キーを生成
  Future<void> initialize() async {
    try {
      // 既存のキーを確認
      final existingKey = await _secureStorage.read(key: _keyStorageKey);
      final existingIV = await _secureStorage.read(key: _ivStorageKey);

      if (existingKey != null && existingIV != null) {
        // 既存のキーを使用
        _encrypter = Encrypter(AES(Key.fromBase64(existingKey)));
        _iv = IV.fromBase64(existingIV);
      } else {
        // 新しいキーを生成
        await _generateNewEncryptionKey();
      }

      _isInitialized = true;
    } catch (e) {
      throw EncryptionException('暗号化サービスの初期化に失敗しました: $e');
    }
  }

  /// 新しい暗号化キーを生成してSecure Storageに保存
  Future<void> _generateNewEncryptionKey() async {
    try {
      // AES-256キー（32バイト）を生成
      final key = Key.fromSecureRandom(32);
      final iv = IV.fromSecureRandom(16);

      // Secure Storageに保存
      await _secureStorage.write(
        key: _keyStorageKey,
        value: key.base64,
      );
      await _secureStorage.write(
        key: _ivStorageKey,
        value: iv.base64,
      );

      _encrypter = Encrypter(AES(key));
      _iv = iv;
    } catch (e) {
      throw EncryptionException('暗号化キーの生成に失敗しました: $e');
    }
  }

  /// データを暗号化
  String encrypt(String plainText) {
    if (!_isInitialized || _encrypter == null || _iv == null) {
      throw const EncryptionException('暗号化サービスが初期化されていません');
    }

    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _iv!);
      return encrypted.base64;
    } catch (e) {
      throw EncryptionException('データの暗号化に失敗しました: $e');
    }
  }

  /// データを復号化
  String decrypt(String encryptedText) {
    if (!_isInitialized || _encrypter == null || _iv == null) {
      throw const EncryptionException('暗号化サービスが初期化されていません');
    }

    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv!);
    } catch (e) {
      throw EncryptionException('データの復号化に失敗しました: $e');
    }
  }

  /// JSONオブジェクトを暗号化
  String encryptJson(Map<String, dynamic> jsonData) {
    final jsonString = jsonEncode(jsonData);
    return encrypt(jsonString);
  }

  /// 暗号化されたJSONを復号化
  Map<String, dynamic> decryptJson(String encryptedJson) {
    final decryptedString = decrypt(encryptedJson);
    return jsonDecode(decryptedString) as Map<String, dynamic>;
  }

  /// 暗号化キーが存在するかチェック
  Future<bool> hasEncryptionKey() async {
    final key = await _secureStorage.read(key: _keyStorageKey);
    return key != null;
  }

  /// 暗号化キーを削除（データ完全削除時に使用）
  Future<void> deleteEncryptionKey() async {
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _ivStorageKey);
    _encrypter = null;
    _iv = null;
    _isInitialized = false;
  }

  /// データハッシュを生成（整合性チェック用）
  String generateHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;
}

/// 暗号化関連の例外
class EncryptionException implements Exception {
  const EncryptionException(this.message);
  final String message;

  @override
  String toString() => 'EncryptionException: $message';
}
