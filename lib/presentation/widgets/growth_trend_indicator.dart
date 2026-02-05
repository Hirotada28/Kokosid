import 'package:flutter/material.dart';

import '../../core/repositories/self_esteem_repository.dart';
import '../../core/services/database_service.dart';

/// 成長トレンド指標ウィジェット
class GrowthTrendIndicator extends StatefulWidget {
  const GrowthTrendIndicator({super.key, this.userUuid});
  final String? userUuid;

  @override
  State<GrowthTrendIndicator> createState() => _GrowthTrendIndicatorState();
}

class _GrowthTrendIndicatorState extends State<GrowthTrendIndicator> {
  bool _isLoading = true;
  ScoreTrend _trend = ScoreTrend.stable;
  double _changePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTrend();
  }

  Future<void> _loadTrend() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userUuid = widget.userUuid ?? 'default-user';
      final databaseService = DatabaseService();
      await databaseService.initialize();
      final repository = SelfEsteemRepository(databaseService);

      final trend = await repository.getScoreTrend(userUuid, 7);
      final scores = await repository.getRecentScores(userUuid, 7);

      var changePercentage = 0.0;
      if (scores.length >= 2) {
        final latest = scores.last.score;
        final oldest = scores.first.score;
        if (oldest > 0) {
          changePercentage = ((latest - oldest) / oldest) * 100;
        }
      }

      if (mounted) {
        setState(() {
          _trend = trend;
          _changePercentage = changePercentage;
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

    final trendData = _getTrendData(_trend);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: trendData.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              trendData.icon,
              color: trendData.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '成長トレンド: ${trendData.label}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: trendData.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _changePercentage >= 0
                      ? '過去1週間で自己肯定感が+${_changePercentage.abs().toStringAsFixed(0)}%向上しています'
                      : '過去1週間で自己肯定感が${_changePercentage.abs().toStringAsFixed(0)}%低下しています',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TrendData _getTrendData(ScoreTrend trend) {
    switch (trend) {
      case ScoreTrend.improving:
        return _TrendData(
          label: '改善中',
          icon: Icons.trending_up,
          color: Colors.green,
        );
      case ScoreTrend.declining:
        return _TrendData(
          label: '低下中',
          icon: Icons.trending_down,
          color: Colors.orange,
        );
      case ScoreTrend.stable:
        return _TrendData(
          label: '安定',
          icon: Icons.trending_flat,
          color: Colors.blue,
        );
    }
  }
}

class _TrendData {
  _TrendData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
