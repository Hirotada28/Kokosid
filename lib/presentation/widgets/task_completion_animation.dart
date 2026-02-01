import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/services/task_completion_animation_service.dart';

/// タスク完了アニメーション表示ウィジェット
class TaskCompletionAnimation extends StatefulWidget {
  const TaskCompletionAnimation({
    required this.config,
    required this.onComplete,
    super.key,
  });

  final CompletionAnimationConfig config;
  final VoidCallback onComplete;

  @override
  State<TaskCompletionAnimation> createState() =>
      _TaskCompletionAnimationState();
}

class _TaskCompletionAnimationState extends State<TaskCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    if (widget.config.isLoop) {
      // ループアニメーション
      _controller.repeat();
    } else {
      // 単発アニメーション
      _controller.forward().then((_) {
        // アニメーション完了後にコールバックを呼ぶ
        if (mounted) {
          widget.onComplete();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                _getAssetPath(),
                controller: _controller,
                onLoaded: (composition) {
                  if (!widget.config.isLoop && widget.config.duration != null) {
                    _controller.duration = widget.config.duration;
                  } else {
                    _controller.duration = composition.duration;
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getDescriptionText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.config.isLoop) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.onComplete,
                child: const Text('閉じる'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getAssetPath() {
    switch (widget.config.type) {
      case CompletionAnimationType.sparkle:
        return 'assets/animations/sparkle_star.json';
      case CompletionAnimationType.confetti:
        return 'assets/animations/confetti.json';
      case CompletionAnimationType.streakFlame:
        return 'assets/animations/streak_flame.json';
    }
  }

  String _getDescriptionText() {
    switch (widget.config.type) {
      case CompletionAnimationType.sparkle:
        return 'タスク完了！';
      case CompletionAnimationType.confetti:
        return '素晴らしい！';
      case CompletionAnimationType.streakFlame:
        return '🔥 ${widget.config.streakCount}連続達成！';
    }
  }
}

/// タスク完了アニメーションを表示するヘルパー関数
Future<void> showTaskCompletionAnimation(
  BuildContext context,
  CompletionAnimationConfig config,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => TaskCompletionAnimation(
      config: config,
      onComplete: () {
        Navigator.of(context).pop();
      },
    ),
  );
}
