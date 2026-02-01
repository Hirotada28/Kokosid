import 'package:flutter/material.dart';

/// タスク提案カードウィジェット
/// AIが提案する次のタスクを表示
class TaskSuggestionCard extends StatelessWidget {
  const TaskSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // サンプルデータ（実際の実装ではAIから取得）
    final suggestion = TaskSuggestion(
      title: 'メールの返信をする',
      description: '未読メールが3件あります。5分で確認してみませんか？',
      estimatedMinutes: 5,
      difficulty: TaskDifficulty.easy,
      reason: '短時間で完了でき、達成感を得やすいタスクです',
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AIからの提案',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      suggestion.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDifficultyChip(context, suggestion.difficulty),
            ],
          ),

          const SizedBox(height: 16),

          // 説明
          Text(
            suggestion.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 12),

          // 詳細情報
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '約${suggestion.estimatedMinutes}分',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.psychology,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  suggestion.reason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // アクションボタン
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _onSkipTask(context),
                  icon: const Icon(Icons.skip_next, size: 18),
                  label: const Text('別の提案'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _onAcceptTask(context, suggestion),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('始める'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 難易度チップを構築
  Widget _buildDifficultyChip(BuildContext context, TaskDifficulty difficulty) {
    final theme = Theme.of(context);

    Color color;
    String label;
    IconData icon;

    switch (difficulty) {
      case TaskDifficulty.easy:
        color = Colors.green;
        label = '簡単';
        icon = Icons.sentiment_satisfied;
        break;
      case TaskDifficulty.medium:
        color = Colors.orange;
        label = '普通';
        icon = Icons.sentiment_neutral;
        break;
      case TaskDifficulty.hard:
        color = Colors.red;
        label = '難しい';
        icon = Icons.sentiment_dissatisfied;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// タスクをスキップ
  void _onSkipTask(BuildContext context) {
    // 新しい提案を取得
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('新しい提案を取得中...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// タスクを受け入れ
  void _onAcceptTask(BuildContext context, TaskSuggestion suggestion) {
    // タスクを開始
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.rocket_launch),
            SizedBox(width: 8),
            Text('タスクを開始'),
          ],
        ),
        content: Text(
            '「${suggestion.title}」を開始しますか？\n\nマイクロタスクに分解して、一歩ずつ進めていきましょう。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startTask(context, suggestion);
            },
            child: const Text('開始する'),
          ),
        ],
      ),
    );
  }

  /// タスクを開始
  void _startTask(BuildContext context, TaskSuggestion suggestion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「${suggestion.title}」を開始しました'),
        action: SnackBarAction(
          label: '詳細',
          onPressed: () {
            // タスク詳細画面に移動
          },
        ),
      ),
    );
  }
}

/// タスク提案データ
class TaskSuggestion {
  TaskSuggestion({
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.reason,
  });
  final String title;
  final String description;
  final int estimatedMinutes;
  final TaskDifficulty difficulty;
  final String reason;
}

/// タスク難易度
enum TaskDifficulty {
  easy,
  medium,
  hard,
}
