# テスト戦略

## 概要

Kokosidでは、ユニットテストとプロパティベーステストの両方を活用した包括的なテスト戦略を採用します。

## テストピラミッド

```
                    ┌─────────┐
                    │   E2E   │  ← 少数の重要なユーザーフロー
                   ─┴─────────┴─
                  ┌─────────────┐
                  │  統合テスト  │  ← コンポーネント間の連携
                 ─┴─────────────┴─
                ┌─────────────────┐
                │   ユニットテスト  │  ← 個別コンポーネント
               ─┴─────────────────┴─
              ┌───────────────────────┐
              │  プロパティベーステスト  │  ← 仕様の正確性検証
              └───────────────────────┘
```

## テストタイプ

### 1. ユニットテスト

個別のコンポーネントを分離してテストします。

**対象:**

- 特定の例とエッジケース
- コンポーネント間の統合ポイント
- エラー条件と境界値

**例:**

```dart
group('EncryptionService', () {
  test('初回起動時に暗号化キーが生成される', () async {
    // Given: 新しいデバイス
    await _clearSecureStorage();

    // When: アプリを初回起動
    await encryptionService.initialize();

    // Then: 暗号化キーが生成・保存される
    final key = await secureStorage.read(key: 'encryption_key');
    expect(key, isNotNull);
    expect(key!.length, equals(44)); // Base64エンコードされた256bitキー
  });
});

group('SelfEsteemCalculator', () {
  test('データがない場合はデフォルトスコアを返す', () async {
    final score = await calculator.calculateScore('new-user-uuid');
    expect(score, equals(0.5)); // デフォルト値
  });

  test('全項目が最大の場合は1.0を返す', () async {
    // Given: 全項目が最大値
    await setupMaximumScoreData('user-uuid');

    // When
    final score = await calculator.calculateScore('user-uuid');

    // Then
    expect(score, equals(1.0));
  });
});
```

### 2. プロパティベーステスト

仕様のプロパティが全ての入力に対して成立することを検証します。

**設定:**

- 最小100回の反復実行
- 各テストは設計書のプロパティを参照
- タグ形式: `Feature: act-based-self-management, Property {番号}: {テキスト}`

**例:**

```dart
// Feature: act-based-self-management, Property 1: マイクロ・チャンキング制約の遵守
@Tags(['property-test'])
void main() {
  group('MicroChunkingEngine Properties', () {
    testProperty(
      '全てのタスクが適切に分解される',
      iterations: 100,
      () {
        forAll(taskGenerator, (task) async {
          final steps = await microChunkingEngine.decomposeTask(task);

          // 7ステップ以下
          expect(steps.length, lessThanOrEqualTo(7));

          // 各ステップは5分以内
          expect(steps.every((s) => s.estimatedMinutes <= 5), isTrue);

          // 具体的な動詞で開始
          expect(steps.every((s) => s.action.startsWithActionVerb()), isTrue);

          // 成功条件が明確
          expect(steps.every((s) => s.successCriteria.isNotEmpty), isTrue);

          // 最初のステップは実行系
          expect(steps.first.action.isExecutionAction(), isTrue);
        });
      },
    );
  });
}

// Feature: act-based-self-management, Property 13: 自己肯定感スコア計算の一貫性
testProperty(
  '自己肯定感スコアが正しく計算される',
  () {
    forAll(userDataGenerator, (userData) async {
      final score = await calculator.calculateScore(userData.userUuid);

      // 0.0-1.0の範囲内
      expect(score, inInclusiveRange(0.0, 1.0));

      // 重み係数の検証
      final basis = await calculator.getCalculationBasis(userData.userUuid);
      final expectedScore =
        (basis.completionRate * 0.3) +
        (basis.positiveRatio * 0.4) +
        (basis.streakScore * 0.2) +
        (basis.engagementScore * 0.1);

      expect(score, closeTo(expectedScore, 0.001));
    });
  },
);
```

### 3. 統合テスト

複数のコンポーネントが連携して動作することを検証します。

**対象:**

- リポジトリ ↔ ストレージサービス
- AIサービス ↔ フォールバック
- 同期サービス ↔ Supabase

**例:**

