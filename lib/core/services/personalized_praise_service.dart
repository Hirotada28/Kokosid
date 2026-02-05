import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../models/success_experience.dart';
import '../models/task.dart';
import '../models/user_context.dart';
import '../repositories/success_experience_repository.dart';
import 'ai_service.dart';
import 'user_context_service.dart';

/// パーソナライズド賞賛システム
class PersonalizedPraiseService {
  PersonalizedPraiseService({
    required AIService aiService,
    required UserContextService userContextService,
    required SuccessExperienceRepository successExperienceRepository,
  })  : _aiService = aiService,
        _userContextService = userContextService,
        _successExperienceRepository = successExperienceRepository;

  final AIService _aiService;
  final UserContextService _userContextService;
  final SuccessExperienceRepository _successExperienceRepository;

  /// タスク完了時にパーソナライズされた賞賛メッセージを生成
  Future<String> generatePraiseMessage(
    Task completedTask,
    String userUuid,
  ) async {
    // ユーザーコンテキストを取得
    final context = await _userContextService.getUserContext(userUuid);

    // 過去の成功体験を取得
    final recentSuccesses =
        await _successExperienceRepository.getRecentSuccessExperiences(
      userUuid,
      limit: 5,
    );

    // AIプロンプトを構築
    final prompt = _buildPraisePrompt(completedTask, context, recentSuccesses);

    // AI生成による個別化された賞賛メッセージ
    final praiseMessage = await _aiService.complete(prompt);

    return praiseMessage.trim();
  }

  /// 賞賛プロンプトを構築
  String _buildPraisePrompt(
    Task completedTask,
    UserContext context,
    List<SuccessExperience> recentSuccesses,
  ) {
    final successContext = recentSuccesses.isNotEmpty
        ? recentSuccesses
            .map((s) => '- ${s.title}: ${s.description}')
            .join('\n')
        : 'まだ記録された成功体験はありません';

    return '''
あなたはユーザーの心に寄り添うパートナーAIです。
タスク完了時に、ユーザーの価値観と過去の成功体験を参照して、
個別化された賞賛メッセージを生成してください。

【完了したタスク】
タイトル: "${completedTask.title}"
推定時間: ${completedTask.estimatedMinutes ?? '未設定'}分
説明: ${completedTask.description ?? 'なし'}

【ユーザーの現在の状態】
モチベーションレベル: ${(context.motivationLevel * 100).toStringAsFixed(0)}%
最近の感情トレンド: ${_emotionTrendToString(context.emotionTrend)}

【過去の成功体験】
$successContext

【賞賛メッセージの原則】
1. 具体的で誠実な賞賛（「すごい！」だけでなく、何がすごいのか）
2. ユーザーの価値観や過去の成功体験と関連付ける
3. 次の行動への励ましを含める
4. 2-3文で簡潔に
5. 温かく共感的なトーン

賞賛メッセージのみを出力してください（説明や前置きは不要）。
''';
  }

  /// 感情トレンドを文字列に変換
  String _emotionTrendToString(EmotionTrend trend) {
    if (trend.isImproving) {
      return '改善傾向';
    } else if (trend.isDecreasing) {
      return '悪化傾向';
    } else {
      return '安定';
    }
  }

  /// 困難な時期に成功体験を思い出させる
  Future<String?> remindSuccessExperience(
    String userUuid,
    Emotion currentEmotion,
  ) async {
    // 現在の感情が否定的な場合のみ
    if (!currentEmotion.isNegative) {
      return null;
    }

    // 類似の感情状態から回復した成功体験を検索
    final relevantSuccesses =
        await _findRelevantSuccessExperiences(userUuid, currentEmotion);

    if (relevantSuccesses.isEmpty) {
      return null;
    }

    // 最も関連性の高い成功体験を選択
    final bestMatch = relevantSuccesses.first;

    // 参照を記録
    await _successExperienceRepository.recordReference(bestMatch.uuid);

    // 励ましメッセージを生成
    return _buildReminderMessage(bestMatch, currentEmotion);
  }

