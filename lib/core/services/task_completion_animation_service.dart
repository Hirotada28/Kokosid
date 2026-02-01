import '../models/task.dart';
import 'achievement_streak_system.dart';

/// タスク完了時のアニメーション種類
enum CompletionAnimationType {
  /// キラキラ星アニメーション（5分タスク）
  sparkle,

  /// 紙吹雪アニメーション（15分タスク）
  confetti,

  /// ストリーク炎アニメーション（連続達成）
  streakFlame,
}

/// タスク完了時アニメーションシステム
class TaskCompletionAnimationService {
  TaskCompletionAnimationService({
    required AchievementStreakSystem achievementStreakSystem,
  }) : _achievementStreakSystem = achievementStreakSystem;

  final AchievementStreakSystem _achievementStreakSystem;

  /// タスク完了時に適切なアニメーションを選択
  Future<CompletionAnimationConfig> selectAnimation(
    Task completedTask,
    String userUuid,
  ) async {
    // 連続達成をチェック
    final streakCount =
        await _achievementStreakSystem.getCurrentStreak(userUuid);

    // 連続達成3個以上の場合はストリーク炎アニメーション
    if (streakCount >= AchievementStreakSystem.streakThreshold) {
      return CompletionAnimationConfig(
        type: CompletionAnimationType.streakFlame,
        duration: null, // ループアニメーション
        streakCount: streakCount,
      );
    }

    // タスク規模に応じてアニメーションを選択
    final estimatedMinutes = completedTask.estimatedMinutes;

    if (estimatedMinutes != null &&
        estimatedMinutes > 0 &&
        estimatedMinutes <= 5) {
      // 5分以内のタスク: キラキラ星アニメーション（1秒）
      return CompletionAnimationConfig(
        type: CompletionAnimationType.sparkle,
        duration: const Duration(seconds: 1),
      );
    } else {
      // 15分タスクまたは推定時間なし: 紙吹雪アニメーション（1.5秒）
      return CompletionAnimationConfig(
        type: CompletionAnimationType.confetti,
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  /// アニメーションのLottieファイルパスを取得
  String getAnimationAssetPath(CompletionAnimationType type) {
    switch (type) {
      case CompletionAnimationType.sparkle:
        return 'assets/animations/sparkle_star.json';
      case CompletionAnimationType.confetti:
        return 'assets/animations/confetti.json';
      case CompletionAnimationType.streakFlame:
        return 'assets/animations/streak_flame.json';
    }
  }

  /// アニメーションの説明テキストを取得
  String getAnimationDescription(CompletionAnimationConfig config) {
    switch (config.type) {
      case CompletionAnimationType.sparkle:
        return 'タスク完了！';
      case CompletionAnimationType.confetti:
        return '素晴らしい！';
      case CompletionAnimationType.streakFlame:
        return '🔥 ${config.streakCount}連続達成！';
    }
  }
}

/// タスク完了アニメーション設定
class CompletionAnimationConfig {
  const CompletionAnimationConfig({
    required this.type,
    required this.duration,
    this.streakCount,
  });

  /// アニメーション種類
  final CompletionAnimationType type;

  /// アニメーション再生時間（nullの場合はループ）
  final Duration? duration;

  /// 連続達成数（ストリークアニメーションの場合のみ）
  final int? streakCount;

  /// ループアニメーションかどうか
  bool get isLoop => duration == null;
}
