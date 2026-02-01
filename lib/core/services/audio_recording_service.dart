import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// 音声録音サービス
class AudioRecordingService {
  AudioRecordingService() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;
  String? _currentRecordingPath;

  /// 録音を開始
  Future<void> startRecording() async {
    // 権限チェック
    if (!await _recorder.hasPermission()) {
      throw Exception('マイクの権限がありません');
    }

    // 録音ファイルのパスを生成
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _currentRecordingPath = '${directory.path}/audio_$timestamp.m4a';

    // 録音開始
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _currentRecordingPath!,
    );
  }

  /// 録音を停止
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _currentRecordingPath = null;
    return path;
  }

  /// 録音中かどうか
  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  /// 録音をキャンセル
  Future<void> cancelRecording() async {
    await _recorder.stop();
    if (_currentRecordingPath != null) {
      final file = File(_currentRecordingPath!);
      if (await file.exists()) {
        await file.delete();
      }
      _currentRecordingPath = null;
    }
  }

  /// リソースを解放
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
