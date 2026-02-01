/// ACTの6つのコアプロセス
enum ACTProcess {
  /// 受容 - 困難な感情や体験を避けずに受け入れる
  acceptance,

  /// 認知的脱フュージョン - 思考や感情から距離を置く
  defusion,

  /// 価値の明確化 - 人生で重要なことを明確にする
  valuesClarity,

  /// コミットされた行動 - 価値に基づいて行動する
  committedAction,

  /// マインドフルネス - 現在の瞬間への意識的な注意
  mindfulness,

  /// 観察する自己 - 自分の思考や感情を客観的に観察する
  observingSelf,
}

/// ACTプロセスの説明を取得
extension ACTProcessExtension on ACTProcess {
  String get description {
    switch (this) {
      case ACTProcess.acceptance:
        return '受容 - 困難な感情や体験を避けずに受け入れる';
      case ACTProcess.defusion:
        return '認知的脱フュージョン - 思考や感情から距離を置く';
      case ACTProcess.valuesClarity:
        return '価値の明確化 - 人生で重要なことを明確にする';
      case ACTProcess.committedAction:
        return 'コミットされた行動 - 価値に基づいて行動する';
      case ACTProcess.mindfulness:
        return 'マインドフルネス - 現在の瞬間への意識的な注意';
      case ACTProcess.observingSelf:
        return '観察する自己 - 自分の思考や感情を客観的に観察する';
    }
  }

  String get shortName {
    switch (this) {
      case ACTProcess.acceptance:
        return '受容';
      case ACTProcess.defusion:
        return '脱フュージョン';
      case ACTProcess.valuesClarity:
        return '価値明確化';
      case ACTProcess.committedAction:
        return 'コミット行動';
      case ACTProcess.mindfulness:
        return 'マインドフルネス';
      case ACTProcess.observingSelf:
        return '観察する自己';
    }
  }
}
