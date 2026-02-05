import '../models/act_process.dart';
import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../models/user_context.dart';
import 'ai_service.dart';
import 'dialogue_history_service.dart';
import 'user_context_service.dart';

/// ACT対話エンジン
class ACTDialogueEngine {
  ACTDialogueEngine(
    this._aiService,
    this._userContextService,
    this._dialogueHistoryService,
  );

  final AIService _aiService;
  final UserContextService _userContextService;
  final DialogueHistoryService _dialogueHistoryService;

  /// ユーザー入力に対する応答を生成
  Future<ACTDialogueResponse> generateResponse(
    String userInput,
    String userUuid,
  ) async {
    // 1. ユーザーコンテキストを取得
    final context = await _userContextService.getUserContext(userUuid);

    // 2. 個別化コンテキストを取得
    final personalizationContext =
        await _dialogueHistoryService.buildPersonalizationContext(userUuid);

    // 3. 感情・思考パターンを抽出
    final emotion = _extractEmotion(userInput, context);

    // 4. 最適なACTプロセスを選択
    final process = _selectACTProcess(emotion, context, userInput);

    // 5. パーソナライズされた応答を生成
    final response = await _generatePersonalizedResponse(
      process,
      emotion,
      context,
      personalizationContext,
      userInput,
    );

    return ACTDialogueResponse(
      response: response,
      process: process,
      emotion: emotion,
    );
  }

  /// 感情を抽出
  Emotion _extractEmotion(String userInput, UserContext context) {
    // 簡易的な感情抽出（実際にはより高度な分析が必要）
    final lowerInput = userInput.toLowerCase();

    // ネガティブキーワードチェック
    final negativeKeywords = [
      'つらい',
      '悲しい',
      '不安',
      '心配',
      '疲れた',
      '疲れました',
      'できない',
      'ダメ',
      '無理',
      '怖い',
      '辛い',
      '苦しい',
    ];
    final hasNegative = negativeKeywords.any(lowerInput.contains);

    // ポジティブキーワードチェック
    final positiveKeywords = ['嬉しい', '楽しい', 'できた', '良い', 'ありがとう', '幸せ'];
    final hasPositive = positiveKeywords.any(lowerInput.contains);

    EmotionType type;
    if (hasNegative) {
      if (lowerInput.contains('不安') || lowerInput.contains('心配')) {
        type = EmotionType.anxious;
      } else if (lowerInput.contains('疲れ')) {
        type = EmotionType.tired;
      } else if (lowerInput.contains('悲し')) {
        type = EmotionType.sad;
      } else {
        type = EmotionType.sad;
      }
    } else if (hasPositive) {
      type = EmotionType.happy;
    } else {
      type = EmotionType.neutral;
    }

    return Emotion(
      type: type,
      confidence: 0.7,
      scores: {type: 0.7},
      isNegative: type != EmotionType.happy && type != EmotionType.neutral,
    );
  }

  /// 最適なACTプロセスを選択
  ACTProcess _selectACTProcess(
    Emotion emotion,
    UserContext context,
    String userInput,
  ) {
    final lowerInput = userInput.toLowerCase();

    // 1. 現在の瞬間に関するキーワードをチェック（最優先）
    // マインドフルネス特有のキーワードを先にチェック
    final mindfulnessKeywords = ['今を感じ', '気づき', '意識し', '瞑想', '呼吸に集中'];
    final hasMindfulness = mindfulnessKeywords.any(lowerInput.contains);

    if (hasMindfulness) {
      return ACTProcess.mindfulness; // マインドフルネス
    }

    // 2. 自己批判的思考のパターンをチェック
    final selfCriticismKeywords = [
      'ダメ',
      '無理',
      'できない',
      'できません',
      '失敗',
      '情けない',
      '価値がない'
    ];
    final hasSelfCriticism = selfCriticismKeywords.any(lowerInput.contains);

    if (hasSelfCriticism) {
      return ACTProcess.defusion; // 認知的脱フュージョン
    }

    // 3. 否定的感情と悪化トレンドで受容（高モチベーションより優先）
    if (emotion.isNegative && context.emotionTrend.isDecreasing) {
      return ACTProcess.acceptance; // 受容
    }

    // 4. 低モチベーションで価値明確化
    if (context.motivationLevel < 0.3) {
      return ACTProcess.valuesClarity; // 価値の明確化
    }

    // 5. 行動に関するキーワードをチェック
    final actionKeywords = ['やる', 'する', '始める', '取り組む', '挑戦', 'やります', '始めます'];
    final hasAction = actionKeywords.any(lowerInput.contains);

    if (hasAction && context.motivationLevel >= 0.6) {
      return ACTProcess.committedAction; // コミットされた行動
    }

    // 6. 高モチベーションでコミット行動（ただしネガティブ感情でない場合）
    if (context.motivationLevel >= 0.6 && !emotion.isNegative) {
      return ACTProcess.committedAction;
    }

    // デフォルトは観察する自己
    return ACTProcess.observingSelf;
  }

