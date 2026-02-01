import 'package:flutter/material.dart';

/// 感情タグウィジェット
class EmotionTags extends StatelessWidget {
  const EmotionTags({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // サンプルデータ
    final emotions = ['😊 嬉しい', '😌 穏やか', '😴 疲れた'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: emotions
          .map((emotion) => Chip(
                label: Text(emotion),
                backgroundColor: theme.colorScheme.surface,
              ))
          .toList(),
    );
  }
}
