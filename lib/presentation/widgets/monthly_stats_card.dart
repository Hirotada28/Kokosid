import 'package:flutter/material.dart';

/// 月間統計カードウィジェット
class MonthlyStatsCard extends StatelessWidget {
  const MonthlyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem(
                  context, '完了タスク', '24', Icons.task_alt, Colors.blue),
              const SizedBox(width: 16),
              _buildStatItem(
                  context, '対話回数', '12', Icons.chat_bubble, Colors.purple),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                  context, '継続日数', '7', Icons.calendar_today, Colors.green),
              const SizedBox(width: 16),
              _buildStatItem(
                  context, '平均スコア', '0.75', Icons.trending_up, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
