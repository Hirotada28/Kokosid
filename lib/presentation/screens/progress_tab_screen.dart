import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/repositories/journal_repository.dart';
import '../../core/repositories/self_esteem_repository.dart';
import '../../core/repositories/task_repository.dart';
import '../../core/services/database_service.dart';
import '../../core/services/encryption_service.dart';
import '../../core/services/self_esteem_calculator.dart';
import '../widgets/growth_trend_indicator.dart';
import '../widgets/long_term_growth_chart.dart';
import '../widgets/monthly_stats_card.dart';
import '../widgets/progress_approval_banner.dart';
import '../widgets/self_esteem_chart.dart';

/// 軌跡タブ画面
/// 自己肯定感グラフ、月間達成統計、成長トレンドを表示
class ProgressTabScreen extends StatefulWidget {
  const ProgressTabScreen({super.key, this.userUuid});
  final String? userUuid;

  @override
  State<ProgressTabScreen> createState() => _ProgressTabScreenState();
}

class _ProgressTabScreenState extends State<ProgressTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _selectedPeriod = '7日間';
  final List<String> _periods = ['7日間', '30日間', '3ヶ月', '1年間'];

  double? _currentScore;
  double? _previousScore;
  String? _currentLevel;
  bool _isLoadingScore = true;
  SelfEsteemCalculator? _calculator;

  @override
  void initState() {
    super.initState();
    _loadCurrentScore();
  }

  Future<void> _loadCurrentScore() async {
    if (!mounted) return;

    setState(() {
      _isLoadingScore = true;
    });

    try {
      final userUuid = widget.userUuid ?? 'default-user';
      final databaseService = DatabaseService();
      await databaseService.initialize();
      final repository = SelfEsteemRepository(databaseService);
      final taskRepo = TaskRepository(databaseService);

      // EncryptionServiceを別途初期化
      final encryptionService = EncryptionService();
      await encryptionService.initialize();
      final journalRepo = JournalRepository(databaseService, encryptionService);

      // 計算機を初期化
      _calculator = SelfEsteemCalculator(taskRepo, journalRepo, repository);

      final latestScore = await repository.getLatestScore(userUuid);
      final recentScores = await repository.getRecentScores(userUuid, 7);

      double? previousScore;
      if (recentScores.length >= 2) {
        previousScore = recentScores[recentScores.length - 2].score;
      }

      if (mounted) {
        setState(() {
          _currentScore = latestScore?.score;
          _previousScore = previousScore;
          _currentLevel = latestScore?.getLevel().name;
          _isLoadingScore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingScore = false;
        });
      }
    }
  }

  String get _userUuid => widget.userUuid ?? 'default-user';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildPeriodSelector(context)),
              // 進歩承認バナー
              if (_calculator != null)
                SliverToBoxAdapter(
                  child: ProgressApprovalBanner(
                    calculator: _calculator!,
                    userUuid: _userUuid,
                  ),
                ),
              SliverToBoxAdapter(child: _buildSelfEsteemSection(context)),
              SliverToBoxAdapter(child: _buildGrowthTrendSection(context)),
              // 長期成長トレンド
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: LongTermGrowthChart(userUuid: _userUuid),
                ),
              ),
              SliverToBoxAdapter(child: _buildMonthlyStatsSection(context)),
              SliverToBoxAdapter(child: _buildInsightsSection(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.trending_up, size: 28, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('成長の軌跡',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text('あなたの心の成長を可視化',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7))),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: _showExportDialog,
              icon: const Icon(Icons.file_download_outlined)),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final isSelected = period == _selectedPeriod;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedPeriod = period);
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelfEsteemSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('自己肯定感の推移',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                  onPressed: _showScoreDetails,
                  icon: const Icon(Icons.info_outline, size: 20)),
            ],
          ),
          const SizedBox(height: 16),
          _buildCurrentScore(context),
          const SizedBox(height: 20),
          SizedBox(
              height: 200,
              child: SelfEsteemChart(
                  period: _selectedPeriod, userUuid: _userUuid)),
        ],
      ),
    );
  }

  Widget _buildCurrentScore(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoadingScore) {
      return Container(
          padding: const EdgeInsets.all(16),
          child: const Center(child: CircularProgressIndicator()));
    }
    if (_currentScore == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Text('データがありません。タスクや日記を記録してください。',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
      );
    }
    final scoreDiff =
        _previousScore != null ? _currentScore! - _previousScore! : 0.0;
    final isImproving = scoreDiff > 0;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('現在のスコア',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_currentScore!.toStringAsFixed(2),
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary)),
                    if (_previousScore != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: (isImproving ? Colors.green : Colors.orange)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                isImproving
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                size: 12,
                                color: isImproving
                                    ? Colors.green[700]
                                    : Colors.orange[700]),
                            const SizedBox(width: 2),
                            Text(
                                '${isImproving ? '+' : ''}${scoreDiff.toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: isImproving
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(_getLevelLabel(_currentLevel),
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getLevelLabel(String? level) {
    switch (level) {
      case 'excellent':
        return '素晴らしい状態です';
      case 'good':
        return '良い調子です';
      case 'fair':
        return '順調です';
      case 'poor':
        return '少し疲れているようです';
      case 'veryPoor':
        return '休息が必要です';
      default:
        return 'データを記録中';
    }
  }

  Widget _buildGrowthTrendSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('成長トレンド',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          GrowthTrendIndicator(userUuid: _userUuid),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('今月の統計',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          MonthlyStatsCard(userUuid: _userUuid),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('AIからのインサイト',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📈 成長のポイント',
                    style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary)),
                const SizedBox(height: 8),
                Text('最近1週間で自己肯定感が着実に向上しています。特に小さなタスクの完了が継続的な成長につながっているようです。',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadCurrentScore();
    if (mounted) setState(() {});
  }

  Future<void> _showScoreDetails() async {
    try {
      final databaseService = DatabaseService();
      await databaseService.initialize();
      final repository = SelfEsteemRepository(databaseService);
      final latestScore = await repository.getLatestScore(_userUuid);
      if (!mounted) return;
      if (latestScore == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('スコアデータがありません'),
            behavior: SnackBarBehavior.floating));
        return;
      }
      Map<String, dynamic>? calculationBasis;
      if (latestScore.calculationBasisJson != null) {
        calculationBasis = jsonDecode(latestScore.calculationBasisJson!)
            as Map<String, dynamic>;
      }
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _buildScoreDetailsBottomSheet(
              context, latestScore, calculationBasis));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('エラーが発生しました: $e'),
            behavior: SnackBarBehavior.floating));
      }
    }
  }

  Widget _buildScoreDetailsBottomSheet(BuildContext context, dynamic score,
      Map<String, dynamic>? calculationBasis) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height * 0.6,
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('スコアの詳細',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('スコア構成要素',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('各要素の重み: 完了率30%、感情40%、継続20%、対話10%',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6))),
                  const SizedBox(height: 16),
                  if (calculationBasis != null) ...[
                    _buildScoreComponent(
                        'タスク完了率',
                        calculationBasis['completionRate'] as double? ?? 0.0,
                        0.3,
                        Colors.blue),
                    _buildScoreComponent(
                        'ポジティブ感情',
                        calculationBasis['positiveRatio'] as double? ?? 0.0,
                        0.4,
                        Colors.green),
                    _buildScoreComponent(
                        '継続日数',
                        calculationBasis['streakScore'] as double? ?? 0.0,
                        0.2,
                        Colors.orange),
                    _buildScoreComponent(
                        'AI対話頻度',
                        calculationBasis['engagementScore'] as double? ?? 0.0,
                        0.1,
                        Colors.purple),
                  ] else ...[
                    _buildScoreComponent('タスク完了率', 0.0, 0.3, Colors.blue),
                    _buildScoreComponent('ポジティブ感情', 0.0, 0.4, Colors.green),
                    _buildScoreComponent('継続日数', 0.0, 0.2, Colors.orange),
                    _buildScoreComponent('AI対話頻度', 0.0, 0.1, Colors.purple),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreComponent(
      String label, double value, double weight, Color color) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('${(value * 100).toInt()}% (重み: ${(weight * 100).toInt()}%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7))),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
              value: value,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color)),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('データをエクスポート'),
        content: const Text('成長データをCSVファイルとしてエクスポートしますか？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportData();
              },
              child: const Text('エクスポート')),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('データをエクスポートしました'), behavior: SnackBarBehavior.floating));
  }
}
