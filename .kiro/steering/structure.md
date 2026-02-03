# プロジェクト構造

## ルートディレクトリレイアウト

```
kokosid/
├── lib/                    # アプリケーションソースコード
├── test/                   # ユニットテストと統合テスト
├── assets/                 # 静的アセット（アニメーション、画像）
├── android/                # Androidプラットフォームコード
├── ios/                    # iOSプラットフォームコード
├── web/                    # Webプラットフォームコード
├── windows/                # Windowsプラットフォームコード
├── linux/                  # Linuxプラットフォームコード
├── macos/                  # macOSプラットフォームコード
├── scripts/                # ユーティリティスクリプト
└── .kiro/                  # Kiro AI アシスタント設定
    ├── specs/              # 機能仕様
    └── steering/           # AIステアリングルール
```

## コアアプリケーション構造（`lib/`）

```
lib/
├── main.dart               # アプリケーションエントリーポイント
├── core/                   # コアビジネスロジック
│   ├── models/             # データモデル（Isarコレクション）
│   ├── repositories/       # データアクセス層
│   └── services/           # ビジネスロジックサービス
└── presentation/           # UI層
    ├── app.dart            # ルートアプリウィジェット
    ├── screens/            # フルスクリーンページ
    ├── widgets/            # 再利用可能なUIコンポーネント
    └── theme/              # テーマ設定
```

## コアモデル（`lib/core/models/`）

Isarを使用した永続化データモデル:
- `task.dart` - マイクロタスクサポート付きタスク管理
- `user.dart` - ユーザープロファイルと設定
- `journal_entry.dart` - 日記エントリー
- `self_esteem_score.dart` - 自己肯定感トラッキング
- `success_experience.dart` - 達成記録
- `emotion.dart` - 感情分類
- `act_process.dart` - ACTセラピープロセスタイプ
- `dialogue_entry.dart` - 会話履歴
- `user_context.dart` - ユーザー状態とトレンド
- `notification_tone.dart` - 通知設定

生成ファイル: `*.g.dart`（Isarコレクション、JSONシリアライゼーション）

## コアサービス（`lib/core/services/`）

ドメイン別に整理されたビジネスロジック:

### AI & 対話
- `ai_service.dart` - AI API統合
- `ai_service_with_fallback.dart` - フォールバック処理
- `local_ai_service.dart` - オンデバイスAI
- `act_dialogue_engine.dart` - ACTベース会話エンジン
- `dialogue_history_service.dart` - 会話トラッキング
- `personalized_praise_service.dart` - カスタマイズされた励まし

### タスク管理
- `micro_chunking_engine.dart` - タスク分解ロジック
- `precision_nudging_system.dart` - スマートリマインダー
- `productive_hour_predictor.dart` - 最適タイミング予測
- `task_completion_animation_service.dart` - お祝いアニメーション

### 感情 & 分析
- `emotion_analyzer.dart` - 多層感情検出
- `emotion_trend_analyzer.dart` - 感情パターン分析
- `text_emotion_classifier.dart` - テキストベース感情検出
- `acoustic_analyzer.dart` - 音声トーン分析
- `self_esteem_calculator.dart` - 自己肯定感スコアリング

### オーディオ
- `audio_recording_service.dart` - 音声入力録音
- `audio_playback_service.dart` - 音声再生
- `whisper_service.dart` - 音声テキスト変換

### データ & ストレージ
- `database_service.dart` - データベース初期化と管理
- `local_storage_service.dart` - 抽象ストレージインターフェース
- `storage_service_factory.dart` - プラットフォーム固有ストレージ
- `storage_service_native.dart` - Isar実装
- `storage_service_web.dart` - Hive実装
- `isar_storage_service.dart` - Isarラッパー
- `web_storage_service.dart` - Webストレージラッパー

### セキュリティ & 同期
- `encryption_service.dart` - AES-256暗号化
- `encryption_key_recovery.dart` - キーリカバリーメカニズム
- `encrypted_storage_service.dart` - 暗号化データ層
- `supabase_service.dart` - バックエンド同期
- `sync_queue_service.dart` - オフライン同期キュー
- `offline_manager.dart` - オフラインモード処理
- `conflict_resolver.dart` - 同期競合解決

