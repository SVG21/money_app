import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';
import 'package:money_app/core/utils.dart';

void main() {
  group('Transaction Grouping and Formatting Tests', () {
    test('Transactions are grouped correctly by date', () {
      final transactions = [
        Transaction(
          type: TransactionType.payment,
          name: 'Amazon',
          amount: 30.0,
          date: DateTime.now(),
        ),
        Transaction(
          type: TransactionType.topup,
          name: 'Top Up',
          amount: 100.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          type: TransactionType.payment,
          name: 'Ebay',
          amount: 25.0,
          date: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];

      final groupedTransactions = groupTransactionsByDate(transactions);

      expect(groupedTransactions.containsKey('TODAY'), true);
      expect(groupedTransactions.containsKey('YESTERDAY'), true);
      expect(groupedTransactions.containsKey(formatDate(transactions[2].date)),
          true);
    });

    test('Empty transaction list should return no groups', () {
      final transactions = <Transaction>[];

      final groupedTransactions = groupTransactionsByDate(transactions);

      expect(groupedTransactions.isEmpty, true);
    });

    test('Single transaction should be in the correct group', () {
      final transactions = [
        Transaction(
          type: TransactionType.payment,
          name: 'Amazon',
          amount: 30.0,
          date: DateTime.now(),
        ),
      ];

      final groupedTransactions = groupTransactionsByDate(transactions);

      expect(groupedTransactions.containsKey('TODAY'), true);
      expect(groupedTransactions['TODAY']!.length, 1);
    });
  });
}
