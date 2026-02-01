import 'package:flutter/material.dart';

/// 挨拶ヘッダーウィジェット
/// 時間帯に応じた挨拶とユーザー名を表示
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    const userName = 'あなた'; // 実際の実装ではユーザー名を取得

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$userNameさん',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getMotivationalMessage(now.hour),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  /// 時間帯に応じた挨拶を取得
  String _getGreeting(int hour) {
    if (hour < 6) {
      return 'おつかれさまです';
    } else if (hour < 10) {
      return 'おはようございます';
    } else if (hour < 18) {
      return 'こんにちは';
    } else {
      return 'こんばんは';
    }
  }

  /// 時間帯に応じたモチベーションメッセージを取得
  String _getMotivationalMessage(int hour) {
    if (hour < 6) {
      return '夜更かしですね。無理をせず、ゆっくり休んでください。';
    } else if (hour < 10) {
      return '新しい一日の始まりです。今日も一歩ずつ進んでいきましょう。';
    } else if (hour < 18) {
      return '今日はどんな一日でしたか？小さな達成も大切にしてください。';
    } else {
      return '一日お疲れさまでした。今日の頑張りを振り返ってみませんか？';
    }
  }
}
