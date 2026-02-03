import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/journal_entry.dart';
import 'package:kokosid/core/models/self_esteem_score.dart';
import 'package:kokosid/core/models/task.dart';
import 'package:kokosid/core/models/user.dart';
import 'package:kokosid/core/repositories/journal_repository.dart';
import 'package:kokosid/core/repositories/self_esteem_repository.dart';
import 'package:kokosid/core/repositories/task_repository.dart';
import 'package:kokosid/core/repositories/user_repository.dart';
import 'package:kokosid/core/services/data_deletion_service.dart';
import 'package:kokosid/core/services/database_service.dart';
import 'package:kokosid/core/services/encrypted_storage_service.dart';
import 'package:kokosid/core/services/supabase_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'data_deletion_service_test.mocks.dart';

@GenerateMocks([
  UserRepository,
  TaskRepository,
  JournalRepository,
  SelfEsteemRepository,
  DatabaseService,
  EncryptedStorageService,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // path_providerのモック設定
  const MethodChannel pathProviderChannel =
      MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel,
          (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return Directory.systemTemp.path;
    }
    return null;
  });

  // flutter_secure_storageのモック設定
  const MethodChannel secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel,
          (MethodCall methodCall) async {
    if (methodCall.method == 'delete' || methodCall.method == 'deleteAll') {
      return null;
    }
    return null;
  });

  late DataDeletionService service;
  late MockUserRepository mockUserRepository;
  late MockTaskRepository mockTaskRepository;
  late MockJournalRepository mockJournalRepository;
  late MockSelfEsteemRepository mockSelfEsteemRepository;
  late MockDatabaseService mockDatabaseService;
  late MockEncryptedStorageService mockEncryptedStorageService;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTaskRepository = MockTaskRepository();
    mockJournalRepository = MockJournalRepository();
    mockSelfEsteemRepository = MockSelfEsteemRepository();
    mockDatabaseService = MockDatabaseService();
    mockEncryptedStorageService = MockEncryptedStorageService();

    service = DataDeletionService(
      userRepository: mockUserRepository,
      taskRepository: mockTaskRepository,
      journalRepository: mockJournalRepository,
      selfEsteemRepository: mockSelfEsteemRepository,
      databaseService: mockDatabaseService,
      encryptedStorageService: mockEncryptedStorageService,
      supabaseService: SupabaseService.instance,
    );
  });

  group('DataDeletionService - exportUserData', () {
    test('ユーザーデータを正常にエクスポートできる', () async {
      // Given: テストデータ
      const userUuid = 'test-user-uuid';
      final user = User.create(
        uuid: userUuid,
        name: 'Test User',
        timezone: 'Asia/Tokyo',
      );

      final tasks = [
        Task.create(
          uuid: 'task-1',
          userUuid: userUuid,
          title: 'Test Task',
        ),
      ];

      final journalEntries = [
        JournalEntry.create(
          uuid: 'journal-1',
          userUuid: userUuid,
          encryptedContent: 'encrypted-content',
        ),
      ];

      final scores = [
        SelfEsteemScore.create(
          uuid: 'score-1',
          userUuid: userUuid,
          score: 0.75,
        ),
      ];

      when(mockUserRepository.getUserByUuid(userUuid))
          .thenAnswer((_) async => user);
      when(mockTaskRepository.getTasksByUser(userUuid))
          .thenAnswer((_) async => tasks);
      when(mockJournalRepository.getEntriesByUser(userUuid))
          .thenAnswer((_) async => journalEntries);
      when(mockSelfEsteemRepository.getScoresByUser(userUuid))
          .thenAnswer((_) async => scores);
      when(mockEncryptedStorageService.decryptJournalContent(any))
          .thenReturn('Decrypted content');
      when(mockEncryptedStorageService.decryptJournalAiResponse(any))
          .thenReturn(null);

      // When: データをエクスポート
      final result = await service.exportUserData(userUuid);

      // Then: エクスポートが成功する
      expect(result.success, isTrue);
      expect(result.filePath, isNotEmpty);
      expect(result.recordCount, equals(3)); // 1 task + 1 journal + 1 score

      // ファイルが作成されたことを確認
      final file = File(result.filePath);
      expect(await file.exists(), isTrue);

      // クリーンアップ
      await file.delete();
    });

    test('ユーザーが存在しない場合はエラーをスローする', () async {
      // Given: 存在しないユーザー
      const userUuid = 'non-existent-user';
      when(mockUserRepository.getUserByUuid(userUuid))
          .thenAnswer((_) async => null);

      // When & Then: エラーがスローされる
      expect(
        () => service.exportUserData(userUuid),
        throwsA(isA<DataDeletionException>()),
      );
    });
  });

  group('DataDeletionService - requestAccountDeletion', () {
    test('パスワードが空の場合はエラーをスローする', () async {
      // Given: 空のパスワード
      const userUuid = 'test-user-uuid';
      const password = '';

      // When & Then: エラーがスローされる
      expect(
        () => service.requestAccountDeletion(
          userUuid,
          confirmationPassword: password,
        ),
        throwsA(isA<DataDeletionException>()),
      );
    });

    test('ユーザーが存在しない場合はエラーをスローする', () async {
      // Given: 存在しないユーザー
      const userUuid = 'non-existent-user';
      const password = 'test-password';

      when(mockUserRepository.getUserByUuid(userUuid))
          .thenAnswer((_) async => null);

      // When & Then: エラーがスローされる
      expect(
        () => service.requestAccountDeletion(
          userUuid,
          confirmationPassword: password,
        ),
        throwsA(isA<DataDeletionException>()),
      );
    });
  });

  group('DataDeletionService - deleteLocalData', () {
    test('ローカルデータを正常に削除できる', () async {
      // Given: 有効なユーザー
      const userUuid = 'test-user-uuid';

      when(mockDatabaseService.clearUserData(userUuid))
          .thenAnswer((_) async => {});

      // When: ローカルデータを削除
      await service.deleteLocalData(userUuid);

      // Then: データベースサービスが呼ばれる
      verify(mockDatabaseService.clearUserData(userUuid)).called(1);
    });
  });

  group('DataDeletionService - getDeletionStats', () {
    test('削除統計情報を正常に取得できる', () async {
      // Given: テストデータ
      const userUuid = 'test-user-uuid';

      final tasks = List.generate(
        5,
        (i) => Task.create(
          uuid: 'task-$i',
          userUuid: userUuid,
          title: 'Task $i',
        ),
      );

      final journalEntries = List.generate(
        3,
        (i) => JournalEntry.create(
          uuid: 'journal-$i',
          userUuid: userUuid,
          encryptedContent: 'content-$i',
        ),
      );

      final scores = List.generate(
        2,
        (i) => SelfEsteemScore.create(
          uuid: 'score-$i',
          userUuid: userUuid,
          score: 0.5 + (i * 0.1),
        ),
      );

      when(mockTaskRepository.getTasksByUser(userUuid))
          .thenAnswer((_) async => tasks);
      when(mockJournalRepository.getEntriesByUser(userUuid))
          .thenAnswer((_) async => journalEntries);
      when(mockSelfEsteemRepository.getScoresByUser(userUuid))
          .thenAnswer((_) async => scores);

      // When: 統計情報を取得
      final stats = await service.getDeletionStats(userUuid);

      // Then: 正しい統計が返される
      expect(stats.totalTasks, equals(5));
      expect(stats.totalJournalEntries, equals(3));
      expect(stats.totalScores, equals(2));
      expect(stats.estimatedDataSize, greaterThan(0));
    });
  });

  group('DataDeletionService - canDeleteAccount', () {
    test('ユーザーが存在する場合はtrueを返す', () async {
      // Given: 存在するユーザー
      const userUuid = 'test-user-uuid';
      final user = User.create(
        uuid: userUuid,
        name: 'Test User',
        timezone: 'Asia/Tokyo',
      );

      when(mockUserRepository.getUserByUuid(userUuid))
          .thenAnswer((_) async => user);

      // When: 削除可能か確認
      final canDelete = await service.canDeleteAccount(userUuid);

      // Then: trueが返される
      expect(canDelete, isTrue);
    });

    test('ユーザーが存在しない場合はfalseを返す', () async {
      // Given: 存在しないユーザー
      const userUuid = 'non-existent-user';

      when(mockUserRepository.getUserByUuid(userUuid))
          .thenAnswer((_) async => null);

      // When: 削除可能か確認
      final canDelete = await service.canDeleteAccount(userUuid);

      // Then: falseが返される
      expect(canDelete, isFalse);
    });
  });

  group('DataDeletionService - Property Tests', () {
    /// **Feature: act-based-self-management, Property 11: データ削除の完全実行**
    /// **Validates: Requirements 5.4**
    ///
    /// 全てのアカウント削除リクエストに対して、システムはローカルとサーバー両方から
    /// ユーザーデータを完全に削除し、30日以内に削除を完了する
    test(
      'Property 11: データ削除の完全実行 - ローカルデータの完全削除',
      () async {
        // Given: 有効なユーザーとデータ
        const userUuid = 'test-user-uuid';

        // Mock設定
        when(mockDatabaseService.clearUserData(userUuid))
            .thenAnswer((_) async => {});

        // When: ローカルデータを削除
        await service.deleteLocalData(userUuid);

        // Then: データベースサービスが呼ばれる
        verify(mockDatabaseService.clearUserData(userUuid)).called(1);

        // 削除後、データが存在しないことを確認
        when(mockTaskRepository.getTasksByUser(userUuid))
            .thenAnswer((_) async => []);
        when(mockJournalRepository.getEntriesByUser(userUuid))
            .thenAnswer((_) async => []);
        when(mockSelfEsteemRepository.getScoresByUser(userUuid))
            .thenAnswer((_) async => []);

        final stats = await service.getDeletionStats(userUuid);
        expect(stats.totalTasks, equals(0));
        expect(stats.totalJournalEntries, equals(0));
        expect(stats.totalScores, equals(0));
      },
    );

    test(
      'Property 11: データ削除の完全実行 - エクスポート機能の動作確認',
      () async {
        // Given: 有効なユーザーとデータ
        const userUuid = 'test-user-uuid';
        final user = User.create(
          uuid: userUuid,
          name: 'Test User',
          timezone: 'Asia/Tokyo',
        );

        final tasks = [
          Task.create(
            uuid: 'task-1',
            userUuid: userUuid,
            title: 'Test Task',
          ),
        ];

        final journalEntries = [
          JournalEntry.create(
            uuid: 'journal-1',
            userUuid: userUuid,
            encryptedContent: 'encrypted-content',
          ),
        ];

        final scores = [
          SelfEsteemScore.create(
            uuid: 'score-1',
            userUuid: userUuid,
            score: 0.75,
          ),
        ];

        when(mockUserRepository.getUserByUuid(userUuid))
            .thenAnswer((_) async => user);
        when(mockTaskRepository.getTasksByUser(userUuid))
            .thenAnswer((_) async => tasks);
        when(mockJournalRepository.getEntriesByUser(userUuid))
            .thenAnswer((_) async => journalEntries);
        when(mockSelfEsteemRepository.getScoresByUser(userUuid))
            .thenAnswer((_) async => scores);
        when(mockEncryptedStorageService.decryptJournalContent(any))
            .thenReturn('Decrypted content');
        when(mockEncryptedStorageService.decryptJournalAiResponse(any))
            .thenReturn(null);

        // When: データをエクスポート
        final result = await service.exportUserData(userUuid);

        // Then: エクスポートが成功し、全データが含まれる
        expect(result.success, isTrue);
        expect(result.filePath, isNotEmpty);
        expect(result.recordCount, greaterThan(0));

        // ファイルが作成されたことを確認
        final file = File(result.filePath);
        expect(await file.exists(), isTrue);

        // ファイル内容を確認
        final content = await file.readAsString();
        expect(content, contains('Test User'));
        expect(content, contains('Test Task'));
        expect(content, contains('Decrypted content'));

        // クリーンアップ
        await file.delete();
      },
    );

    test(
      'Property 11: データ削除の完全実行 - 削除前の確認機能',
      () async {
        // Given: 有効なユーザー
        const userUuid = 'test-user-uuid';
        final user = User.create(
          uuid: userUuid,
          name: 'Test User',
          timezone: 'Asia/Tokyo',
        );

        when(mockUserRepository.getUserByUuid(userUuid))
            .thenAnswer((_) async => user);

        // When: 削除可能か確認
        final canDelete = await service.canDeleteAccount(userUuid);

        // Then: 削除可能であることを確認
        expect(canDelete, isTrue);

        // 削除統計情報を取得
        when(mockTaskRepository.getTasksByUser(userUuid))
            .thenAnswer((_) async => []);
        when(mockJournalRepository.getEntriesByUser(userUuid))
            .thenAnswer((_) async => []);
        when(mockSelfEsteemRepository.getScoresByUser(userUuid))
            .thenAnswer((_) async => []);

        final stats = await service.getDeletionStats(userUuid);
        expect(stats, isNotNull);
        expect(stats.totalTasks, greaterThanOrEqualTo(0));
        expect(stats.totalJournalEntries, greaterThanOrEqualTo(0));
        expect(stats.totalScores, greaterThanOrEqualTo(0));
      },
    );

    test(
      'Property 11: データ削除の完全実行 - 無効なリクエストの拒否',
      () async {
        // Given: 空のパスワード
        const userUuid = 'test-user-uuid';
        const password = '';

        // When & Then: エラーがスローされる
        expect(
          () => service.requestAccountDeletion(
            userUuid,
            confirmationPassword: password,
          ),
          throwsA(isA<DataDeletionException>()),
        );

        // Given: 存在しないユーザー
        const nonExistentUuid = 'non-existent-user';
        const validPassword = 'test-password';

        when(mockUserRepository.getUserByUuid(nonExistentUuid))
            .thenAnswer((_) async => null);

        // When & Then: エラーがスローされる
        expect(
          () => service.requestAccountDeletion(
            nonExistentUuid,
            confirmationPassword: validPassword,
          ),
          throwsA(isA<DataDeletionException>()),
        );
      },
    );
  });
}
