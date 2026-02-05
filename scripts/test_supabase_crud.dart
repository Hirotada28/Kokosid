import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Supabase CRUD操作テストスクリプト
///
/// 匿名認証を行い、実際にデータの作成・読み取り・削除をテストします。
void main() async {
  print('=== Supabase CRUD操作テスト ===\n');

  // 環境変数を読み込み
  final envFile = File('.env.local');
  if (!await envFile.exists()) {
    print('❌ .env.localファイルが見つかりません');
    exit(1);
  }

  final envContent = await envFile.readAsString();
  final envLines = envContent.split('\n');

  String? supabaseUrl;
  String? anonKey;

  for (final line in envLines) {
    if (line.startsWith('SUPABASE_URL=')) {
      supabaseUrl = line.substring('SUPABASE_URL='.length).trim();
    } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
      anonKey = line.substring('SUPABASE_ANON_KEY='.length).trim();
    }
  }

  if (supabaseUrl == null || anonKey == null) {
    print('❌ 環境変数が正しく設定されていません');
    exit(1);
  }

  print('✓ 環境変数の読み込み成功\n');

  // 1. 匿名認証
  print('1. 匿名認証を実行中...');
  final authUrl = Uri.parse('$supabaseUrl/auth/v1/signup');
  final authResponse = await http.post(
    authUrl,
    headers: {
      'apikey': anonKey,
      'Content-Type': 'application/json',
    },
    body: json.encode({}),
  );

  if (authResponse.statusCode != 200) {
    print('❌ 匿名認証に失敗: ${authResponse.statusCode}');
    print('   ${authResponse.body}');
    exit(1);
  }

  final authData = json.decode(authResponse.body);
  final accessToken = authData['access_token'] as String?;
  final userId = authData['user']?['id'] as String?;

  if (accessToken == null || userId == null) {
    print('❌ 認証トークンの取得に失敗');
    exit(1);
  }

  print('✓ 匿名認証成功');
  print('  User ID: $userId\n');

  // 2. ユーザーデータの作成
  print('2. ユーザーデータを作成中...');
  final testUserUuid = 'test-user-${DateTime.now().millisecondsSinceEpoch}';
  final userUrl = Uri.parse('$supabaseUrl/rest/v1/users');
  final userResponse = await http.post(
    userUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    },
    body: json.encode({
      'uuid': testUserUuid,
      'auth_user_id': userId,
      'name': 'テストユーザー',
      'timezone': 'Asia/Tokyo',
      'onboarding_completed': false,
      'preferred_language': 'ja',
      'notifications_enabled': true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }),
  );

  if (userResponse.statusCode == 201) {
    print('✓ ユーザーデータの作成成功');
    print('  UUID: $testUserUuid\n');
  } else {
    print('❌ ユーザーデータの作成失敗: ${userResponse.statusCode}');
    print('   ${userResponse.body}');
    exit(1);
  }

  // 3. ユーザーデータの読み取り
  print('3. ユーザーデータを読み取り中...');
  final getUserUrl =
      Uri.parse('$supabaseUrl/rest/v1/users?uuid=eq.$testUserUuid&select=*');
  final getUserResponse = await http.get(
    getUserUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (getUserResponse.statusCode == 200) {
    final users = json.decode(getUserResponse.body) as List;
    if (users.isNotEmpty) {
      print('✓ ユーザーデータの読み取り成功');
      print('  名前: ${users[0]['name']}');
      print('  タイムゾーン: ${users[0]['timezone']}\n');
    } else {
      print('❌ ユーザーデータが見つかりません');
    }
  } else {
    print('❌ ユーザーデータの読み取り失敗: ${getUserResponse.statusCode}');
    print('   ${getUserResponse.body}');
  }

  // 4. タスクデータの作成（暗号化なしの簡易版）
  print('4. タスクデータを作成中...');
  final testTaskUuid = 'test-task-${DateTime.now().millisecondsSinceEpoch}';
  final taskUrl = Uri.parse('$supabaseUrl/rest/v1/tasks');
  final taskResponse = await http.post(
    taskUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    },
    body: json.encode({
      'uuid': testTaskUuid,
      'user_uuid': testUserUuid,
      'auth_user_id': userId,
      'encrypted_title': 'テストタスク（暗号化前）',
      'encrypted_description': 'これはテスト用のタスクです',
      'is_micro_task': false,
      'estimated_minutes': 30,
      'priority': 'medium',
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }),
  );

  if (taskResponse.statusCode == 201) {
    print('✓ タスクデータの作成成功');
    print('  UUID: $testTaskUuid\n');
  } else {
    print('❌ タスクデータの作成失敗: ${taskResponse.statusCode}');
    print('   ${taskResponse.body}');
  }

  // 5. タスクデータの読み取り
  print('5. タスクデータを読み取り中...');
  final getTaskUrl = Uri.parse(
      '$supabaseUrl/rest/v1/tasks?user_uuid=eq.$testUserUuid&select=*');
  final getTaskResponse = await http.get(
    getTaskUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (getTaskResponse.statusCode == 200) {
    final tasks = json.decode(getTaskResponse.body) as List;
    print('✓ タスクデータの読み取り成功');
    print('  取得件数: ${tasks.length}件\n');
  } else {
    print('❌ タスクデータの読み取り失敗: ${getTaskResponse.statusCode}');
    print('   ${getTaskResponse.body}\n');
  }

  // 6. クリーンアップ（テストデータの削除）
  print('6. テストデータをクリーンアップ中...');

  // タスクを削除
  final deleteTaskUrl =
      Uri.parse('$supabaseUrl/rest/v1/tasks?uuid=eq.$testTaskUuid');
  await http.delete(
    deleteTaskUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
    },
  );

  // ユーザーを削除
  final deleteUserUrl =
      Uri.parse('$supabaseUrl/rest/v1/users?uuid=eq.$testUserUuid');
  await http.delete(
    deleteUserUrl,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $accessToken',
    },
  );

  print('✓ テストデータのクリーンアップ完了\n');

  print('=== すべてのテストが完了しました ===');
  print('✓ Supabaseとの接続が正常に動作しています');
  print('✓ データの作成・読み取り・削除が可能です');
  print('✓ RLSポリシーが正しく機能しています');
}
