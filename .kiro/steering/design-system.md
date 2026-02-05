---
inclusion: always
---

# Kokosid Design System Rules

このドキュメントは、FigmaデザインをFlutter/Dartコードに統合する際のガイドラインです。

## 1. デザイントークン定義

### カラーパレット

すべてのカラーは `lib/presentation/theme/app_theme.dart` で定義されています。

```dart
// プライマリカラー
static const Color primaryColor = Color(0xFF6B73FF);      // メインブランドカラー
static const Color secondaryColor = Color(0xFF9C27B0);    // セカンダリアクセント
static const Color accentColor = Color(0xFFFF6B6B);       // 強調色

// 背景・サーフェス
static const Color backgroundColor = Color(0xFFF8F9FA);   // 背景色
static const Color surfaceColor = Color(0xFFFFFFFF);      // カード・サーフェス

// ステータスカラー
static const Color errorColor = Color(0xFFE57373);        // エラー
static const Color successColor = Color(0xFF81C784);      // 成功
static const Color warningColor = Color(0xFFFFB74D);      // 警告

// テキストカラー
static const Color textPrimary = Color(0xFF2D3748);       // 主要テキスト
static const Color textSecondary = Color(0xFF718096);     // 副次テキスト
static const Color textDisabled = Color(0xFFA0AEC0);      // 無効テキスト
```

**Figma統合ルール:**
- Figmaから色を抽出する際は、上記の定義済みカラーに最も近い色を使用
- 新しい色が必要な場合は、`AppTheme`クラスに追加してから使用
- `Theme.of(context).colorScheme`を通じてアクセス

### タイポグラフィ

Material 3のタイポグラフィスケールを使用:

```dart
// 見出し
displayLarge: 32px, bold          // 大見出し
displayMedium: 28px, bold         // 中見出し
displaySmall: 24px, w600          // 小見出し
headlineLarge: 22px, w600         // ヘッドライン大
headlineMedium: 20px, w600        // ヘッドライン中
headlineSmall: 18px, w600         // ヘッドライン小

// タイトル
titleLarge: 16px, w600            // タイトル大
titleMedium: 14px, w500           // タイトル中
titleSmall: 12px, w500            // タイトル小

// 本文
bodyLarge: 16px, normal           // 本文大
bodyMedium: 14px, normal          // 本文中
bodySmall: 12px, normal           // 本文小
```

**Figma統合ルール:**
- Figmaのテキストスタイルは上記のスケールにマッピング
- `Theme.of(context).textTheme`を使用してアクセス
- カスタムフォントウェイトは`copyWith()`で調整

### スペーシング

一貫したスペーシングシステム:

```dart
// 基本単位: 4px
4px   // 最小スペース
8px   // 小スペース
12px  // 中スペース
16px  // 標準スペース
20px  // 大スペース
24px  // 特大スペース
32px  // セクション間
```

**Figma統合ルール:**
- Figmaのスペーシングは4の倍数に丸める
- `EdgeInsets.symmetric()`, `EdgeInsets.all()`, `SizedBox`を使用

### ボーダーラジウス

```dart
8px   // 小要素（ボタン、入力フィールド）
12px  // 中要素（カード、ボタン）
16px  // 大要素（モーダル、コンテナ）
```

**Figma統合ルール:**
- `BorderRadius.circular()`で実装
- カードは12px、ボタンは8pxがデフォルト

### エレベーション（影）

```dart
elevation: 0  // フラット
elevation: 2  // カード、ボタン
elevation: 4  // ホバー状態
elevation: 8  // ナビゲーションバー
```

**Figma統合ルール:**
- Figmaのドロップシャドウは`elevation`プロパティにマッピング
- カスタムシャドウが必要な場合は`BoxShadow`を使用

## 2. コンポーネントライブラリ

### コンポーネント配置

```
lib/presentation/
├── widgets/              # 再利用可能なUIコンポーネント
│   ├── mood_selector.dart
│   ├── task_completion_animation.dart
│   ├── self_esteem_chart.dart
│   └── ...
└── screens/              # フルスクリーンページ
    ├── main_navigation_screen.dart
    ├── today_tab_screen.dart
    └── ...
```

