/// ローカルAIサービス（オフライン時のフォールバック）
/// 事前定義済み応答を使用してネットワーク障害時にも基本機能を提供
class LocalAIService {
  /// 事前定義済みACT応答パターン
  static const Map<String, List<String>> _fallbackResponses = {
    'negative_emotion': [
      'つらい気持ちを感じているのですね。その感情を否定せず、ただ感じることを許してあげましょう。',
      '今、困難な感情を経験しているのですね。それは自然なことです。その感情と共にいることができます。',
      '苦しい気持ちがあるのですね。その感情を受け入れることで、少しずつ楽になっていきます。',
    ],
    'self_criticism': [
      'その考えは、あなた自身ではなく、ただの思考です。思考と距離を置いてみましょう。',
      '「私はダメだ」という考えが浮かんでいるのですね。それは事実ではなく、ただの思考です。',
      'その批判的な声に気づけたことは素晴らしいです。思考を観察することができています。',
    ],
    'motivation_low': [
      'あなたにとって本当に大切なことは何でしょうか？その価値に向かって、小さな一歩を踏み出してみませんか。',
      'モチベーションが低い時こそ、自分の価値観を思い出す良い機会です。何を大切にしたいですか？',
      '今日できる小さなことから始めましょう。完璧である必要はありません。',
    ],
    'task_completion': [
      '素晴らしいです！一歩ずつ進んでいますね。',
      'よくできました！この調子で続けていきましょう。',
      '完了おめでとうございます！着実に前進しています。',
    ],
    'general': [
      'お話を聞かせていただきありがとうございます。一緒に考えていきましょう。',
      'あなたの気持ちを大切にしながら、次のステップを考えていきましょう。',
      '今のあなたの状態を理解しました。どのようにサポートできるでしょうか。',
    ],
  };

  /// マイクロ・チャンキング用のフォールバックテンプレート
  static const String _microChunkingTemplate = '''
このタスクを5分以内のステップに分解します：

1. 最初の具体的な行動を決める（2分）
2. 必要な道具や情報を準備する（2分）
3. 実際に作業を開始する（1分）

各ステップは具体的で実行可能です。
''';

  /// ユーザー入力に基づいてフォールバック応答を生成
  String generateFallbackResponse(String userInput) {
    final input = userInput.toLowerCase();

    // 感情キーワードの検出
    if (_containsNegativeEmotion(input)) {
      return _getRandomResponse('negative_emotion');
    } else if (_containsSelfCriticism(input)) {
      return _getRandomResponse('self_criticism');
    } else if (_containsLowMotivation(input)) {
      return _getRandomResponse('motivation_low');
    } else if (_containsTaskCompletion(input)) {
      return _getRandomResponse('task_completion');
    }

    return _getRandomResponse('general');
  }

  /// マイクロ・チャンキングのフォールバック応答
  String generateMicroChunkingFallback(String taskTitle) {
    return '''
「$taskTitle」を小さなステップに分解します：

1. タスクの最初の具体的な行動を決める（2分）
2. 必要な準備をする（2分）
3. 実際に作業を開始する（1分）

オンライン接続が復旧したら、より詳細な分解を提供できます。
''';
  }

  /// ACT対話のフォールバック応答
  String generateACTFallback(String emotionType) {
    switch (emotionType) {
      case 'anxious':
      case 'sad':
        return _getRandomResponse('negative_emotion');
      case 'angry':
        return '怒りの感情を感じているのですね。その感情を否定せず、ただ観察してみましょう。';
      case 'tired':
        return '疲れを感じているのですね。休息も大切な行動です。無理をせず、できることから始めましょう。';
      default:
        return _getRandomResponse('general');
    }
  }

  bool _containsNegativeEmotion(String input) {
    const negativeKeywords = [
      'つらい',
      '悲しい',
      '不安',
      '心配',
      '怖い',
      '苦しい',
      '辛い',
      '落ち込',
    ];
    return negativeKeywords.any((keyword) => input.contains(keyword));
  }

  bool _containsSelfCriticism(String input) {
    const criticismKeywords = [
      'ダメ',
      '駄目',
      '無理',
      'できない',
      '失敗',
      '情けない',
      '価値がない',
    ];
    return criticismKeywords.any((keyword) => input.contains(keyword));
  }

  bool _containsLowMotivation(String input) {
    const motivationKeywords = [
      'やる気',
      'モチベーション',
      '続かない',
      '諦め',
      '意味がない',
    ];
    return motivationKeywords.any((keyword) => input.contains(keyword));
  }

  bool _containsTaskCompletion(String input) {
    const completionKeywords = [
      '完了',
      '終わった',
      'できた',
      '達成',
      '終了',
    ];
    return completionKeywords.any((keyword) => input.contains(keyword));
  }

  String _getRandomResponse(String category) {
    final responses =
        _fallbackResponses[category] ?? _fallbackResponses['general']!;
    final index = DateTime.now().millisecondsSinceEpoch % responses.length;
    return responses[index];
  }
}