### システム
- `app_config_service.dart` - 環境設定
- `notification_service.dart` - ローカル通知
- `network_service.dart` - ネットワーク状態監視
- `user_context_service.dart` - ユーザー状態管理
- `data_deletion_service.dart` - アカウント削除
- `achievement_streak_system.dart` - 連続記録トラッキング

## コアリポジトリ（`lib/core/repositories/`）

データアクセス抽象化層:
- `task_repository.dart` - タスクCRUD操作
- `user_repository.dart` - ユーザーデータ管理
- `journal_repository.dart` - 日記エントリーアクセス
- `self_esteem_repository.dart` - 自己肯定感データ
- `success_experience_repository.dart` - 達成記録

## プレゼンテーション層（`lib/presentation/`）

### スクリーン（`lib/presentation/screens/`）
- `splash_screen.dart` - 初期ローディング画面
- `main_navigation_screen.dart` - ボトムナビゲーションコンテナ
- `home_screen.dart` - ホーム/ダッシュボード
- `today_tab_screen.dart` - 今日のタスクタブ
- `dialogue_tab_screen.dart` - AI会話タブ
- `progress_tab_screen.dart` - 進捗トラッキングタブ
- `task_list_screen.dart` - タスクリストビュー
- `task_detail_screen.dart` - タスク詳細
- `add_task_screen.dart` - タスク作成
- `account_deletion_screen.dart` - アカウント管理

### ウィジェット（`lib/presentation/widgets/`）
再利用可能なUIコンポーネント:
- `voice_input_button.dart` - 音声録音ボタン
- `mood_selector.dart` - 感情選択
- `emotion_tags.dart` - 感情表示チップ
- `task_suggestion_card.dart` - AIタスク提案
- `task_completion_animation.dart` - お祝いエフェクト
- `greeting_header.dart` - パーソナライズされた挨拶
- `self_esteem_chart.dart` - 自己肯定感可視化
- `long_term_growth_chart.dart` - 長期トレンド
- `growth_trend_indicator.dart` - トレンド矢印
- `monthly_stats_card.dart` - 月次統計
- `achievement_list.dart` - 達成表示
- `dialogue_history.dart` - 会話履歴
- `progress_approval_banner.dart` - 励ましバナー

### テーマ（`lib/presentation/theme/`）
- `app_theme.dart` - ライトとダークテーマ定義

## テスト構造（`test/`）

```
test/
├── core/
│   ├── repositories/       # リポジトリテスト
│   └── services/           # サービステスト（ユニット + プロパティベース）
└── integration/            # 統合テストとE2Eテスト
```

### テスト規約
- ユニットテスト: `*_test.dart`
- モックファイル: `*_test.mocks.dart`（mockitoで生成）
- プロパティベーステストはサービステストに含まれる
- 統合テストは別ディレクトリ

## アセット（`assets/`）

```
assets/
└── animations/             # Lottieアニメーションファイル
    ├── confetti.json       # タスク完了のお祝い
    ├── sparkle_star.json   # 達成のキラキラ
    └── streak_flame.json   # 連続記録の炎
```

## 設定ファイル

- `pubspec.yaml` - 依存関係とアセット宣言
- `analysis_options.yaml` - リンティングルール
- `build.yaml` - ビルド設定
- `.env` / `.env.local` - 環境変数
- `devtools_options.yaml` - DevTools設定

## データベーススキーマ

- `supabase_schema.sql` - Supabase PostgreSQLスキーマ
- モデルはローカルデータベース用にIsarアノテーションを使用
- リポジトリがローカルとリモート間の同期を処理

## 命名規則

### ファイル
- スネークケース: `act_dialogue_engine.dart`
- テストファイル: `act_dialogue_engine_test.dart`
- 生成ファイル: `task.g.dart`

### クラス
- パスカルケース: `ACTDialogueEngine`
- プライベートクラス: `_PrivateHelper`

### 変数 & 関数
- キャメルケース: `generateResponse`
- プライベートメンバー: `_privateMethod`
- 定数: `kConstantValue` または `CONSTANT_VALUE`

### Enum
- 型はパスカルケース: `TaskStatus`
- 値はキャメルケース: `TaskStatus.inProgress`

## インポート整理

1. Dart SDKインポート
2. Flutterインポート
3. パッケージインポート
4. 相対インポート（リンティングルールに従い相対インポートを優先）

例:
```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/task.dart';
import '../services/database_service.dart';
```
