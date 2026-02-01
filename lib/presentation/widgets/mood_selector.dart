import 'package:flutter/material.dart';

/// 気分選択ウィジェット
/// 6つの感情から現在の気分を選択
class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;

  final List<MoodOption> _moods = [
    MoodOption(
      id: 'happy',
      emoji: '😊',
      label: '嬉しい',
      color: Colors.yellow,
    ),
    MoodOption(
      id: 'calm',
      emoji: '😌',
      label: '穏やか',
      color: Colors.green,
    ),
    MoodOption(
      id: 'neutral',
      emoji: '😐',
      label: '普通',
      color: Colors.grey,
    ),
    MoodOption(
      id: 'tired',
      emoji: '😴',
      label: '疲れた',
      color: Colors.blue,
    ),
    MoodOption(
      id: 'anxious',
      emoji: '😰',
      label: '不安',
      color: Colors.orange,
    ),
    MoodOption(
      id: 'sad',
      emoji: '😢',
      label: '悲しい',
      color: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
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
          if (_selectedMood != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '気分を記録しました',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _moods.length,
            itemBuilder: (context, index) {
              final mood = _moods[index];
              final isSelected = _selectedMood == mood.id;

              return _MoodButton(
                mood: mood,
                isSelected: isSelected,
                onTap: () => _onMoodSelected(mood.id),
              );
            },
          ),
          if (_selectedMood != null) ...[
            const SizedBox(height: 16),
            Text(
              'この気分について詳しく話してみませんか？',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToDialogue,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('対話タブで話す'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onMoodSelected(String moodId) {
    setState(() {
      _selectedMood = moodId;
    });

    // 気分を保存する処理
    _saveMood(moodId);

    // ハプティックフィードバック
    // HapticFeedback.lightImpact();
  }

  void _saveMood(String moodId) {
    // 実際の実装では気分をデータベースに保存
    debugPrint('気分を保存: $moodId');
  }

  void _navigateToDialogue() {
    // 対話タブに移動
    // DefaultTabController.of(context)?.animateTo(1);
  }
}

/// 気分オプションデータ
class MoodOption {
  MoodOption({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
  });
  final String id;
  final String emoji;
  final String label;
  final Color color;
}

/// 気分選択ボタン
class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });
  final MoodOption mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected
            ? mood.color.withValues(alpha: 0.2)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? mood.color
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  mood.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isSelected ? mood.color : theme.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
