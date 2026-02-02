import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/services/ai_service.dart';
import 'package:kokosid/core/services/ai_service_with_fallback.dart';
import 'package:kokosid/core/services/local_ai_service.dart';

/// モックAIサービス（テスト用）
class MockCloudAIService implements AIService {
  bool shouldFail = false;
  String? failureMessage;
  int callCount = 0;

  @override
  Future<String> complete(String prompt) async {
    callCount++;

    if (shouldFail) {
      if (failureMessage != null && failureMessage!.contains('quota')) {
        throw AIServiceException('API quota exceeded: 429');
      } else if (failureMessage != null &&
          failureMessage!.contains('network')) {
        throw AIServiceException('Network error');
      } else {
        throw AIServiceException(failureMessage ?? 'API error');
      }
    }

    return 'Cloud AI response: $prompt';
  }
}

void main() {
  group('AIServiceWithFallback', () {
    late MockCloudAIService mockCloudAI;
    late LocalAIService localAI;
    late AIServiceWithFallback service;

    setUp(() {
      mockCloudAI = MockCloudAIService();
      localAI = LocalAIService();
      service = AIServiceWithFallback(
        cloudAI: mockCloudAI,
        localAI: localAI,
      );
    });

    test('正常時はクラウドAIを使用する', () async {
      // Given: クラウドAIが正常動作
      mockCloudAI.shouldFail = false;

      // When: プロンプトを送信
      final response = await service.complete('テストプロンプト');

      // Then: クラウドAIの応答が返る
      expect(response, contains('Cloud AI response'));
      expect(mockCloudAI.callCount, 1);
      expect(service.isInFallbackMode, false);
    });

    test('APIクォータ超過時はローカルAIにフォールバック', () async {
      // Given: APIクォータ超過
      mockCloudAI.shouldFail = true;
      mockCloudAI.failureMessage = 'quota exceeded';

      // When: プロンプトを送信
      final response = await service.complete('つらい気持ち');

      // Then: ローカルAIの応答が返る
      expect(response, isNotEmpty);
      expect(response, isNot(contains('Cloud AI response')));
      expect(mockCloudAI.callCount, 1);
    });

    test('連続失敗3回でフォールバックモードに移行', () async {
      // Given: クラウドAIが失敗する
      mockCloudAI.shouldFail = true;
      mockCloudAI.failureMessage = 'API error';

      // When: 3回連続で失敗
      await service.complete('プロンプト1');
      await service.complete('プロンプト2');
      await service.complete('プロンプト3');

      // Then: フォールバックモードに移行
      expect(service.isInFallbackMode, true);
      expect(mockCloudAI.callCount, 3);
    });

    test('フォールバックモード中はクラウドAIを呼ばない', () async {
      // Given: フォールバックモードに移行
      mockCloudAI.shouldFail = true;
      await service.complete('プロンプト1');
      await service.complete('プロンプト2');
      await service.complete('プロンプト3');
      expect(service.isInFallbackMode, true);

      // When: さらにプロンプトを送信
      mockCloudAI.callCount = 0; // カウントリセット
      await service.complete('プロンプト4');

      // Then: クラウドAIは呼ばれない
      expect(mockCloudAI.callCount, 0);
    });

    test('手動復旧でフォールバックモードを解除', () async {
      // Given: フォールバックモードに移行
      mockCloudAI.shouldFail = true;
      await service.complete('プロンプト1');
      await service.complete('プロンプト2');
      await service.complete('プロンプト3');
      expect(service.isInFallbackMode, true);

      // When: 手動復旧
      service.forceRecovery();
      mockCloudAI.shouldFail = false;

      // Then: フォールバックモードが解除され、クラウドAIが使用される
      expect(service.isInFallbackMode, false);
      final response = await service.complete('復旧後プロンプト');
      expect(response, contains('Cloud AI response'));
    });

    test('マイクロ・チャンキングのフォールバック', () async {
      // Given: クラウドAIが失敗
      mockCloudAI.shouldFail = true;

      // When: マイクロ・チャンキングを実行
      final response = await service.completeMicroChunking('レポートを書く');

      // Then: フォールバック応答が返る
      expect(response, contains('小さなステップ'));
      expect(response, contains('レポートを書く'));
    });

    test('ACT対話のフォールバック', () async {
      // Given: クラウドAIが失敗
      mockCloudAI.shouldFail = true;

      // When: ACT対話を実行
      final response = await service.completeACTDialogue(
        'つらい気持ちです',
        'anxious',
      );

      // Then: フォールバック応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });
  });

  group('LocalAIService', () {
    late LocalAIService service;

    setUp(() {
      service = LocalAIService();
    });

    test('否定的感情を検出して適切な応答を生成', () {
      // When: 否定的感情を含む入力
      final response = service.generateFallbackResponse('つらい気持ちです');

      // Then: 受容的な応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });

    test('自己批判を検出して脱フュージョン応答を生成', () {
      // When: 自己批判を含む入力
      final response = service.generateFallbackResponse('私はダメな人間です');

      // Then: 脱フュージョン応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });

    test('低モチベーションを検出して価値明確化応答を生成', () {
      // When: 低モチベーションを含む入力
      final response = service.generateFallbackResponse('やる気が出ません');

      // Then: 価値明確化応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });

    test('タスク完了を検出して賞賛応答を生成', () {
      // When: タスク完了を含む入力
      final response = service.generateFallbackResponse('タスクが完了しました');

      // Then: 賞賛応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });

    test('一般的な入力に対して汎用応答を生成', () {
      // When: 一般的な入力
      final response = service.generateFallbackResponse('こんにちは');

      // Then: 汎用応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });

    test('マイクロ・チャンキングのフォールバック応答を生成', () {
      // When: タスクタイトルを指定
      final response = service.generateMicroChunkingFallback('レポートを書く');

      // Then: 基本的な分解が返る
      expect(response, contains('レポートを書く'));
      expect(response, contains('ステップ'));
    });

    test('ACT対話のフォールバック応答を生成', () {
      // When: 感情タイプを指定
      final response = service.generateACTFallback('anxious');

      // Then: 適切な応答が返る
      expect(response, isNotEmpty);
      expect(response.length, greaterThan(10));
    });
  });
}
