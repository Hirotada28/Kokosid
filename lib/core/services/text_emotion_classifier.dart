import '../models/journal_entry.dart';

/// テキスト感情分析結果
class TextEmotion {
  TextEmotion({
    required this.primaryEmotion,
    required this.confidence,
    required this.emotionScores,
  });

  final EmotionType primaryEmotion;
  final double confidence;
  final Map<EmotionType, double> emotionScores;

  @override
  String toString() =>
      'TextEmotion{emotion: $primaryEmotion, confidence: $confidence}';
}

/// テキスト感情分類器
/// BERTベースの感情分類モデルを使用してテキストから感情を判定
class TextEmotionClassifier {
  /// テキストから感情を分類
  /// 6つの感情（喜び、悲しみ、怒り、不安、疲労、中立）を判定
  Future<TextEmotion> classify(String text) async {
    // 実際の実装では、BERTモデルまたはAI APIを使用
    // ここでは簡易的なキーワードベースの分類を実装

    final emotionScores = _analyzeKeywords(text);

    // 最も高いスコアの感情を選択
    EmotionType primaryEmotion = EmotionType.neutral;
    double maxScore = 0.0;

    for (final entry in emotionScores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        primaryEmotion = entry.key;
      }
    }

    return TextEmotion(
      primaryEmotion: primaryEmotion,
      confidence: maxScore,
      emotionScores: emotionScores,
    );
  }

  /// キーワードベースの感情分析
  Map<EmotionType, double> _analyzeKeywords(String text) {
    final scores = <EmotionType, double>{
      EmotionType.happy: 0.0,
      EmotionType.sad: 0.0,
      EmotionType.angry: 0.0,
      EmotionType.anxious: 0.0,
      EmotionType.tired: 0.0,
      EmotionType.neutral: 0.5, // デフォルトで中立に重み
    };

    final lowerText = text.toLowerCase();

    // 喜びのキーワード
    final happyKeywords = [
      '嬉しい',
      'うれしい',
      '楽しい',
      'たのしい',
      '幸せ',
      'しあわせ',
      '良い',
      'よい',
      'いい',
      '最高',
      'すごい',
      'ありがとう',
      '感謝',
      'わくわく',
      'ワクワク',
      '笑',
      'ハッピー',
      '喜び',
    ];

    // 悲しみのキーワード
    final sadKeywords = [
      '悲しい',
      'かなしい',
      'つらい',
      '辛い',
      '寂しい',
      'さびしい',
      '泣',
      '涙',
      '落ち込',
      '憂鬱',
      'ゆううつ',
      '虚しい',
      'むなしい',
      '孤独',
      '絶望',
      '残念',
      'ショック',
    ];

    // 怒りのキーワード
    final angryKeywords = [
      '怒',
      'いらいら',
      'イライラ',
      'むかつく',
      'ムカつく',
      '腹立',
      '許せない',
      'ゆるせない',
      '最悪',
      'うざい',
      'ウザい',
      'ストレス',
      '不満',
      'ふまん',
      '嫌',
      'いや',
      'きらい',
      '嫌い',
    ];

    // 不安のキーワード
    final anxiousKeywords = [
      '不安',
      'ふあん',
      '心配',
      'しんぱい',
      '怖',
      'こわ',
      '恐',
      '緊張',
      'きんちょう',
      'ドキドキ',
      'どきどき',
      '焦',
      'あせ',
      '迷',
      'まよ',
      '困',
      'こま',
      'どうしよう',
      'やばい',
      'ヤバい',
    ];

    // 疲労のキーワード
    final tiredKeywords = [
      '疲れ',
      'つかれ',
      '眠',
      'ねむ',
      'だるい',
      'ダルい',
      '重',
      'しんどい',
      'きつい',
      'キツい',
      '無理',
      'むり',
      'もう',
      '限界',
      'げんかい',
      'やる気',
      'やるき',
      'ない',
      '休',
    ];

    // キーワードマッチングでスコアを計算
    scores[EmotionType.happy] = _countKeywords(lowerText, happyKeywords);
    scores[EmotionType.sad] = _countKeywords(lowerText, sadKeywords);
    scores[EmotionType.angry] = _countKeywords(lowerText, angryKeywords);
    scores[EmotionType.anxious] = _countKeywords(lowerText, anxiousKeywords);
    scores[EmotionType.tired] = _countKeywords(lowerText, tiredKeywords);

    // スコアを正規化
    return _normalizeScores(scores);
  }

  /// キーワードの出現回数をカウント
  double _countKeywords(String text, List<String> keywords) {
    var count = 0.0;
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        count += 1.0;
      }
    }
    return count;
  }

  /// スコアを正規化（合計が1.0になるように）
  Map<EmotionType, double> _normalizeScores(Map<EmotionType, double> scores) {
    final total = scores.values.fold(0.0, (sum, score) => sum + score);
    if (total == 0) {
      // 全てのスコアが0の場合は中立を返す
      return {
        EmotionType.happy: 0.0,
        EmotionType.sad: 0.0,
        EmotionType.angry: 0.0,
        EmotionType.anxious: 0.0,
        EmotionType.tired: 0.0,
        EmotionType.neutral: 1.0,
      };
    }
    return Map.fromEntries(
      scores.entries.map((entry) => MapEntry(entry.key, entry.value / total)),
    );
  }

  /// AI APIを使用した高度な感情分析（オプション）
  Future<TextEmotion> classifyWithAI(String text, String apiKey) async {
    // 実際の実装では、Claude/GPT-4などのAI APIを使用
    // より高精度な感情分析が可能
    // ここでは基本的な実装にフォールバック
    return classify(text);
  }
}
