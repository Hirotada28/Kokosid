import 'package:audioplayers/audioplayers.dart';

/// 音声再生サービス
class AudioPlaybackService {
  AudioPlaybackService() : _player = AudioPlayer();

  final AudioPlayer _player;

  /// 音声ファイルを再生
  Future<void> play(String filePath) async {
    await _player.play(DeviceFileSource(filePath));
  }

  /// 再生を一時停止
  Future<void> pause() async {
    await _player.pause();
  }

  /// 再生を再開
  Future<void> resume() async {
    await _player.resume();
  }

  /// 再生を停止
  Future<void> stop() async {
    await _player.stop();
  }

  /// 再生中かどうか
  bool get isPlaying => _player.state == PlayerState.playing;

  /// 再生状態のストリーム
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  /// 再生位置のストリーム
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  /// 再生時間のストリーム
  Stream<Duration?> get onDurationChanged => _player.onDurationChanged;

  /// リソースを解放
  Future<void> dispose() async {
    await _player.dispose();
  }
}
