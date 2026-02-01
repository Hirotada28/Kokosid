import 'package:flutter/material.dart';

import '../../core/repositories/journal_repository.dart';
import '../../core/repositories/self_esteem_repository.dart';
import '../../core/repositories/task_repository.dart';
import '../../core/services/database_service.dart';
import '../../core/services/encryption_service.dart';

/// 月間統計カードウィジェット
class MonthlyStatsCard extends StatefulWidget {
  const MonthlyStatsCard({super.key, this.userUuid});
  final String? userUuid;

  @override
  State<MonthlyStatsCard> createState() => _MonthlyStatsCardState();
}

class _MonthlyStatsCardState extends State<MonthlyStatsCard> {
  bool _isLoading = true;
  int _completedTasks = 0;
  int _journalEntries = 0;
  int _consecutiveDays = 0;
  double _averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userUuid = widget.userUuid ?? 'default-user';
      final databaseService = DatabaseService();
      await databaseService.initialize();

      final taskRepo = TaskRepository(databaseService);
      final encryptionService = EncryptionService();
      await encryptionService.initialize();
      final journalRepo = JournalRepository(databaseService, encryptionService);
      final scoreRepo = SelfEsteemRepository(databaseService);

      // 今月の開始日と終了日
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month);
      final endOfMonth = DateTime(now.year, now.month + 1);

      // 完了タスク数
      final completedTasks = await taskRepo.getCompletedTaskCount(
          userUuid, startOfMonth, endOfMonth);

      // 日記エントリ数
      final journalEntries = (await journalRepo.getEntriesByDateRange(
              userUuid, startOfMonth, endOfMonth))
          .length;

      // 継続日数（簡易計算）
      final consecutiveDays = await _calculateConsecutiveDays(
        taskRepo,
        journalRepo,
        userUuid,
      );

      // 平均スコア
      final averageScore = await scoreRepo.getAverageScore(userUuid, 30) ?? 0.0;

      if (mounted) {
        setState(() {
          _completedTasks = completedTasks;
          _journalEntries = journalEntries;
          _consecutiveDays = consecutiveDays;
          _averageScore = averageScore;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<int> _calculateConsecutiveDays(
    TaskRepository taskRepo,
    JournalRepository journalRepo,
    String userUuid,
  ) async {
    final today = DateTime.now();
    var consecutiveDays = 0;

    for (var i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final startOfDay =
          DateTime(checkDate.year, checkDate.month, checkDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final taskCount =
          await taskRepo.getTotalTaskCount(userUuid, startOfDay, endOfDay);
      final journalCount = (await journalRepo.getEntriesByDateRange(
              userUuid, startOfDay, endOfDay))
          .length;

      if (taskCount > 0 || journalCount > 0) {
        consecutiveDays++;
      } else {
        break;
      }
    }

    return consecutiveDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem(context, '完了タスク', _completedTasks.toString(),
                  Icons.task_alt, Colors.blue),
              const SizedBox(width: 16),
              _buildStatItem(context, '対話回数', _journalEntries.toString(),
                  Icons.chat_bubble, Colors.purple),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(context, '継続日数', _consecutiveDays.toString(),
                  Icons.calendar_today, Colors.green),
              const SizedBox(width: 16),
              _buildStatItem(context, '平均スコア', _averageScore.toStringAsFixed(2),
                  Icons.trending_up, Colors.orange),
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
          color: color.withValues(alpha: 0.1),
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
