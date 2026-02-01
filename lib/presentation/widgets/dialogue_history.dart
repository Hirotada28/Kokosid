import 'package:flutter/material.dart';

/// 対話履歴ウィジェット
class DialogueHistory extends StatelessWidget {
  const DialogueHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // サンプルデータ
    final dialogues = [
      DialogueEntry(
        userMessage: '今日は仕事で失敗してしまって、落ち込んでいます...',
        aiResponse:
            'つらい気持ちをお聞かせいただき、ありがとうございます。失敗は誰にでもあることですし、それを乗り越えることで成長できます。今日の失敗から何か学べることはありましたか？',
        emotion: 'sad',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DialogueEntry(
        userMessage: '新しいプロジェクトが始まって、ワクワクしています！',
        aiResponse:
            '新しいチャレンジに対するワクワク感、素晴らしいですね！そのポジティブなエネルギーを大切にしてください。どんなプロジェクトなのか、もう少し教えていただけますか？',
        emotion: 'happy',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    if (dialogues.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: dialogues
          .map((dialogue) => _DialogueItem(dialogue: dialogue))
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'まだ対話がありません',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '音声ボタンを押して\n気持ちを話してみませんか？',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DialogueItem extends StatelessWidget {
  const _DialogueItem({required this.dialogue});
  final DialogueEntry dialogue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            children: [
              _buildEmotionChip(context, dialogue.emotion),
              const Spacer(),
              Text(
                _formatTimestamp(dialogue.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ユーザーメッセージ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              dialogue.userMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // AI応答
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.psychology,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dialogue.aiResponse,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionChip(BuildContext context, String emotion) {
    final theme = Theme.of(context);

    final emotionData = _getEmotionData(emotion);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: emotionData.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emotionData.emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            emotionData.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: emotionData.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  EmotionData _getEmotionData(String emotion) {
    switch (emotion) {
      case 'happy':
        return EmotionData('😊', '嬉しい', Colors.yellow);
      case 'sad':
        return EmotionData('😢', '悲しい', Colors.blue);
      case 'anxious':
        return EmotionData('😰', '不安', Colors.orange);
      case 'tired':
        return EmotionData('😴', '疲れた', Colors.purple);
      case 'angry':
        return EmotionData('😠', '怒り', Colors.red);
      default:
        return EmotionData('😐', '普通', Colors.grey);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }
}

class DialogueEntry {
  DialogueEntry({
    required this.userMessage,
    required this.aiResponse,
    required this.emotion,
    required this.timestamp,
  });
  final String userMessage;
  final String aiResponse;
  final String emotion;
  final DateTime timestamp;
}

class EmotionData {
  EmotionData(this.emoji, this.label, this.color);
  final String emoji;
  final String label;
  final Color color;
}
