import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/top_up/controllers/top_up_controller.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('TopUp Controller Tests', () {
    test('Initial balance is set correctly', () {
      final container = ProviderContainer();
      expect(container.read(balanceProvider), 150.25);
    });

    test('Top up adds to balance correctly', () {
      final container = ProviderContainer();
      final topUpNotifier = container.read(topUpControllerProvider.notifier);
      final initialBalance = container.read(balanceProvider);

      topUpNotifier.topUp(50.0);

      expect(container.read(balanceProvider), initialBalance + 50.0);
    });

    test('Top up transaction is recorded correctly', () {
      final container = ProviderContainer();
      final topUpNotifier = container.read(topUpControllerProvider.notifier);

      final initialTransactionCount =
          container.read(transactionListProvider).length;

      topUpNotifier.topUp(100.0);

      final updatedTransactionCount =
          container.read(transactionListProvider).length;

      expect(updatedTransactionCount, initialTransactionCount + 1);

      final lastTransaction = container.read(transactionListProvider).last;

      expect(lastTransaction.type, TransactionType.topup);
      expect(lastTransaction.amount, 100.0);
      expect(lastTransaction.name, 'Top Up');
    });

    test('Top up with zero or negative amount throws exception', () {
      final container = ProviderContainer();
      final topUpNotifier = container.read(topUpControllerProvider.notifier);

      expect(
        () => topUpNotifier.topUp(0.0),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Amount must be greater than 0'))),
      );
      expect(
        () => topUpNotifier.topUp(-10.0),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Amount must be greater than 0'))),
      );
    });
  });
}
