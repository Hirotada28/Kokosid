import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/models/self_esteem_score.dart';
import '../../core/repositories/self_esteem_repository.dart';
import '../../core/services/database_service.dart';

/// 自己肯定感チャートウィジェット
class SelfEsteemChart extends StatefulWidget {
  const SelfEsteemChart({super.key, required this.period, this.userUuid});
  final String period;
  final String? userUuid;

  @override
  State<SelfEsteemChart> createState() => _SelfEsteemChartState();
}

class _SelfEsteemChartState extends State<SelfEsteemChart> {
  List<SelfEsteemScore> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  @override
  void didUpdateWidget(SelfEsteemChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _loadScores();
    }
  }

  Future<void> _loadScores() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userUuid = widget.userUuid ?? 'default-user';
      final databaseService = DatabaseService();
      await databaseService.initialize();
      final repository = SelfEsteemRepository(databaseService);

      final days = _getDaysFromPeriod(widget.period);
      final scores = await repository.getRecentScores(userUuid, days);

      if (mounted) {
        setState(() {
          _scores = scores;
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

  int _getDaysFromPeriod(String period) {
    switch (period) {
      case '7日間':
        return 7;
      case '30日間':
        return 30;
      case '3ヶ月':
        return 90;
      case '1年間':
        return 365;
      default:
        return 7;
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

    if (_scores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'データがありません',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'タスクや日記を記録すると\nグラフが表示されます',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: LineChart(
        _buildChartData(theme),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData _buildChartData(ThemeData theme) {
    final spots = <FlSpot>[];

    for (var i = 0; i < _scores.length; i++) {
      spots.add(FlSpot(i.toDouble(), _scores[i].score));
    }

    return LineChartData(
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 0.2,
        getDrawingHorizontalLine: (value) => FlLine(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _getBottomInterval(),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= _scores.length) {
                return const SizedBox.shrink();
              }

              final score = _scores[value.toInt()];
              final date = score.measuredAt;

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${date.month}/${date.day}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.2,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(1),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          left: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      minX: 0,
      maxX: (_scores.length - 1).toDouble(),
      minY: 0,
      maxY: 1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: theme.colorScheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 4,
              color: theme.colorScheme.primary,
              strokeWidth: 2,
              strokeColor: theme.colorScheme.surface,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
            final score = _scores[spot.x.toInt()];
            final date = score.measuredAt;
            return LineTooltipItem(
              '${date.month}/${date.day}\n${spot.y.toStringAsFixed(2)}',
              TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getBottomInterval() {
    if (_scores.length <= 7) {
      return 1;
    } else if (_scores.length <= 30) {
      return 5;
    } else if (_scores.length <= 90) {
      return 15;
    } else {
      return 30;
    }
  }
}
