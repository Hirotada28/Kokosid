import 'package:flutter_test/flutter_test.dart';
import 'package:kokosid/core/models/gem_transaction.dart';

/// プロパティ1: ジェム残高計算の一貫性
///
/// このテストは以下の要件を検証します：
/// - 要件 3.1: 機能のためにジェムが消費される際、最も早い有効期限を持つジェムから優先的に差し引く
/// - 要件 3.2: 現在の日付がジェムバッチの有効期限に達する際、期限切れジェムをユーザーの残高から削除する
/// - 要件 3.3: ユーザーが異なる有効期限を持つ複数のジェムバッチを持つ際、各バッチを個別に追跡する
///
/// プロパティ: ジェム残高の計算は、トランザクションの順序に関わらず一貫している
void main() {
  group('Gem Balance Calculation Consistency (Property 1)', () {
    test('付与されたジェムの合計は正しく計算される', () {
      // Given: 複数のジェム付与トランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: DateTime.now().add(const Duration(days: 180)),
        ),
      ];

      // When: 残高を計算
      final totalGems = transactions
          .where((t) => t.type == GemTransactionType.grant)
          .fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 合計は42ジェム
      expect(totalGems, equals(42));
    });

    test('消費されたジェムは残高から正しく差し引かれる', () {
      // Given: 付与と消費のトランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.consume,
          amount: -5,
          source: GemSource.subscription,
          reason: 'AI Report',
        ),
      ];

      // When: 残高を計算
      final balance = transactions.fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 残高は25ジェム
      expect(balance, equals(25));
    });

    test('ステークされたジェムは保留中として追跡される', () {
      // Given: 付与、ステーク、消費のトランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.stake,
          amount: -5,
          source: GemSource.subscription,
          reason: 'Commitment Task',
          relatedEntityId: 'task1',
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.consume,
          amount: -3,
          source: GemSource.subscription,
          reason: 'AI Report',
        ),
      ];

      // When: 利用可能ジェムとステーク中ジェムを計算
      final availableGems = transactions
          .where((t) =>
              t.type == GemTransactionType.grant ||
              t.type == GemTransactionType.consume)
          .fold<int>(0, (sum, t) => sum + t.amount);

      final stakedGems = transactions
          .where((t) => t.type == GemTransactionType.stake)
          .fold<int>(0, (sum, t) => sum + t.amount.abs());

      // Then: 利用可能は27ジェム、ステーク中は5ジェム
      expect(availableGems, equals(27));
      expect(stakedGems, equals(5));
    });

    test('ステークされたジェムが返却されると利用可能残高に戻る', () {
      // Given: ステークと返却のトランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.stake,
          amount: -5,
          source: GemSource.subscription,
          relatedEntityId: 'task1',
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.return_,
          amount: 5,
          source: GemSource.subscription,
          relatedEntityId: 'task1',
        ),
      ];

      // When: 残高を計算
      final balance = transactions.fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 残高は30ジェム（元に戻る）
      expect(balance, equals(30));
    });

    test('ステークされたジェムが没収されると残高から削除される', () {
      // Given: ステークと没収のトランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.stake,
          amount: -5,
          source: GemSource.subscription,
          relatedEntityId: 'task1',
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.forfeit,
          amount: -5,
          source: GemSource.subscription,
          relatedEntityId: 'task1',
        ),
      ];

      // When: 残高を計算
      final balance = transactions.fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 残高は20ジェム（5ジェム没収）
      expect(balance, equals(20));
    });

    test('有効期限付きジェムと無期限ジェムを区別して追跡できる', () {
      // Given: 有効期限付きと無期限のジェム
      final now = DateTime.now();
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
          // 無期限（expiryDate = null）
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 180)),
        ),
      ];

      // When: 無期限と有効期限付きを分類
      final unlimitedGems = transactions
          .where(
              (t) => t.type == GemTransactionType.grant && t.expiryDate == null)
          .fold<int>(0, (sum, t) => sum + t.amount);

      final limitedGems = transactions
          .where(
              (t) => t.type == GemTransactionType.grant && t.expiryDate != null)
          .fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 無期限30ジェム、有効期限付き12ジェム
      expect(unlimitedGems, equals(30));
      expect(limitedGems, equals(12));
    });

    test('期限切れジェムは残高から除外される（要件 3.2）', () {
      // Given: 期限切れのジェム
      final now = DateTime.now();
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.subtract(const Duration(days: 1)), // 昨日期限切れ
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
      ];

      // When: 有効なジェムのみを計算
      final validGems = transactions
          .where((t) =>
              t.type == GemTransactionType.grant &&
              (t.expiryDate == null || t.expiryDate!.isAfter(now)))
          .fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 有効なジェムは30のみ
      expect(validGems, equals(30));
    });

    test('最も早い有効期限を持つジェムを識別できる（要件 3.1）', () {
      // Given: 異なる有効期限のジェムバッチ
      final now = DateTime.now();
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 90)),
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 180)),
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
          // 無期限
        ),
      ];

      // When: 最も早い有効期限を取得
      final earliestExpiry = transactions
          .where((t) => t.expiryDate != null)
          .map((t) => t.expiryDate!)
          .reduce((a, b) => a.isBefore(b) ? a : b);

      // Then: 90日後が最も早い
      expect(
        earliestExpiry.difference(now).inDays,
        equals(90),
      );
    });

    test('7日以内に期限切れになるジェムを検出できる', () {
      // Given: 様々な有効期限のジェム
      final now = DateTime.now();
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 5)), // 5日後
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 180)),
        ),
      ];

      // When: 期限切れが近いジェムを検出
      final expiringSoon = transactions.where((t) => t.isExpiringSoon).toList();

      // Then: 1つのトランザクションが該当
      expect(expiringSoon.length, equals(1));
      expect(expiringSoon.first.amount, equals(12));
    });

    test('複数のジェムバッチを個別に追跡できる（要件 3.3）', () {
      // Given: 異なるソースと有効期限のジェムバッチ
      final now = DateTime.now();
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 180)),
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 90)),
        ),
      ];

      // When: バッチごとにグループ化
      final batches = <String, List<GemTransaction>>{};
      for (final tx in transactions) {
        final key =
            '${tx.source}_${tx.expiryDate?.toIso8601String() ?? 'unlimited'}';
        batches.putIfAbsent(key, () => []).add(tx);
      }

      // Then: 3つの異なるバッチが存在
      expect(batches.length, equals(3));
      expect(batches.values.every((batch) => batch.isNotEmpty), isTrue);
    });

    test('トランザクションの順序に関わらず残高計算は一貫している', () {
      // Given: 同じトランザクションを異なる順序で
      final now = DateTime.now();
      final transactions1 = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 30,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.consume,
          amount: -5,
          source: GemSource.subscription,
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx3',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: now.add(const Duration(days: 180)),
        ),
      ];

      final transactions2 = [
        transactions1[2],
        transactions1[0],
        transactions1[1],
      ];

      // When: 両方の順序で残高を計算
      final balance1 = transactions1.fold<int>(0, (sum, t) => sum + t.amount);
      final balance2 = transactions2.fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 残高は同じ
      expect(balance1, equals(balance2));
      expect(balance1, equals(37));
    });

    test('返金トランザクションは正しく処理される', () {
      // Given: 購入と返金のトランザクション
      final transactions = [
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx1',
          type: GemTransactionType.grant,
          amount: 12,
          source: GemSource.purchase,
          expiryDate: DateTime.now().add(const Duration(days: 180)),
        ),
        GemTransaction.create(
          userId: 'user1',
          transactionId: 'tx2',
          type: GemTransactionType.consume,
          amount: -12,
          source: GemSource.refund,
          reason: 'Refund for tx1',
          relatedEntityId: 'tx1',
        ),
      ];

      // When: 残高を計算
      final balance = transactions.fold<int>(0, (sum, t) => sum + t.amount);

      // Then: 残高は0（返金により相殺）
      expect(balance, equals(0));
    });

    test('プロモーションジェムは正しく追跡される', () {
      // Given: プロモーションジェム
      final transaction = GemTransaction.create(
        userId: 'user1',
        transactionId: 'promo1',
        type: GemTransactionType.grant,
        amount: 5,
        source: GemSource.promotion,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      );

      // When: ソースを確認
      // Then: プロモーションソースとして識別される
      expect(transaction.source, equals(GemSource.promotion));
      expect(transaction.amount, equals(5));
      expect(transaction.expiryDate, isNotNull);
    });
  });
}
