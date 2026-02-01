import 'package:flutter/material.dart';

/// 達成リストウィジェット
/// 今日の小さな達成を表示
class AchievementList extends StatelessWidget {
  const AchievementList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // サンプルデータ
    final achievements = [
      Achievement(
        title: 'メールを3件返信',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: AchievementType.task,
      ),
      Achievement(
        title: '気分を記録',
        time: DateTime.now().subtract(const Duration(hours: 4)),
        type: AchievementType.mood,
      ),
      Achievement(
        title: 'AIと対話',
        time: DateTime.now().subtract(const Duration(hours: 6)),
        type: AchievementType.dialogue,
      ),
    ];

    if (achievements.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: achievements
          .map((achievement) => _AchievementItem(achievement: achievement))
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
            Icons.celebration_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '今日の達成はまだありません',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '小さなことでも大丈夫です\n一歩ずつ進んでいきましょう',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  const _AchievementItem({required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.type.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              achievement.type.icon,
              size: 20,
              color: achievement.type.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(achievement.time),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }
}

class Achievement {
  Achievement({
    required this.title,
    required this.time,
    required this.type,
  });
  final String title;
  final DateTime time;
  final AchievementType type;
}

enum AchievementType {
  task(Icons.task_alt, Colors.blue),
  mood(Icons.mood, Colors.orange),
  dialogue(Icons.chat_bubble, Colors.purple);

  const AchievementType(this.icon, this.color);

  final IconData icon;
  final Color color;
}
