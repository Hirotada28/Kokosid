import 'dart:convert';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'ai_service.dart';
import 'package:uuid/uuid.dart';

/// マイクロタスクの詳細情報
class MicroTaskDetail {
  MicroTaskDetail({
    required this.action,
    required this.estimatedMinutes,
    required this.successCriteria,
  });

  final String action;
  final int estimatedMinutes;
  final String successCriteria;

  factory MicroTaskDetail.fromJson(Map<String, dynamic> json) {
    return MicroTaskDetail(
      action: json['action'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      successCriteria: json['successCriteria'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'estimatedMinutes': estimatedMinutes,
      'successCriteria': successCriteria,
    };
  }
}

/// マイクロ・チャンキング・エンジン
/// タスクを5分以内の極小ステップに自動分解する
class MicroChunkingEngine {
  MicroChunkingEngine({
    required AIService aiService,
    required TaskRepository taskRepository,
  })  : _aiService = aiService,
        _taskRepository = taskRepository;

  final AIService _aiService;
  final TaskRepository _taskRepository;
  final _uuid = const Uuid();

  /// タスクを5分以内の極小ステップに分解
  ///
  /// 要件:
  /// - 各ステップは5分以内で完了可能
  /// - 具体的な動詞で開始
  /// - 成功条件が明確
  /// - 最初のステップは実行系
  /// - 最大7ステップまで
  Future<List<Task>> decomposeTask(Task originalTask) async {
    // プロンプトを構築
    final prompt = _buildDecompositionPrompt(originalTask);

    // AI に分解を依頼
    final response = await _aiService.complete(prompt);

    // レスポンスをパース
    final microTaskDetails = _parseStepsFromResponse(response);

    // マイクロタスクを作成
    final microTasks = <Task>[];
    for (final detail in microTaskDetails) {
      final microTask = Task.create(
        uuid: _uuid.v4(),
        userUuid: originalTask.userUuid,
        title: detail.action,
        description: detail.successCriteria,
        originalTaskUuid: originalTask.uuid,
        isMicroTask: true,
        estimatedMinutes: detail.estimatedMinutes,
        context: originalTask.context,
      );

      // データベースに保存
      final savedTask = await _taskRepository.createTask(microTask);
      microTasks.add(savedTask);
    }

    return microTasks;
  }

  /// タスク分解用のプロンプトを構築
  String _buildDecompositionPrompt(Task task) {
    return '''
あなたはADHD特性を持つ人のタスク分解専門家です。

【入力タスク】
タイトル: "${task.title}"
推定時間: ${task.estimatedMinutes ?? '未設定'}分
説明: ${task.description ?? 'なし'}
コンテキスト: ${task.context ?? 'なし'}

【分解の原則】
1. 各ステップは5分以内で完了できる
2. 具体的な動詞で始める（「考える」ではなく「3つ書き出す」）
3. 成功条件が明確（チェックボックスで判定可能）
4. 最初のステップは「準備」ではなく「実行」から始める
5. 最大7ステップまで（認知負荷軽減）

【出力形式】
以下のJSON配列形式で出力してください。他のテキストは含めないでください。

[
  {
    "action": "具体的な動詞で始まる行動指示",
    "estimatedMinutes": 1-5の整数,
    "successCriteria": "完了を判定できる明確な基準"
  }
]

【例】
入力: "プレゼン資料を作成する（30分）"
出力:
[
  {
    "action": "プレゼンの目的を1文で書き出す",
    "estimatedMinutes": 2,
    "successCriteria": "目的が1文で明確に書かれている"
  },
  {
    "action": "伝えたい3つのポイントをリストアップする",
    "estimatedMinutes": 3,
    "successCriteria": "3つのポイントが箇条書きされている"
  },
  {
    "action": "スライドのタイトルページを作成する",
    "estimatedMinutes": 2,
    "successCriteria": "タイトル、日付、名前が入力されている"
  }
]

それでは、上記のタスクを分解してください。JSON配列のみを出力してください。
''';
  }

  /// AI レスポンスからステップをパース
  List<MicroTaskDetail> _parseStepsFromResponse(String response) {
    try {
      // JSON部分を抽出（マークダウンのコードブロックなどを除去）
      String jsonString = response.trim();

      // コードブロックを除去
      if (jsonString.startsWith('```')) {
        final lines = jsonString.split('\n');
        jsonString =
            lines.where((line) => !line.startsWith('```')).join('\n').trim();
      }

      // JSON配列の開始位置を探す
      final startIndex = jsonString.indexOf('[');
      final endIndex = jsonString.lastIndexOf(']');

      if (startIndex == -1 || endIndex == -1) {
        throw FormatException('JSON array not found in response');
      }

      jsonString = jsonString.substring(startIndex, endIndex + 1);

      // JSONをパース
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      // MicroTaskDetailに変換
      final details = jsonList
          .map((json) => MicroTaskDetail.fromJson(json as Map<String, dynamic>))
          .toList();

      // 制約を適用
      return details
          .where((detail) => detail.estimatedMinutes <= 5) // 5分以内
          .take(7) // 最大7ステップ
          .toList();
    } catch (e) {
      throw MicroChunkingException(
        'Failed to parse AI response: $e\nResponse: $response',
      );
    }
  }

  /// 既存のマイクロタスクを取得
  Future<List<Task>> getMicroTasks(String originalTaskUuid) async {
    return _taskRepository.getMicroTasks(originalTaskUuid);
  }

  /// マイクロタスクを完了
  Future<Task> completeMicroTask(String microTaskUuid) async {
    return _taskRepository.completeTask(microTaskUuid);
  }

  /// 全てのマイクロタスクが完了したかチェック
  Future<bool> areAllMicroTasksCompleted(String originalTaskUuid) async {
    final microTasks = await getMicroTasks(originalTaskUuid);
    if (microTasks.isEmpty) {
      return false;
    }
    return microTasks.every((task) => task.isCompleted);
  }

  /// 完了したマイクロタスクの数を取得
  Future<int> getCompletedMicroTaskCount(String originalTaskUuid) async {
    final microTasks = await getMicroTasks(originalTaskUuid);
    return microTasks.where((task) => task.isCompleted).length;
  }
}

/// マイクロ・チャンキングの例外
class MicroChunkingException implements Exception {
  MicroChunkingException(this.message);
  final String message;

  @override
  String toString() => 'MicroChunkingException: $message';
}