```dart
group('Storage Integration', () {
  testWidgets('ユーザーCRUDが全プラットフォームで動作する', (tester) async {
    final storage = StorageServiceFactory.instance;
    await storage.initialize();

    // Create
    final user = User.create(uuid: 'test-uuid', name: 'Test');
    await storage.putUser(user);

    // Read
    final retrieved = await storage.getUserByUuid('test-uuid');
    expect(retrieved?.name, equals('Test'));

    // Update
    retrieved!.name = 'Updated';
    await storage.putUser(retrieved);
    final updated = await storage.getUserByUuid('test-uuid');
    expect(updated?.name, equals('Updated'));

    // Delete
    await storage.deleteUserByUuid('test-uuid');
    final deleted = await storage.getUserByUuid('test-uuid');
    expect(deleted, isNull);

    await storage.close();
  });
});
```

### 4. E2Eテスト

ユーザー視点でのフロー全体を検証します。

**対象:**

- オンボーディングフロー
- タスク作成 → 分解 → 完了フロー
- 日記記録 → 感情分析フロー

**例:**

```dart
testWidgets('タスク完了フロー', (tester) async {
  await tester.pumpWidget(const KokosidApp());

  // タスク追加
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), 'レポートを書く');
  await tester.tap(find.text('追加'));
  await tester.pumpAndSettle();

  // マイクロタスクに分解
  await tester.tap(find.text('レポートを書く'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('分解する'));
  await tester.pumpAndSettle();

  // マイクロタスクが表示される
  expect(find.byType(MicroTaskCard), findsWidgets);

  // タスク完了
  await tester.tap(find.byType(Checkbox).first);
  await tester.pumpAndSettle();

  // 完了アニメーションが表示される
  expect(find.byType(LottieAnimation), findsOneWidget);
});
```

## テストデータ生成

### ジェネレータ

```dart
// タスクジェネレータ
final taskGenerator = Generator<Task>((random) {
  return Task.create(
    uuid: Uuid().v4(),
    userUuid: 'test-user',
    title: _randomTaskTitle(random),
    estimatedMinutes: random.nextInt(120) + 5,
    priority: TaskPriority.values[random.nextInt(4)],
  );
});

// ユーザーデータジェネレータ
final userDataGenerator = Generator<UserTestData>((random) {
  return UserTestData(
    userUuid: Uuid().v4(),
    completedTasks: random.nextInt(20),
    totalTasks: random.nextInt(30) + 1,
    positiveEmotions: random.nextInt(10),
    totalEmotions: random.nextInt(15) + 1,
    consecutiveDays: random.nextInt(14),
    journalEntries: random.nextInt(10),
  );
});
```

## テスト設定

### pubspec.yaml

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
  # プロパティベーステスト用
  # test_property: ^1.0.0  # 利用可能になり次第追加
```

### テスト実行コマンド

```bash
# 全ユニットテスト
flutter test

# 特定のテストファイル
flutter test test/core/services/self_esteem_calculator_test.dart

# プロパティテストのみ
flutter test --tags property-test

# 統合テスト
flutter test integration_test/

# カバレッジ付き
flutter test --coverage
```

### CI/CD設定

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze
        run: flutter analyze

      - name: Unit Tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## テストファイル構成

```
test/
├── core/
│   ├── models/
│   │   ├── user_test.dart
│   │   ├── task_test.dart
│   │   └── ...
│   ├── repositories/
│   │   ├── user_repository_test.dart
│   │   └── ...
│   └── services/
│       ├── micro_chunking_engine_test.dart
│       ├── self_esteem_calculator_test.dart
│       ├── ai_service_with_fallback_test.dart
│       └── ...
├── property/
│   ├── micro_chunking_property_test.dart
│   ├── self_esteem_property_test.dart
│   └── ...
├── integration/
│   ├── storage_integration_test.dart
│   └── ...
└── mocks/
    ├── mock_ai_service.dart
    ├── mock_storage_service.dart
    └── ...

integration_test/
├── app_test.dart
├── onboarding_flow_test.dart
└── task_flow_test.dart
```

## 品質目標

| 指標                     | 目標値   |
| ------------------------ | -------- |
| コードカバレッジ         | >= 80%   |
| ユニットテスト実行時間   | < 60秒   |
| プロパティテスト反復回数 | >= 100回 |
| E2Eテスト合格率          | 100%     |

## 関連ドキュメント

- [正確性プロパティ](properties.md)
- [要件定義](requirements.md)
- [設計書](design.md)
