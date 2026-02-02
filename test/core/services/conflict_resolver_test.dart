import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/models/user.dart' as models;
import 'package:kokosid/core/services/conflict_resolver.dart';

void main() {
  group('ConflictResolver', () {
    late ConflictResolver resolver;

    setUp(() {
      resolver = ConflictResolver();
    });

    group('タスク完了の競合解決（Add-Wins戦略）', () {
      test('ローカルが完了、リモートが未完了の場合、ローカルを優先', () {
        // Given: ローカルは完了、リモートは未完了
        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );
        localTask.completedAt = DateTime.now();
        localTask.status = TaskStatus.completed;

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        // When: 競合を解決
        final resolved = resolver.resolveTaskCompletionConflict(
          localTask,
          remoteTask,
        );

        // Then: ローカルの完了が優先される
        expect(resolved.isCompleted, true);
        expect(resolved.uuid, localTask.uuid);
        expect(resolver.conflictLogs.length, 1);
        expect(resolver.conflictLogs.first.strategy, ConflictStrategy.addWins);
      });

      test('ローカルが未完了、リモートが完了の場合、リモートを優先', () {
        // Given: ローカルは未完了、リモートは完了
        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );
        remoteTask.completedAt = DateTime.now();
        remoteTask.status = TaskStatus.completed;

        // When: 競合を解決
        final resolved = resolver.resolveTaskCompletionConflict(
          localTask,
          remoteTask,
        );

        // Then: リモートの完了が優先される
        expect(resolved.isCompleted, true);
        expect(resolved.uuid, remoteTask.uuid);
      });

      test('両方完了の場合、早い方を優先', () {
        // Given: 両方完了、ローカルが早い
        final earlierTime = DateTime.now().subtract(const Duration(hours: 1));
        final laterTime = DateTime.now();

        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );
        localTask.completedAt = earlierTime;
        localTask.status = TaskStatus.completed;

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );
        remoteTask.completedAt = laterTime;
        remoteTask.status = TaskStatus.completed;

        // When: 競合を解決
        final resolved = resolver.resolveTaskCompletionConflict(
          localTask,
          remoteTask,
        );

        // Then: 早い完了時刻が優先される
        expect(resolved.completedAt, earlierTime);
      });

      test('両方未完了の場合、最新の更新を優先', () {
        // Given: 両方未完了、ローカルが新しい
        final olderTime = DateTime.now().subtract(const Duration(hours: 1));
        final newerTime = DateTime.now();

        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'ローカルタスク',
        );
        localTask.createdAt = newerTime;

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'リモートタスク',
        );
        remoteTask.createdAt = olderTime;

        // When: 競合を解決
        final resolved = resolver.resolveTaskCompletionConflict(
          localTask,
          remoteTask,
        );

        // Then: 新しい更新が優先される
        expect(resolved.title, 'ローカルタスク');
      });
    });

    group('ユーザー設定の競合解決（Last-Write-Wins戦略）', () {
      test('ローカルが新しい場合、ローカルを優先', () {
        // Given: ローカルが新しい
        final newerTime = DateTime.now();
        final olderTime = DateTime.now().subtract(const Duration(hours: 1));

        final localUser = models.User.create(
          uuid: 'user-1',
          name: 'ローカルユーザー',
        );
        localUser.lastActiveAt = newerTime;

        final remoteUser = models.User.create(
          uuid: 'user-1',
          name: 'リモートユーザー',
        );

        // When: 競合を解決
        final resolved = resolver.resolveUserSettingsConflict(
          localUser,
          remoteUser,
          olderTime,
        );

        // Then: ローカルが優先される
        expect(resolved.name, 'ローカルユーザー');
        expect(resolver.conflictLogs.length, 1);
        expect(resolver.conflictLogs.first.strategy,
            ConflictStrategy.lastWriteWins);
      });

      test('リモートが新しい場合、リモートを優先', () {
        // Given: リモートが新しい
        final olderTime = DateTime.now().subtract(const Duration(hours: 1));
        final newerTime = DateTime.now();

        final localUser = models.User.create(
          uuid: 'user-1',
          name: 'ローカルユーザー',
        );
        localUser.lastActiveAt = olderTime;

        final remoteUser = models.User.create(
          uuid: 'user-1',
          name: 'リモートユーザー',
        );

        // When: 競合を解決
        final resolved = resolver.resolveUserSettingsConflict(
          localUser,
          remoteUser,
          newerTime,
        );

        // Then: リモートが優先される
        expect(resolved.name, 'リモートユーザー');
      });
    });

    group('日記エントリの競合解決（Multi-Value戦略）', () {
      test('内容が異なる場合、両方を保持', () {
        // Given: 同じUUIDで内容が異なる
        final localEntry = JournalEntry.create(
          uuid: 'entry-1',
          userUuid: 'user-1',
          encryptedContent: 'ローカルコンテンツ',
        );

        final remoteEntry = JournalEntry.create(
          uuid: 'entry-1',
          userUuid: 'user-1',
          encryptedContent: 'リモートコンテンツ',
        );

        // When: 競合を解決
        final resolved = resolver.resolveJournalEntryConflict(
          localEntry,
          remoteEntry,
        );

        // Then: 両方が保持される
        expect(resolved.length, 2);
        expect(resolved[0].uuid, contains('entry-1_local'));
        expect(resolved[1].uuid, 'entry-1');
        expect(resolver.conflictLogs.length, 1);
        expect(
            resolver.conflictLogs.first.strategy, ConflictStrategy.multiValue);
      });

      test('内容が同じ場合、ローカルのみを保持', () {
        // Given: 同じUUIDで内容が同じ
        final localEntry = JournalEntry.create(
          uuid: 'entry-1',
          userUuid: 'user-1',
          encryptedContent: '同じコンテンツ',
        );

        final remoteEntry = JournalEntry.create(
          uuid: 'entry-1',
          userUuid: 'user-1',
          encryptedContent: '同じコンテンツ',
        );

        // When: 競合を解決
        final resolved = resolver.resolveJournalEntryConflict(
          localEntry,
          remoteEntry,
        );

        // Then: ローカルのみが保持される
        expect(resolved.length, 1);
        expect(resolved[0].uuid, 'entry-1');
      });
    });

    group('タスクフィールドの競合解決（Field-Merge戦略）', () {
      test('フィールド単位でマージできる', () {
        // Given: 異なるフィールドが更新されたタスク
        final olderTime = DateTime.now().subtract(const Duration(hours: 1));
        final newerTime = DateTime.now();

        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '新しいタイトル',
          description: '古い説明',
        );
        localTask.createdAt = newerTime;

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: '古いタイトル',
          description: '新しい説明',
        );
        remoteTask.createdAt = olderTime;

        // When: 競合を解決
        final resolved = resolver.resolveTaskFieldConflict(
          localTask,
          remoteTask,
        );

        // Then: 新しいフィールドがマージされる
        expect(resolved.title, '新しいタイトル');
        expect(resolver.conflictLogs.length, 1);
        expect(
            resolver.conflictLogs.first.strategy, ConflictStrategy.fieldMerge);
      });

      test('完了状態はAdd-Wins戦略で解決', () {
        // Given: ローカルが完了
        final localTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );
        localTask.completedAt = DateTime.now();
        localTask.status = TaskStatus.completed;

        final remoteTask = Task.create(
          uuid: 'task-1',
          userUuid: 'user-1',
          title: 'テストタスク',
        );

        // When: 競合を解決
        final resolved = resolver.resolveTaskFieldConflict(
          localTask,
          remoteTask,
        );

        // Then: 完了状態が優先される
        expect(resolved.isCompleted, true);
        expect(resolved.status, TaskStatus.completed);
      });
    });

    group('競合統計', () {
      test('競合統計を取得できる', () {
        // Given: 複数の競合を解決
        final task1 =
            Task.create(uuid: 'task-1', userUuid: 'user-1', title: 'Task 1');
        final task2 =
            Task.create(uuid: 'task-2', userUuid: 'user-1', title: 'Task 2');
        task1.completedAt = DateTime.now();
        task1.status = TaskStatus.completed;

        resolver.resolveTaskCompletionConflict(task1, task2);
        resolver.resolveTaskCompletionConflict(task1, task2);

        final user1 = models.User.create(uuid: 'user-1', name: 'User 1');
        final user2 = models.User.create(uuid: 'user-1', name: 'User 2');
        resolver.resolveUserSettingsConflict(user1, user2, DateTime.now());

        // When: 統計を取得
        final stats = resolver.getStatistics();

        // Then: 正しい統計が返る
        expect(stats.totalConflicts, 3);
        expect(stats.taskCompletionConflicts, 2);
        expect(stats.userSettingsConflicts, 1);
        expect(stats.addWinsResolutions, 2);
        expect(stats.lastWriteWinsResolutions, 1);
      });

      test('ログをクリアできる', () {
        // Given: 競合を解決
        final task1 =
            Task.create(uuid: 'task-1', userUuid: 'user-1', title: 'Task 1');
        final task2 =
            Task.create(uuid: 'task-2', userUuid: 'user-1', title: 'Task 2');
        resolver.resolveTaskCompletionConflict(task1, task2);
        expect(resolver.conflictLogs.length, 1);

        // When: ログをクリア
        resolver.clearLogs();

        // Then: ログが空になる
        expect(resolver.conflictLogs.length, 0);
      });
    });
  });
}
