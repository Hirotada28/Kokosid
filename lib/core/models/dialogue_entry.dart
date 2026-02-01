/// 対話エントリ
class DialogueEntry {
  DialogueEntry({
    required this.uuid,
    required this.userUuid,
    required this.userInput,
    required this.aiResponse,
    required this.actProcess,
    this.emotionType,
    this.emotionConfidence,
    required this.createdAt,
  });

  final String uuid;
  final String userUuid;
  final String userInput;
  final String aiResponse;
  final String actProcess;
  final String? emotionType;
  final double? emotionConfidence;
  final DateTime createdAt;

  @override
  String toString() =>
      'DialogueEntry{uuid: $uuid, actProcess: $actProcess, emotion: $emotionType}';
}

/// 個別化コンテキスト
class PersonalizationContext {
  PersonalizationContext({
    required this.userUuid,
    required this.totalDialogues,
    required this.mostFrequentProcess,
    required this.emotionFrequency,
    required this.successExperiences,
    required this.recurringThemes,
    this.lastDialogueAt,
  });

  final String userUuid;
  final int totalDialogues;
  final String mostFrequentProcess;
  final Map<String, int> emotionFrequency;
  final List<String> successExperiences;
  final List<String> recurringThemes;
  final DateTime? lastDialogueAt;

  @override
  String toString() =>
      'PersonalizationContext{totalDialogues: $totalDialogues, mostFrequentProcess: $mostFrequentProcess}';
}