### コンポーネントアーキテクチャ

**StatefulWidget vs StatelessWidget:**
- インタラクションや状態管理が必要 → `StatefulWidget`
- 表示のみ → `StatelessWidget`

**コンポーネント構造例:**

```dart
class CustomWidget extends StatefulWidget {
  const CustomWidget({
    required this.title,
    this.onTap,
    super.key,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      // 実装
    );
  }
}
```

### 既存コンポーネントの再利用

Figmaから新しいUIを生成する際は、以下の既存コンポーネントを優先的に使用:

**ナビゲーション:**
- `MainNavigationScreen` - ボトムナビゲーション
- カスタム`_NavigationButton` - タブボタン

**入力:**
- `MoodSelector` - 気分選択グリッド
- Material `TextField` - テキスト入力
- Material `ElevatedButton`, `TextButton`, `OutlinedButton` - ボタン

**表示:**
- `TaskCompletionAnimation` - Lottieアニメーション
- `SelfEsteemChart` - fl_chartグラフ
- Material `Card` - カードコンテナ

**アニメーション:**
- `AnimatedContainer` - コンテナアニメーション
- `AnimatedSwitcher` - ウィジェット切り替え
- `AnimatedDefaultTextStyle` - テキストスタイルアニメーション

## 3. フレームワーク & ライブラリ

### UIフレームワーク
- **Flutter 3.10.0+** with **Material 3** (`useMaterial3: true`)
- **Dart 3.0.0+**

### スタイリングアプローチ
- **Material Design 3** コンポーネント
- **ThemeData** による一元的なテーマ管理
- インラインスタイリング（CSS-in-Dartパターン）

### 主要UIライブラリ
```yaml
fl_chart: ^0.68.0           # チャート・グラフ
lottie: ^2.7.0              # アニメーション
provider: ^6.0.5            # 状態管理
```

### ビルドシステム
```bash
flutter pub get              # 依存関係インストール
flutter run                  # 開発実行
flutter build apk/ios/web    # プロダクションビルド
```

## 4. アセット管理

### アセット配置

```
assets/
└── animations/              # Lottieアニメーション
    ├── confetti.json        # タスク完了祝福
    ├── sparkle_star.json    # 達成キラキラ
    └── streak_flame.json    # 連続記録炎
```

### アセット参照

```dart
// Lottieアニメーション
Lottie.asset('assets/animations/confetti.json')

// 画像（将来的に追加される場合）
Image.asset('assets/images/example.png')
```

**pubspec.yaml設定:**
```yaml
flutter:
  assets:
    - assets/animations/
    - .env
    - .env.local
```

### アセット最適化
- Lottie JSONは軽量化済み
- 画像は必要に応じてWebP形式を使用
- アニメーションは200x200px程度のサイズで表示

## 5. アイコンシステム

### Material Icons使用

```dart
// アウトライン版（非選択状態）
Icons.today_outlined
Icons.chat_bubble_outline
Icons.trending_up_outlined

// フィル版（選択状態）
Icons.today
Icons.chat_bubble
Icons.trending_up
```

