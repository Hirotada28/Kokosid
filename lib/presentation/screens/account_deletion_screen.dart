import 'package:flutter/material.dart';

import '../../core/services/data_deletion_service.dart';

/// アカウント削除画面
/// GDPR準拠のデータエクスポートと削除機能を提供
class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({
    required this.userUuid,
    required this.dataDeletionService,
    super.key,
  });

  final String userUuid;
  final DataDeletionService dataDeletionService;

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  bool _isLoading = false;
  bool _hasExported = false;
  bool _confirmationChecked = false;
  DeletionStats? _stats;
  DateTime? _scheduledDeletionDate;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDeletionInfo();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadDeletionInfo() async {
    setState(() => _isLoading = true);

    try {
      final stats =
          await widget.dataDeletionService.getDeletionStats(widget.userUuid);
      final scheduledDate = await widget.dataDeletionService
          .getScheduledDeletionDate(widget.userUuid);

      setState(() {
        _stats = stats;
        _scheduledDeletionDate = scheduledDate;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog('情報の読み込みに失敗しました: $e');
      }
    }
  }

  Future<void> _exportData() async {
    setState(() => _isLoading = true);

    try {
      final result =
          await widget.dataDeletionService.exportUserData(widget.userUuid);

      setState(() {
        _hasExported = true;
        _isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog(
          'データエクスポート完了',
          'データが正常にエクスポートされました。\n\n'
              'ファイルパス: ${result.filePath}\n'
              'ファイルサイズ: ${(result.fileSize / 1024).toStringAsFixed(2)} KB\n'
              'レコード数: ${result.recordCount}',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog('データエクスポートに失敗しました: $e');
      }
    }
  }

  Future<void> _requestDeletion() async {
    // 確認チェックボックスの検証
    if (!_confirmationChecked) {
      _showErrorDialog('削除を実行するには、確認チェックボックスにチェックを入れてください。');
      return;
    }

    // パスワード確認
    if (_passwordController.text.isEmpty) {
      _showErrorDialog('削除を実行するには、確認パスワードを入力してください。');
      return;
    }

    // 最終確認ダイアログ
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await widget.dataDeletionService.requestAccountDeletion(
        widget.userUuid,
        confirmationPassword: _passwordController.text,
      );

      setState(() {
        _scheduledDeletionDate = result.scheduledDeletionDate;
        _isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog(
          '削除リクエスト完了',
          result.message,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog('削除リクエストに失敗しました: $e');
      }
    }
  }

  Future<void> _cancelDeletion() async {
    setState(() => _isLoading = true);

    try {
      await widget.dataDeletionService.cancelDeletionRequest(widget.userUuid);

      setState(() {
        _scheduledDeletionDate = null;
        _isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog(
          'キャンセル完了',
          'アカウント削除リクエストがキャンセルされました。',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog('キャンセルに失敗しました: $e');
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('最終確認'),
        content: const Text(
          'この操作は取り消せません。\n\n'
          '30日後にすべてのデータが完全に削除されます。\n'
          '本当に削除しますか？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('削除する'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showSuccessDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('アカウント削除'),
          backgroundColor: Colors.red.shade700,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _scheduledDeletionDate != null
                ? _buildScheduledDeletionView()
                : _buildDeletionRequestView(),
      );

  Widget _buildScheduledDeletionView() {
    final daysRemaining =
        _scheduledDeletionDate!.difference(DateTime.now()).inDays;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 64,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '削除予定',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '残り $daysRemaining 日',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.orange.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '削除予定日: ${_scheduledDeletionDate!.year}年'
                    '${_scheduledDeletionDate!.month}月'
                    '${_scheduledDeletionDate!.day}日',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'アカウント削除リクエストが送信されました。\n\n'
            '予定日までにキャンセルすることができます。\n'
            '予定日を過ぎると、すべてのデータが完全に削除されます。',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _cancelDeletion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '削除をキャンセル',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletionRequestView() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '重要な警告',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'この操作は取り消せません。\n'
                      'すべてのデータが完全に削除されます。',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_stats != null) ...[
              Text(
                '削除されるデータ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildStatItem('タスク', _stats!.totalTasks),
              _buildStatItem('日記エントリ', _stats!.totalJournalEntries),
              _buildStatItem('自己肯定感スコア', _stats!.totalScores),
              _buildStatItem(
                '推定データサイズ',
                _stats!.estimatedDataSize,
                unit: 'KB',
              ),
              const SizedBox(height: 24),
            ],
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'データエクスポート（GDPR準拠）',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              '削除前にデータをエクスポートすることをお勧めします。\n'
              'エクスポートされたデータは人間が読める形式で保存されます。',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _exportData,
              icon: const Icon(Icons.download),
              label: Text(_hasExported ? 'データを再エクスポート' : 'データをエクスポート'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (_hasExported)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    const Text('エクスポート済み'),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'アカウント削除',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _confirmationChecked,
              onChanged: (value) {
                setState(() => _confirmationChecked = value ?? false);
              },
              title: const Text(
                'すべてのデータが完全に削除されることを理解しました',
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '確認パスワード',
                hintText: 'パスワードを入力してください',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _requestDeletion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'アカウントを削除',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '※ 削除リクエスト後、30日以内にデータが完全削除されます。\n'
              '※ 削除予定日までキャンセル可能です。',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildStatItem(String label, int value, {String unit = '件'}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '$value $unit',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
