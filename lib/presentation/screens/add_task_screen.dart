import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/task.dart';
import '../../core/repositories/task_repository.dart';

/// タスク追加画面
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    required this.userUuid,
    required this.taskRepository,
  });

  final String userUuid;
  final TaskRepository taskRepository;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contextController = TextEditingController();
  final _uuid = const Uuid();

  int? _estimatedMinutes;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクを追加'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _onSave,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // タイトル
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タスクの内容',
                hintText: '例：メールの返信をする',
                prefixIcon: Icon(Icons.task_alt),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'タスクの内容を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 説明
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '詳細（任意）',
                hintText: 'タスクの詳細を入力',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // 推定時間
            _buildEstimatedTimeField(theme),
            const SizedBox(height: 20),

            // 期限
            _buildDueDateField(theme),
            const SizedBox(height: 20),

            // 優先度
            _buildPriorityField(theme),
            const SizedBox(height: 20),

            // コンテキスト
            TextFormField(
              controller: _contextController,
              decoration: const InputDecoration(
                labelText: 'コンテキスト（任意）',
                hintText: '例：仕事、プライベート',
                prefixIcon: Icon(Icons.label),
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedTimeField(ThemeData theme) {
    return InkWell(
      onTap: _selectEstimatedTime,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '推定時間（任意）',
          prefixIcon: Icon(Icons.timer),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _estimatedMinutes != null ? '$_estimatedMinutes分' : '選択してください',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: _estimatedMinutes != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDueDateField(ThemeData theme) {
    return InkWell(
      onTap: _selectDueDate,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '期限（任意）',
          prefixIcon: Icon(Icons.calendar_today),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _dueDate != null
              ? '${_dueDate!.year}/${_dueDate!.month}/${_dueDate!.day}'
              : '選択してください',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: _dueDate != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '優先度',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<TaskPriority>(
          segments: const [
            ButtonSegment(
              value: TaskPriority.low,
              label: Text('低'),
              icon: Icon(Icons.arrow_downward),
            ),
            ButtonSegment(
              value: TaskPriority.medium,
              label: Text('中'),
              icon: Icon(Icons.remove),
            ),
            ButtonSegment(
              value: TaskPriority.high,
              label: Text('高'),
              icon: Icon(Icons.arrow_upward),
            ),
            ButtonSegment(
              value: TaskPriority.urgent,
              label: Text('緊急'),
              icon: Icon(Icons.priority_high),
            ),
          ],
          selected: {_priority},
          onSelectionChanged: (Set<TaskPriority> selected) {
            setState(() => _priority = selected.first);
          },
        ),
      ],
    );
  }

  Future<void> _selectEstimatedTime() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('推定時間を選択'),
        children: [
          for (final minutes in [5, 10, 15, 30, 45, 60, 90, 120])
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(minutes),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('$minutes分'),
              ),
            ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _estimatedMinutes = result);
    }
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (result != null) {
      setState(() => _dueDate = result);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final task = Task.create(
        uuid: _uuid.v4(),
        userUuid: widget.userUuid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        estimatedMinutes: _estimatedMinutes,
        context: _contextController.text.trim().isEmpty
            ? null
            : _contextController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );

      await widget.taskRepository.createTask(task);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('タスクの保存に失敗しました: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
