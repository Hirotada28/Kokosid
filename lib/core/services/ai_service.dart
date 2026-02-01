import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI サービスの抽象インターフェース
abstract class AIService {
  /// プロンプトを送信して応答を取得
  Future<String> complete(String prompt);
}

/// Claude API を使用した AI サービス実装
class ClaudeAIService implements AIService {
  ClaudeAIService({
    required this.apiKey,
    this.model = 'claude-sonnet-4.5',
    this.maxTokens = 2048,
  });

  final String apiKey;
  final String model;
  final int maxTokens;

  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';

  @override
  Future<String> complete(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': model,
          'max_tokens': maxTokens,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final content = data['content'] as List<dynamic>;
        if (content.isNotEmpty) {
          final textContent = content[0] as Map<String, dynamic>;
          return textContent['text'] as String;
        }
        throw AIServiceException('Empty response from API');
      } else {
        throw AIServiceException(
          'API request failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw AIServiceException('Failed to complete AI request: $e');
    }
  }
}

/// AI サービスの例外
class AIServiceException implements Exception {
  AIServiceException(this.message);
  final String message;

  @override
  String toString() => 'AIServiceException: $message';
}
