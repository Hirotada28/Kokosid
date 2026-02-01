import 'package:flutter/material.dart';

import '../widgets/achievement_list.dart';
import '../widgets/greeting_header.dart';
import '../widgets/mood_selector.dart';
import '../widgets/task_suggestion_card.dart';

/// 今日タブ画面
/// 気分選択、次のタスク提案、小さな達成リストを表示
class TodayTabScreen extends StatefulWidget {
  const TodayTabScreen({super.key});

  @override
  State<TodayTabScreen> createState() => _TodayTabScreenState();
}

class _TodayTabScreenState extends State<TodayTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // タブ切り替え時に状態を保持

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin用

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
              // ヘッダー部分
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GreetingHeader(),
                      const SizedBox(height: 24),

                      // 気分選択セクション
                      _buildSectionHeader(
                        context,
                        '今の気分はいかがですか？',
                        Icons.mood,
                      ),
                      const SizedBox(height: 16),
                      const MoodSelector(),
                      const SizedBox(height: 32),

                      // 次のタスク提案セクション
                      _buildSectionHeader(
                        context,
                        '今日のおすすめタスク',
                        Icons.lightbulb_outline,
                      ),
                      const SizedBox(height: 16),
                      const TaskSuggestionCard(),
                      const SizedBox(height: 32),

                      // 小さな達成セクション
                      _buildSectionHeader(
                        context,
                        '今日の小さな達成',
                        Icons.celebration_outlined,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // 達成リスト（スクロール可能）
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AchievementList(),
                ),
              ),

              // 下部余白
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// セクションヘッダーを構築
  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// フローティングアクションボタンを構築
  Widget _buildFloatingActionButton(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: _onAddTask,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      icon: const Icon(Icons.add),
      label: const Text('タスク追加'),
      tooltip: '新しいタスクを追加',
    );
  }

  /// リフレッシュ処理
  Future<void> _onRefresh() async {
    // データを再読み込み
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        // 状態を更新
      });
    }
  }

  /// タスク追加処理
  void _onAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: _buildAddTaskBottomSheet,
    );
  }

  /// タスク追加ボトムシート
  Widget _buildAddTaskBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // ハンドル
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ヘッダー
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'タスクを追加',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(),

          // コンテンツ
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'タスクの内容',
                      hintText: '例：メールの返信をする',
                      prefixIcon: const Icon(Icons.task_alt),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // タスク追加処理
                        Navigator.of(context).pop();
                        _showTaskAddedSnackBar();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('追加する'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// タスク追加完了のスナックバー
  void _showTaskAddedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('タスクを追加しました'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