  /// 関連する成功体験を検索
  Future<List<SuccessExperience>> _findRelevantSuccessExperiences(
    String userUuid,
    Emotion currentEmotion,
  ) async {
    // 現在の感情タイプで検索
    final emotionString = currentEmotion.type.toString().split('.').last;
    final byEmotion = await _successExperienceRepository.searchByEmotion(
      userUuid,
      emotionString,
    );

    // よく参照される成功体験も取得
    final mostReferenced =
        await _successExperienceRepository.getMostReferencedSuccessExperiences(
      userUuid,
    );

    // 重複を除いて結合
    final combined = <String, SuccessExperience>{};
    for (final exp in [...byEmotion, ...mostReferenced]) {
      combined[exp.uuid] = exp;
    }

    return combined.values.toList();
  }

  /// 成功体験を思い出させるメッセージを構築
  String _buildReminderMessage(
    SuccessExperience experience,
    Emotion currentEmotion,
  ) =>
      '''
今は少し${_emotionTypeToString(currentEmotion.type)}を感じているかもしれませんね。

でも、あなたは以前こんな素晴らしい経験をしています：

「${experience.title}」
${experience.description}

${experience.lessonsLearned != null ? '\nそのとき学んだこと：\n${experience.lessonsLearned}' : ''}

あなたには乗り越える力があります。一歩ずつ進んでいきましょう。
''';

  /// 感情タイプを日本語に変換
  String _emotionTypeToString(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return '喜び';
      case EmotionType.sad:
        return '悲しみ';
      case EmotionType.angry:
        return '怒り';
      case EmotionType.anxious:
        return '不安';
      case EmotionType.tired:
        return '疲れ';
      case EmotionType.neutral:
        return '落ち着き';
    }
  }

  /// タスク完了から成功体験を自動記録
  Future<SuccessExperience?> recordSuccessFromTask(
    Task completedTask,
    String userUuid, {
    String? emotionBefore,
    String? emotionAfter,
    String? lessonsLearned,
  }) async {
    // 重要なタスク（15分以上）のみ記録
    if (completedTask.estimatedMinutes == null ||
        completedTask.estimatedMinutes! < 15) {
      return null;
    }

    final experience = SuccessExperience.create(
      uuid: 'success-${DateTime.now().millisecondsSinceEpoch}',
      userUuid: userUuid,
      title: completedTask.title,
      description: completedTask.description ?? 'タスクを完了しました',
      taskUuid: completedTask.uuid,
      emotionBefore: emotionBefore,
      emotionAfter: emotionAfter,
      lessonsLearned: lessonsLearned,
    );

    return _successExperienceRepository.createSuccessExperience(experience);
  }

  /// 手動で成功体験を記録
  Future<SuccessExperience> recordSuccessExperience({
    required String userUuid,
    required String title,
    required String description,
    String? taskUuid,
    String? emotionBefore,
    String? emotionAfter,
    String? lessonsLearned,
    List<String>? tags,
  }) async {
    final experience = SuccessExperience.create(
      uuid: 'success-${DateTime.now().millisecondsSinceEpoch}',
      userUuid: userUuid,
      title: title,
      description: description,
      taskUuid: taskUuid,
      emotionBefore: emotionBefore,
      emotionAfter: emotionAfter,
      lessonsLearned: lessonsLearned,
      tags: tags?.join(','),
    );

    return _successExperienceRepository.createSuccessExperience(experience);
  }

  /// 成功体験を検索
  Future<List<SuccessExperience>> searchSuccessExperiences(
    String userUuid, {
    String? tag,
    String? emotion,
  }) async {
    if (tag != null) {
      return _successExperienceRepository.searchByTag(userUuid, tag);
    } else if (emotion != null) {
      return _successExperienceRepository.searchByEmotion(userUuid, emotion);
    } else {
      return _successExperienceRepository.getUserSuccessExperiences(userUuid);
    }
  }
}
