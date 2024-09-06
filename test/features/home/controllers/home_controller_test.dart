import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({}); // Set mock initial values
  });

  group('Home Controller Tests', () {
    test('Initial balance is set correctly', () {
      final container = ProviderContainer();
      expect(container.read(balanceProvider), 150.25);
    });

    test('Add transaction increases the list size', () async {
      final container = ProviderContainer();
      final transactionNotifier =
          container.read(transactionListProvider.notifier);

      await transactionNotifier.loadTransactions();

      final initialTransactionCount =
          container.read(transactionListProvider).length;

      transactionNotifier.addTransaction(
        Transaction(
          type: TransactionType.payment,
          name: 'Amazon',
          amount: 50.0,
          date: DateTime.now(),
        ),
      );

      final updatedTransactionCount =
          container.read(transactionListProvider).length;

      expect(updatedTransactionCount, initialTransactionCount + 1);
    });

    test('Added transaction appears in the list', () async {
      final container = ProviderContainer();
      final transactionNotifier =
          container.read(transactionListProvider.notifier);

      await transactionNotifier.loadTransactions();

      final transaction = Transaction(
        type: TransactionType.payment,
        name: 'Amazon',
        amount: 50.0,
        date: DateTime.now(),
      );

      transactionNotifier.addTransaction(transaction);

      expect(
          container.read(transactionListProvider).contains(transaction), true);
    });
  });
}
