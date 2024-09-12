import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'balance': 125.25});
  });

  group('Home Controller Tests', () {
    test('Initial balance is loaded correctly from SharedPreferences',
        () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('balance'),
          125.25); // Confirm mock value is set to 125.25

      final container = ProviderContainer();
      final balanceNotifier = container.read(balanceProvider.notifier);

      await balanceNotifier.loadBalance();
      final balance = container.read(balanceProvider);

      expect(balance, 125.25); // This should now match 125.25
    });

    test('Balance is updated and saved correctly', () async {
      final container = ProviderContainer();
      final balanceNotifier = container.read(balanceProvider.notifier);

      balanceNotifier.updateBalance(100.0);

      final updatedBalance = container.read(balanceProvider);
      expect(updatedBalance, 100.0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('balance'), 100.0);
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
        container.read(transactionListProvider).contains(transaction),
        true,
      );
    });
  });
}
