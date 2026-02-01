# マイクロ・チャンキング機能 実装ノート

## 実装完了日
2026年2月1日

## 実装内容

### タスク 5.1: タスク分解エンジンの実装 ✅

#### 実装ファイル
- `lib/core/services/ai_service.dart` - AI サービスの抽象インターフェースと Claude API 実装
- `lib/core/services/micro_chunking_engine.dart` - マイクロ・チャンキング・エンジン本体

#### 主な機能
1. **AIプロンプトテンプレート**
   - ADHD特性を持つ人向けの専門的なタスク分解プロンプト
   - 5つの分解原則を明確に指定
   - JSON形式での構造化された出力

2. **分解ロジック**
   - 各ステップは5分以内で完了可能
   - 具体的な動詞で開始
   - 成功条件が明確
   - 最初のステップは実行系
   - 最大7ステップまで（認知負荷軽減）

3. **制約の適用**
   - 5分を超えるステップの自動除外
   - 7ステップ制限の適用
   - マイクロタスクの自動保存

#### 要件の充足
- ✅ 要件 1.1: 5分以内のステップに分解
- ✅ 要件 1.2: 具体的な動詞で開始
- ✅ 要件 1.3: 成功条件が明確
- ✅ 要件 1.4: 最初のステップは実行系
- ✅ 要件 1.5: 最大7ステップまで

### タスク 5.3: タスク管理UIの実装 ✅

#### 実装ファイル
- `lib/presentation/screens/task_list_screen.dart` - タスク一覧画面
- `lib/presentation/screens/add_task_screen.dart` - タスク追加画面
- `lib/presentation/screens/task_detail_screen.dart` - タスク詳細画面（マイクロタスク表示含む）

#### 主な機能

##### タスク一覧画面
- タスクのフィルタリング（すべて、未完了、完了済み、今日）
- タスクカードの表示（チェックボックス、推定時間、期限、ステータス）
- プルトゥリフレッシュ
- タスク追加ボタン

##### タスク追加画面
- タスクの内容入力
- 詳細説明（任意）
- 推定時間選択（5分〜120分）
- 期限設定（任意）
- 優先度選択（低、中、高、緊急）
- コンテキスト入力（任意）

##### タスク詳細画面
- タスク情報の表示
- チェックボックスでの完了/未完了切り替え
- マイクロタスクセクション
  - AI分解ボタン
  - 進捗バー表示
  - ステップ番号付きマイクロタスクリスト
  - 各マイクロタスクのチェックオフ機能
  - 全マイクロタスク完了時の親タスク自動完了
- タスク編集・削除機能

#### 要件の充足
- ✅ 要件 1.1: タスク追加・編集・削除機能
- ✅ 要件 5.5: マイクロタスク表示とチェックオフ機能

## テスト

### ユニットテスト
- `test/core/services/micro_chunking_engine_test.dart`
  - タスクを5分以内のステップに分解
  - 最大7ステップまでに制限
  - 5分を超えるステップの除外
  - マイクロタスクの取得
  - 全マイクロタスク完了チェック

**テスト結果**: ✅ 全6テストが成功

## 使用方法

### 1. タスクの追加
```dart
// タスク一覧画面から「タスク追加」ボタンをタップ
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddTaskScreen(
      userUuid: userUuid,
      taskRepository: taskRepository,
    ),
  ),
);
```

### 2. タスクの分解
```dart
// タスク詳細画面で「AI分解」ボタンをタップ
final microTasks = await microChunkingEngine.decomposeTask(task);
```

### 3. マイクロタスクの完了
```dart
// マイクロタスクのチェックボックスをタップ
await microChunkingEngine.completeMicroTask(microTaskUuid);
```

## 注意事項

### API キーの設定
現在、`task_detail_screen.dart` の `_initializeMicroChunkingEngine()` メソッドで API キーがハードコードされています。

```dart
// TODO: API キーを環境変数から取得
final aiService = ClaudeAIService(apiKey: 'your-api-key-here');
```

本番環境では、以下のように環境変数から取得してください：

```dart
final apiKey = const String.fromEnvironment('CLAUDE_API_KEY');
final aiService = ClaudeAIService(apiKey: apiKey);
```

### オフライン対応
現在の実装では、タスク分解にクラウドAI（Claude API）を使用しています。オフライン時の対応として、以下の改善が推奨されます：

1. ローカルAIへのフォールバック
2. 事前定義済みの分解パターンの使用
3. ネットワーク状態の検出と適切なエラーハンドリング

## 次のステップ

### タスク 5.2: マイクロ・チャンキングのプロパティテスト作成（オプション）
プロパティベーステストを実装して、以下を検証：
- **プロパティ1**: マイクロ・チャンキング制約の遵守
- 全てのタスクに対して、分解されたステップが制約を満たすことを検証

### 推奨される改善
1. タスク編集機能の実装
2. API キーの環境変数化
3. オフライン対応の強化
4. エラーハンドリングの改善
5. ローディング状態の改善
6. アニメーション効果の追加

## 関連ドキュメント
- [要件定義書](./requirements.md)
- [設計書](./design.md)
- [タスクリスト](./tasks.md)
