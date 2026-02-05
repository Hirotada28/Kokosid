import 'package:flutter/material.dart';

import '../../core/repositories/self_esteem_repository.dart';
import '../../core/services/database_service.dart';

/// 長期成長トレンドチャートウィジェット
/// 30日間の平均+0.15ポイント向上を目標として可視化
class LongTermGrowthChart extends StatefulWidget {
  const LongTermGrowthChart({super.key, this.userUuid});
  final String? userUuid;

  @override
  State<LongTermGrowthChart> createState() => _LongTermGrowthChartState();
}

class _LongTermGrowthChartState extends State<LongTermGrowthChart> {
  bool _isLoading = true;
  double _currentAverage = 0.0;
  double _previousAverage = 0.0;
  double _growthRate = 0.0;
  bool _isOnTrack = false;

  @override
  void initState() {
    super.initState();
    _loadGrowthData();
  }

  Future<void> _loadGrowthData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userUuid = widget.userUuid ?? 'default-user';
      final databaseService = DatabaseService();
      await databaseService.initialize();
      final repository = SelfEsteemRepository(databaseService);

      // 過去30日間の平均
      final currentAverage = await repository.getAverageScore(userUuid, 30);

      // 過去60日間の平均（30日前まで）
      final allScores = await repository.getRecentScores(userUuid, 60);
      double? previousAverage;
      if (allScores.length >= 30) {
        final olderScores = allScores.take(allScores.length - 30).toList();
        if (olderScores.isNotEmpty) {
          previousAverage =
              olderScores.fold<double>(0.0, (sum, score) => sum + score.score) /
                  olderScores.length;
        }
      }

      // 成長率を計算
      var growthRate = 0.0;
      var isOnTrack = false;
      if (currentAverage != null && previousAverage != null) {
        growthRate = currentAverage - previousAverage;
        isOnTrack = growthRate >= 0.15; // 目標: +0.15ポイント
      }

      if (mounted) {
        setState(() {
          _currentAverage = currentAverage ?? 0.0;
          _previousAverage = previousAverage ?? 0.0;
          _growthRate = growthRate;
          _isOnTrack = isOnTrack;
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.timeline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '長期成長トレンド（30日間）',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 成長率表示
          _buildGrowthRateCard(theme),
          const SizedBox(height: 16),

          // 目標達成状況
          _buildGoalProgress(theme),
          const SizedBox(height: 16),

          // 小さな進歩の可視化
          _buildSmallProgressIndicators(theme),
        ],
      ),
    );
  }

  Widget _buildGrowthRateCard(ThemeData theme) {
    final isPositive = _growthRate >= 0;
    final color = isPositive ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '成長率',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isPositive ? '+' : ''}${_growthRate.toStringAsFixed(2)} ポイント',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '前月比: ${_previousAverage.toStringAsFixed(2)} → ${_currentAverage.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(ThemeData theme) {
    const targetGrowth = 0.15;
    final progress = (_growthRate / targetGrowth).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '目標達成度',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isOnTrack ? Colors.green : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            _isOnTrack ? Colors.green : theme.colorScheme.primary,
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Text(
          _isOnTrack ? '🎯 目標達成！素晴らしい成長です' : '目標: 30日間で+0.15ポイント向上',
          style: theme.textTheme.bodySmall?.copyWith(
            color: _isOnTrack
                ? Colors.green
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: _isOnTrack ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallProgressIndicators(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '小さな進歩の記録',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildProgressChip(
                theme,
                '継続中',
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildProgressChip(
                theme,
                '安定成長',
                Icons.trending_up,
                Colors.green,
              ),
              if (_isOnTrack)
                _buildProgressChip(
                  theme,
                  '目標達成',
                  Icons.emoji_events,
                  Colors.amber,
                ),
            ],
          ),
        ],
      );

  Widget _buildProgressChip(
          ThemeData theme, String label, IconData icon, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
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
