import 'package:flutter/material.dart';

import '../widgets/dialogue_history.dart';
import '../widgets/emotion_tags.dart';
import '../widgets/voice_input_button.dart';

/// 対話タブ画面
/// 音声入力ボタン、過去の対話履歴、感情タグを表示
class DialogueTabScreen extends StatefulWidget {
  const DialogueTabScreen({super.key});

  @override
  State<DialogueTabScreen> createState() => _DialogueTabScreenState();
}

class _DialogueTabScreenState extends State<DialogueTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isRecording = false;

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
                    // 音声入力セクション
                    SliverToBoxAdapter(
                      child: _buildVoiceInputSection(context),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
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

  /// 音声入力セクションを構築
  Widget _buildVoiceInputSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _isRecording ? '録音中...' : '気持ちを話してみませんか？',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _isRecording ? 'タップして録音を停止' : 'ボタンを押して音声で気持ちを記録できます',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          VoiceInputButton(
            isRecording: _isRecording,
            onRecordingChanged: (isRecording) {
              setState(() {
                _isRecording = isRecording;
              });
            },
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
            Text('🎤 音声録音'),
            Text('ボタンを押して気持ちを音声で記録できます。'),
            SizedBox(height: 12),
            Text('🤖 AI応答'),
            Text('あなたの気持ちに寄り添った応答を生成します。'),
            SizedBox(height: 12),
            Text('😊 感情分析'),
            Text('音声から感情を分析し、適切なサポートを提供します。'),
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
}
