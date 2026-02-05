import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../../core/repositories/task_repository.dart';
import '../../core/services/database_service.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

/// タスク一覧画面
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
    required this.userUuid,
  });

  final String userUuid;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TaskRepository _taskRepository;
  List<Task> _tasks = [];
  bool _isLoading = true;
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final databaseService = DatabaseService();
    await databaseService.initialize();
    _taskRepository = TaskRepository(databaseService);
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      List<Task> tasks;
      switch (_currentFilter) {
        case TaskFilter.all:
          tasks = await _taskRepository.getTasksByUser(widget.userUuid);
          break;
        case TaskFilter.pending:
          tasks = await _taskRepository.getPendingTasksByUser(widget.userUuid);
          break;
        case TaskFilter.completed:
          tasks =
              await _taskRepository.getCompletedTasksByUser(widget.userUuid);
          break;
        case TaskFilter.today:
          tasks = await _taskRepository.getTodayTasks(widget.userUuid);
          break;
      }

      // マイクロタスクを除外（親タスクのみ表示）
      tasks = tasks.where((task) => !task.isMicroTask).toList();

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorSnackBar('タスクの読み込みに失敗しました: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('タスク管理'),
          actions: [
            PopupMenuButton<TaskFilter>(
              icon: const Icon(Icons.filter_list),
              onSelected: (filter) {
                setState(() => _currentFilter = filter);
                _loadTasks();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: TaskFilter.all,
                  child: Text('すべて'),
                ),
                const PopupMenuItem(
                  value: TaskFilter.pending,
                  child: Text('未完了'),
                ),
                const PopupMenuItem(
                  value: TaskFilter.completed,
                  child: Text('完了済み'),
                ),
                const PopupMenuItem(
                  value: TaskFilter.today,
                  child: Text('今日'),
                ),
              ],
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: _loadTasks,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) =>
                          _buildTaskCard(context, _tasks[index]),
                    ),
                  ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _onAddTask,
          icon: const Icon(Icons.add),
          label: const Text('タスク追加'),
        ),
      );

  Widget _buildEmptyState(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'タスクがありません',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '新しいタスクを追加してみましょう',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      );

  Widget _buildTaskCard(BuildContext context, Task task) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onTaskTap(task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // チェックボックス
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => _onTaskCheckChanged(task, value ?? false),
                shape: const CircleBorder(),
              ),
              const SizedBox(width: 12),

              // タスク情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    if (task.estimatedMinutes != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.estimatedMinutes}分',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: task.isOverdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: task.isOverdue
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ステータスバッジ
              _buildStatusBadge(context, task),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, Task task) {
    final theme = Theme.of(context);

    if (task.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              '完了',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return '今日';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return '明日';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  Future<void> _onTaskTap(Task task) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          taskRepository: _taskRepository,
        ),
      ),
    );

    if (result == true) {
      await _loadTasks();
    }
  }

  Future<void> _onTaskCheckChanged(Task task, bool isChecked) async {
    try {
      if (isChecked) {
        await _taskRepository.completeTask(task.uuid);
        if (mounted) {
          _showSuccessSnackBar('タスクを完了しました');
        }
      } else {
        task.status = TaskStatus.pending;
        task.completedAt = null;
        await _taskRepository.updateTask(task);
      }
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('タスクの更新に失敗しました: $e');
      }
    }
  }

  Future<void> _onAddTask() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          userUuid: widget.userUuid,
          taskRepository: _taskRepository,
        ),
      ),
    );

    if (result == true) {
      await _loadTasks();
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

enum TaskFilter {
  all,
  pending,
  completed,
  today,
}
