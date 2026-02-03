import 'package:flutter/material.dart';

import '../widgets/dialogue_history.dart';
import '../widgets/emotion_tags.dart';

/// 対話タブ画面
/// テキスト入力、過去の対話履歴、感情タグを表示
class DialogueTabScreen extends StatefulWidget {
  const DialogueTabScreen({super.key});

  @override
  State<DialogueTabScreen> createState() => _DialogueTabScreenState();
}

class _DialogueTabScreenState extends State<DialogueTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            _buildHeader(context),

            // メインコンテンツ
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // テキスト入力セクション
                    SliverToBoxAdapter(
                      child: _buildTextInputSection(context),
                    ),

                    // 感情タグセクション
                    SliverToBoxAdapter(
                      child: _buildEmotionSection(context),
                    ),

                    // 対話履歴セクション
                    SliverToBoxAdapter(
                      child: _buildHistorySection(context),
                    ),

                    // 対話履歴リスト
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: DialogueHistory(),
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
          ],
        ),
      ),
    );
  }

  /// ヘッダーを構築
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AIとの対話',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '心の声を聞かせてください',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _showHelpDialog,
            icon: const Icon(Icons.help_outline),
            tooltip: 'ヘルプ',
          ),
        ],
      ),
    );
  }

  /// テキスト入力セクションを構築
  Widget _buildTextInputSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '気持ちを書いてみませんか？',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'あなたの気持ちを自由に書いてください',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '今日はどんな気分ですか？',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 16),
          if (_isAnalyzing)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.send),
                label: const Text('送信'),
              ),
            ),
        ],
      ),
    );
  }

  /// 感情セクションを構築
  Widget _buildEmotionSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mood,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '最近の感情',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const EmotionTags(),
        ],
      ),
    );
  }

  /// 履歴セクションを構築
  Widget _buildHistorySection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.history,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '対話履歴',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _showAllHistory,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('すべて見る'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// リフレッシュ処理
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        // 対話履歴を再読み込み
      });
    }
  }

  /// ヘルプダイアログを表示
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline),
            SizedBox(width: 8),
            Text('対話機能について'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✍️ テキスト入力'),
            Text('気持ちをテキストで記録できます。'),
            SizedBox(height: 12),
            Text('🤖 AI応答'),
            Text('あなたの気持ちに寄り添った応答を生成します。'),
            SizedBox(height: 12),
            Text('😊 感情分析'),
            Text('テキストから感情を分析し、適切なサポートを提供します。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  /// 全履歴を表示
  void _showAllHistory() {
    Navigator.of(context).pushNamed('/dialogue_history');
  }

  /// テキスト送信ハンドラー
  Future<void> _handleSubmit() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // ここで感情分析とAI応答を処理
      await Future.delayed(const Duration(seconds: 1)); // 仮の処理

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        // 日記に保存
        await _saveToJournal(text);
        _textController.clear();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('処理に失敗しました: $e')),
        );
      }
    }
  }

  /// 日記に保存
  Future<void> _saveToJournal(String content) async {
    // ここで日記エントリを保存する処理を実装
    // JournalRepository を使用して保存
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('日記に保存しました'),
            ],
          ),
        ),
      );
    }
  }
}