**Figma統合ルール:**
- Figmaのアイコンは[Material Symbols](https://fonts.google.com/icons)から選択
- カスタムアイコンが必要な場合はSVGをFlutterIconに変換

### アイコンサイズ

```dart
size: 16  // 小アイコン
size: 20  // 中アイコン（通知バッジなど）
size: 24  // 標準アイコン（ボタン、ナビゲーション）
size: 32  // 大アイコン（気分選択の絵文字など）
```

## 6. スタイリングアプローチ

### テーマベーススタイリング

**推奨パターン:**
```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return Container(
    color: colorScheme.surface,
    child: Text(
      'Hello',
      style: theme.textTheme.bodyLarge,
    ),
  );
}
```

### レスポンシブデザイン

```dart
// メディアクエリ
final screenWidth = MediaQuery.of(context).size.width;
final isSmallScreen = screenWidth < 600;

// レイアウトビルダー
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    }
    return DesktopLayout();
  },
)
```

### アニメーション

**推奨アニメーション:**
```dart
// 暗黙的アニメーション（簡単）
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  // プロパティ
)

// 明示的アニメーション（複雑）
AnimationController(vsync: this)
```

**アニメーション時間:**
- 短い遷移: 200ms
- 標準遷移: 300ms
- 長い遷移: 500ms

## 7. プロジェクト構造

```
lib/
├── main.dart                    # エントリーポイント
├── core/                        # ビジネスロジック
│   ├── models/                  # データモデル
│   ├── repositories/            # データアクセス
│   └── services/                # ビジネスサービス
└── presentation/                # UI層
    ├── app.dart                 # ルートアプリウィジェット
    ├── screens/                 # フルスクリーンページ
    ├── widgets/                 # 再利用可能コンポーネント
    └── theme/                   # テーマ定義
        └── app_theme.dart       # ★ デザイントークンの中心
```

### ファイル命名規則
- スネークケース: `mood_selector.dart`
- クラス名はパスカルケース: `MoodSelector`
- プライベートクラスはアンダースコア: `_MoodButton`

## 8. Figma → Flutter 変換ガイドライン

### ステップ1: デザイントークンのマッピング

1. Figmaの色 → `AppTheme`の定義済みカラー
2. Figmaのテキストスタイル → `TextTheme`のスタイル
3. Figmaのスペーシング → 4の倍数に丸める

### ステップ2: コンポーネント構造の決定

1. 既存コンポーネントで実現可能か確認
2. 新規コンポーネントが必要な場合は`widgets/`に配置
3. 状態管理が必要か判断（StatefulWidget vs StatelessWidget）

### ステップ3: レイアウト実装

**Flutterレイアウトウィジェット:**
```dart
Column          // 縦並び
Row             // 横並び
Stack           // 重ね合わせ
GridView        // グリッド
ListView        // リスト
Wrap            // 折り返し
```

### ステップ4: インタラクション実装

```dart
// タップ
InkWell(
  onTap: () {},
  child: ...,
)

// ジェスチャー
GestureDetector(
  onTap: () {},
  onLongPress: () {},
  child: ...,
)
```

### ステップ5: アニメーション追加

```dart
// 状態変化のアニメーション
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  color: isSelected ? primaryColor : surfaceColor,
)
```

## 9. コード品質ガイドライン

### 必須事項

1. **constコンストラクタを優先**
```dart
const SizedBox(height: 16)  // ✅ Good
SizedBox(height: 16)         // ❌ Bad
```

2. **テーマを使用**
```dart
Theme.of(context).colorScheme.primary  // ✅ Good
Color(0xFF6B73FF)                      // ❌ Bad
```

3. **マジックナンバーを避ける**
```dart
const double _cardRadius = 12.0;  // ✅ Good
BorderRadius.circular(12)         // ❌ Bad（定数化推奨）
```

4. **アクセシビリティ**
```dart
Semantics(
  label: '気分を選択',
  child: MoodSelector(),
)
```

### リンティングルール

`analysis_options.yaml`に従う:
- シングルクォート優先
- 未使用インポート削除
- `print`文を避ける（`debugPrint`使用）

## 10. Figma MCP統合の実践例

### 例1: ボタンコンポーネント

**Figma出力（React + Tailwind想定）:**
```jsx
<button className="bg-blue-500 text-white px-6 py-3 rounded-lg">
  Click me
</button>
```

**Flutter変換:**
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text('Click me'),
)
```

### 例2: カードコンポーネント

**Figma出力:**
```jsx
<div className="bg-white rounded-xl shadow-md p-6">
  <h2>Title</h2>
  <p>Content</p>
</div>
```

**Flutter変換:**
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Content',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  ),
)
```

## まとめ

Figmaデザインを統合する際は:

1. ✅ `AppTheme`の定義済みトークンを使用
2. ✅ 既存コンポーネントを優先的に再利用
3. ✅ Material 3のコンポーネントを活用
4. ✅ テーマベーススタイリングを徹底
5. ✅ 4の倍数のスペーシングを維持
6. ✅ アニメーションは200-300msで統一
7. ✅ constコンストラクタを優先
8. ✅ アクセシビリティを考慮

これにより、デザインとコードの一貫性を保ちながら、保守性の高いFlutterアプリケーションを構築できます。
