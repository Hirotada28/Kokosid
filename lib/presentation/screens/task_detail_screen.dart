import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task.dart';
import '../../core/repositories/task_repository.dart';
import '../../core/services/micro_chunking_engine.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/app_config_service.dart';

/// タスク詳細画面
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.taskRepository,
  });

  final Task task;
  final TaskRepository taskRepository;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late MicroChunkingEngine _microChunkingEngine;
  List<Task> _microTasks = [];
  bool _isLoadingMicroTasks = false;
  bool _isDecomposing = false;

  @override
  void initState() {
    super.initState();
    _loadMicroTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeMicroChunkingEngine();
  }

  void _initializeMicroChunkingEngine() {
    // AppConfigService から API キーを取得
    final configService = context.read<AppConfigService>();
    String apiKey;
    try {
      apiKey = configService.getClaudeApiKey();
    } catch (e) {
      // 開発時はデモモードで動作
      apiKey = '';
    }
    final aiService = ClaudeAIService(apiKey: apiKey);
    _microChunkingEngine = MicroChunkingEngine(
      aiService: aiService,
      taskRepository: widget.taskRepository,
    );
  }

  Future<void> _loadMicroTasks() async {
    setState(() => _isLoadingMicroTasks = true);

    try {
      final microTasks =
          await _microChunkingEngine.getMicroTasks(widget.task.uuid);
      setState(() {
        _microTasks = microTasks;
        _isLoadingMicroTasks = false;
      });
    } catch (e) {
      setState(() => _isLoadingMicroTasks = false);
      if (mounted) {
        _showErrorSnackBar('マイクロタスクの読み込みに失敗しました: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスク詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _onEdit,
            tooltip: '編集',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _onDelete,
            tooltip: '削除',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMicroTasks,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // タスク情報カード
            _buildTaskInfoCard(theme),
            const SizedBox(height: 24),

            // マイクロタスクセクション
            _buildMicroTasksSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfoCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Row(
              children: [
                Checkbox(
                  value: widget.task.isCompleted,
                  onChanged: (value) => _onTaskCheckChanged(value ?? false),
                  shape: const CircleBorder(),
                ),
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ],
            ),

            if (widget.task.description != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                '詳細',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.task.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // メタ情報
            _buildMetaInfo(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        if (widget.task.estimatedMinutes != null)
          _buildMetaChip(
            theme,
            Icons.timer_outlined,
            '${widget.task.estimatedMinutes}分',
            theme.colorScheme.primary,
          ),
        if (widget.task.dueDate != null)
          _buildMetaChip(
            theme,
            Icons.calendar_today,
            _formatDate(widget.task.dueDate!),
            widget.task.isOverdue
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        _buildMetaChip(
          theme,
          Icons.flag,
          _getPriorityLabel(widget.task.priority),
          _getPriorityColor(theme, widget.task.priority),
        ),
        if (widget.task.context != null)
          _buildMetaChip(
            theme,
            Icons.label,
            widget.task.context!,
            theme.colorScheme.secondary,
          ),
      ],
    );
  }

  Widget _buildMetaChip(
      ThemeData theme, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroTasksSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.splitscreen,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'マイクロタスク',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (_microTasks.isEmpty && !_isLoadingMicroTasks)
              TextButton.icon(
                onPressed: _isDecomposing ? null : _onDecomposeTask,
                icon: _isDecomposing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isDecomposing ? '分解中...' : 'AI分解'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoadingMicroTasks)
          const Center(child: CircularProgressIndicator())
        else if (_microTasks.isEmpty)
          _buildEmptyMicroTasks(theme)
        else
          _buildMicroTasksList(theme),
      ],
    );
  }

  Widget _buildEmptyMicroTasks(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'マイクロタスクがありません',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AIがタスクを5分以内の\n実行可能なステップに分解します',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicroTasksList(ThemeData theme) {
    final completedCount = _microTasks.where((task) => task.isCompleted).length;
    final totalCount = _microTasks.length;

    return Column(
      children: [
        // 進捗バー
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '進捗',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      '$completedCount / $totalCount',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalCount > 0 ? completedCount / totalCount : 0,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // マイクロタスクリスト
        ...List.generate(_microTasks.length, (index) {
          final microTask = _microTasks[index];
          return _buildMicroTaskCard(theme, microTask, index + 1);
        }),
      ],
    );
  }

  Widget _buildMicroTaskCard(ThemeData theme, Task microTask, int stepNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: microTask.isCompleted,
        onChanged: (value) =>
            _onMicroTaskCheckChanged(microTask, value ?? false),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: microTask.isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: microTask.isCompleted
                        ? Colors.white
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                microTask.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  decoration:
                      microTask.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: microTask.description != null
            ? Padding(
                padding: const EdgeInsets.only(left: 36, top: 4),
                child: Text(
                  microTask.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              )
            : null,
        secondary: microTask.estimatedMinutes != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${microTask.estimatedMinutes}分',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return '低';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.high:
        return '高';
      case TaskPriority.urgent:
        return '緊急';
    }
  }

  Color _getPriorityColor(ThemeData theme, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.medium:
        return Colors.green;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return theme.colorScheme.error;
    }
  }

  Future<void> _onTaskCheckChanged(bool isChecked) async {
    try {
      if (isChecked) {
        await widget.taskRepository.completeTask(widget.task.uuid);
        if (mounted) {
          _showSuccessSnackBar('タスクを完了しました');
          Navigator.of(context).pop(true);
        }
      } else {
        widget.task.status = TaskStatus.pending;
        widget.task.completedAt = null;
        await widget.taskRepository.updateTask(widget.task);
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('タスクの更新に失敗しました: $e');
      }
    }
  }

  Future<void> _onMicroTaskCheckChanged(Task microTask, bool isChecked) async {
    try {
      if (isChecked) {
        await _microChunkingEngine.completeMicroTask(microTask.uuid);
        if (mounted) {
          _showSuccessSnackBar('ステップを完了しました');
        }
      } else {
        microTask.status = TaskStatus.pending;
        microTask.completedAt = null;
        await widget.taskRepository.updateTask(microTask);
      }
      await _loadMicroTasks();

      // 全てのマイクロタスクが完了したら親タスクも完了
      final allCompleted = await _microChunkingEngine
          .areAllMicroTasksCompleted(widget.task.uuid);
      if (allCompleted && !widget.task.isCompleted) {
        await widget.taskRepository.completeTask(widget.task.uuid);
        if (mounted) {
          _showSuccessSnackBar('全てのステップが完了しました！');
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('ステップの更新に失敗しました: $e');
      }
    }
  }

  Future<void> _onDecomposeTask() async {
    setState(() => _isDecomposing = true);

    try {
      final microTasks = await _microChunkingEngine.decomposeTask(widget.task);
      setState(() {
        _microTasks = microTasks;
        _isDecomposing = false;
      });
      if (mounted) {
        _showSuccessSnackBar('タスクを${microTasks.length}個のステップに分解しました');
      }
    } catch (e) {
      setState(() => _isDecomposing = false);
      if (mounted) {
        _showErrorSnackBar('タスクの分解に失敗しました: $e');
      }
    }
  }

  void _onEdit() {
    _showEditDialog();
  }

  /// タスク編集ダイアログを表示
  Future<void> _showEditDialog() async {
    final titleController = TextEditingController(text: widget.task.title);
    final descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    final estimatedMinutesController = TextEditingController(
      text: widget.task.estimatedMinutes?.toString() ?? '',
    );

    var selectedPriority = widget.task.priority;
    var selectedDueDate = widget.task.dueDate;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('タスクを編集'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトル
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'タイトル',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),

                    // 説明
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: '説明（任意）',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // 見積もり時間
                    TextField(
                      controller: estimatedMinutesController,
                      decoration: const InputDecoration(
                        labelText: '見積もり時間（分）',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // 優先度
                    DropdownButtonFormField<TaskPriority>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: '優先度',
                        border: OutlineInputBorder(),
                      ),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(_getPriorityLabel(priority)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // 期限日
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('期限日'),
                      subtitle: Text(
                        selectedDueDate != null
                            ? '${selectedDueDate!.year}/${selectedDueDate!.month}/${selectedDueDate!.day}'
                            : '未設定',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDueDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setDialogState(() {
                                  selectedDueDate = date;
                                });
                              }
                            },
                          ),
                          if (selectedDueDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setDialogState(() {
                                  selectedDueDate = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('キャンセル'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('タイトルを入力してください')),
                      );
                      return;
                    }
                    Navigator.of(context).pop({
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      'estimatedMinutes': int.tryParse(
                        estimatedMinutesController.text,
                      ),
                      'priority': selectedPriority,
                      'dueDate': selectedDueDate,
                    });
                  },
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await _updateTask(result);
    }
  }

  /// タスクを更新
  Future<void> _updateTask(Map<String, dynamic> updates) async {
    try {
      // タスクの各フィールドを更新
      widget.task.title = updates['title'] as String;
      widget.task.description = updates['description'] as String?;
      widget.task.estimatedMinutes = updates['estimatedMinutes'] as int?;
      widget.task.priority = updates['priority'] as TaskPriority;
      widget.task.dueDate = updates['dueDate'] as DateTime?;

      // リポジトリに保存
      await widget.taskRepository.updateTask(widget.task);

      if (mounted) {
        setState(() {});
        _showSuccessSnackBar('タスクを更新しました');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('タスクの更新に失敗しました: $e');
      }
    }
  }

  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: const Text('このタスクを削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.taskRepository.deleteTask(widget.task.uuid);
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('タスクの削除に失敗しました: $e');
        }
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
