import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Whisper音声認識サービス
/// OpenAI Whisper APIを使用して音声をテキストに変換
class WhisperService {
  WhisperService({required this.apiKey});

  final String apiKey;
  static const String _apiUrl =
      'https://api.openai.com/v1/audio/transcriptions';

  /// 音声ファイルをテキストに変換
  /// 95%以上の精度で日本語を認識することを目標とする
  Future<String> transcribe(File audioFile) async {
    try {
      // マルチパートリクエストを作成
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));

      // ヘッダーを設定
      request.headers['Authorization'] = 'Bearer $apiKey';

      // 音声ファイルを追加
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFile.path,
        ),
      );

      // モデルと言語を指定
      request.fields['model'] = 'whisper-1';
      request.fields['language'] = 'ja'; // 日本語
      request.fields['response_format'] = 'json';

      // リクエストを送信
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['text'] as String? ?? '';
      } else {
        throw Exception(
          'Whisper API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('音声認識に失敗しました: $e');
    }
  }

  /// オフライン時のフォールバック（簡易的な実装）
  Future<String> transcribeOffline(File audioFile) async {
    // 実際の実装では、オンデバイスの音声認識を使用
    // ここでは簡易的なプレースホルダー
    return '[オフライン: 音声認識は利用できません]';
  }
}
