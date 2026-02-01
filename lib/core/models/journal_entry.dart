import 'package:isar/isar.dart';

part 'journal_entry.g.dart';

/// 日記エントリモデル
@collection
class JournalEntry {
  /// 日記エントリを作成
  JournalEntry();

  /// 名前付きコンストラクタ
  JournalEntry.create({
    required this.uuid,
    required this.userUuid,
    this.encryptedContent,
    this.audioUrl,
    this.transcription,
    this.emotionDetected,
    this.emotionConfidence,
    this.aiReflection,
    this.encryptedAiResponse,
  }) {
    createdAt = DateTime.now();
    isEncrypted = true;
  }
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String userUuid;

  String? encryptedContent; // AES-256で暗号化済み
  String? audioUrl; // ローカルパスまたは暗号化URL
  String? transcription; // 音声のテキスト変換結果

  @Enumerated(EnumType.name)
  EmotionType? emotionDetected;

  double? emotionConfidence; // 0.0 ~ 1.0
  String? aiReflection; // AIリフレーミング
  String? encryptedAiResponse; // AI応答（暗号化済み）

  @Index()
  DateTime createdAt = DateTime.now();

  DateTime? syncedAt;
  bool isEncrypted = true;

  /// 同期完了をマーク
  void markSynced() {
    syncedAt = DateTime.now();
  }

  /// 感情情報を設定
  void setEmotion(EmotionType emotion, double confidence) {
    emotionDetected = emotion;
    emotionConfidence = confidence;
  }

  /// AI応答を設定
  void setAiResponse(String response, String reflection) {
    encryptedAiResponse = response;
    aiReflection = reflection;
  }

  /// 今日のエントリかチェック
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  @override
  String toString() =>
      'JournalEntry{uuid: $uuid, emotion: $emotionDetected, confidence: $emotionConfidence}';
}

/// 感情タイプ
enum EmotionType {
  happy, // 喜び
  sad, // 悲しみ
  angry, // 怒り
  anxious, // 不安
  tired, // 疲労
  neutral, // 中立
}
