import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kokosid/core/services/supabase_service.dart';

/// Supabase接続テスト
///
/// このテストは以下を確認します:
/// 1. 環境変数の読み込み
/// 2. Supabaseの初期化
/// 3. 匿名認証
/// 4. テーブルへの接続確認
void main() {
  group('Supabase Connection Test', () {
    late SupabaseService supabaseService;

    setUpAll(() async {
      // 環境変数を読み込み
      await dotenv.load(fileName: '.env.local');

      supabaseService = SupabaseService.instance;
    });

    test('環境変数が正しく読み込まれているか確認', () {
      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      expect(url, isNotNull, reason: 'SUPABASE_URLが設定されていません');
      expect(anonKey, isNotNull, reason: 'SUPABASE_ANON_KEYが設定されていません');
      expect(url, isNot(contains('your-project-id')),
          reason: 'SUPABASE_URLがデフォルト値のままです');

      print('✓ 環境変数の読み込み成功');
      print('  URL: $url');
      print('  ANON_KEY: ${anonKey?.substring(0, 20)}...');
    });

    test('Supabaseの初期化', () async {
      final url = dotenv.env['SUPABASE_URL']!;
      final anonKey = dotenv.env['SUPABASE_ANON_KEY']!;

      await supabaseService.initialize(
        url: url,
        anonKey: anonKey,
      );

      expect(supabaseService.isInitialized, isTrue);
      print('✓ Supabaseの初期化成功');
    });

    test('匿名認証', () async {
      await supabaseService.signInAnonymously();

      expect(supabaseService.isAuthenticated, isTrue);
      expect(supabaseService.currentUserId, isNotNull);

      print('✓ 匿名認証成功');
      print('  User ID: ${supabaseService.currentUserId}');
    });

    test('usersテーブルへの接続確認', () async {
      try {
        // テーブルからデータを取得（空でもOK）
        final result = await supabaseService
            .fetchUser('test-uuid-${DateTime.now().millisecondsSinceEpoch}');

        // エラーが発生しなければ接続成功
        expect(result, isNull); // 存在しないUUIDなのでnullが返る
        print('✓ usersテーブルへの接続成功');
      } catch (e) {
        fail('usersテーブルへの接続に失敗: $e');
      }
    });

    test('tasksテーブルへの接続確認', () async {
      try {
        final result = await supabaseService
            .fetchTasks('test-uuid-${DateTime.now().millisecondsSinceEpoch}');

        expect(result, isA<List>());
        print('✓ tasksテーブルへの接続成功');
      } catch (e) {
        fail('tasksテーブルへの接続に失敗: $e');
      }
    });

    test('journal_entriesテーブルへの接続確認', () async {
      try {
        final result = await supabaseService.fetchJournalEntries(
            'test-uuid-${DateTime.now().millisecondsSinceEpoch}');

        expect(result, isA<List>());
        print('✓ journal_entriesテーブルへの接続成功');
      } catch (e) {
        fail('journal_entriesテーブルへの接続に失敗: $e');
      }
    });

    test('self_esteem_scoresテーブルへの接続確認', () async {
      try {
        final result = await supabaseService.fetchSelfEsteemScores(
            'test-uuid-${DateTime.now().millisecondsSinceEpoch}');

        expect(result, isA<List>());
        print('✓ self_esteem_scoresテーブルへの接続成功');
      } catch (e) {
        fail('self_esteem_scoresテーブルへの接続に失敗: $e');
      }
    });

    tearDownAll(() async {
      // クリーンアップ
      if (supabaseService.isAuthenticated) {
        await supabaseService.signOut();
        print('\n✓ サインアウト完了');
      }
    });
  });
}