  /// パーソナライズされた応答を生成
  Future<String> _generatePersonalizedResponse(
    ACTProcess process,
    Emotion emotion,
    UserContext context,
    PersonalizationContext personalizationContext,
    String userInput,
  ) async {
    final prompt = _buildPrompt(
      process,
      emotion,
      context,
      personalizationContext,
      userInput,
    );

    try {
      return await _aiService.complete(prompt);
    } on AIServiceException {
      // フォールバック応答
      return _getFallbackResponse(process, emotion);
    }
  }

  /// プロンプトを構築
  String _buildPrompt(
    ACTProcess process,
    Emotion emotion,
    UserContext context,
    PersonalizationContext personalizationContext,
    String userInput,
  ) {
    // 個別化情報を追加
    final personalizationInfo = personalizationContext.totalDialogues > 0
        ? '''
【個別化情報】
- 対話回数: ${personalizationContext.totalDialogues}回
- よく使うプロセス: ${personalizationContext.mostFrequentProcess}
- 繰り返しテーマ: ${personalizationContext.recurringThemes.join('、')}
- 過去の成功体験: ${personalizationContext.successExperiences.isNotEmpty ? personalizationContext.successExperiences.first : 'なし'}
'''
        : '';

    final basePrompt = '''
あなたは受容とコミットメント・セラピー（ACT）の専門家であり、ユーザーの心に寄り添うパートナーです。

【ユーザーの状態】
- 現在の感情: ${emotion.type.name}
- 感情トレンド: ${_describeTrend(context.emotionTrend)}
- モチベーションレベル: ${(context.motivationLevel * 100).toInt()}%
- 最近の対話: ${context.dialogueHistory.isNotEmpty ? context.dialogueHistory.first : 'なし'}

$personalizationInfo

【ユーザーの入力】
"$userInput"

【適用するACTプロセス】
${process.description}

【応答の原則】
1. 共感的で温かいトーンを使用する
2. ユーザーの感情を否定せず、受容する
3. ${process.shortName}の技法を自然に組み込む
4. 具体的で実践可能なアドバイスを提供する
5. 過去の対話履歴を参照し、個別化された応答を生成する
6. 150文字以内で簡潔に応答する

応答を生成してください：
''';

    return basePrompt;
  }

  /// トレンドを説明
  String _describeTrend(EmotionTrend trend) {
    if (trend.isImproving) {
      return '改善傾向';
    } else if (trend.isDecreasing) {
      return '悪化傾向';
    } else {
      return '安定';
    }
  }

  /// フォールバック応答を取得
  String _getFallbackResponse(ACTProcess process, Emotion emotion) {
    switch (process) {
      case ACTProcess.acceptance:
        return 'その気持ち、よくわかります。つらい感情も、あなたの大切な一部です。今はそのまま感じていいんですよ。';
      case ACTProcess.defusion:
        return 'その考えは、あくまで「考え」であって、事実ではありません。少し距離を置いて、客観的に見てみましょう。';
      case ACTProcess.valuesClarity:
        return 'あなたにとって本当に大切なことは何でしょうか？その価値に向かって、小さな一歩を踏み出してみませんか？';
      case ACTProcess.committedAction:
        return '素晴らしいですね！その気持ちを大切に、具体的な行動に移してみましょう。小さなステップから始めましょう。';
      case ACTProcess.mindfulness:
        return '今この瞬間に意識を向けてみましょう。深呼吸をして、自分の感覚に気づいてみてください。';
      case ACTProcess.observingSelf:
        return '自分の思考や感情を、少し離れたところから観察してみましょう。あなたは、それらを持っている存在です。';
    }
  }
}

/// ACT対話応答
class ACTDialogueResponse {
  ACTDialogueResponse({
    required this.response,
    required this.process,
    required this.emotion,
  });

  final String response;
  final ACTProcess process;
  final Emotion emotion;

  @override
  String toString() =>
      'ACTDialogueResponse{process: ${process.shortName}, emotion: ${emotion.type}}';
}
