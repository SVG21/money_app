import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/pay/controllers/pay_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences mock

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Pay Feature', () {
    test('Initial balance is set correctly', () {
      final container = ProviderContainer();
      expect(container.read(balanceProvider), 150.25);
    });

    test('Makes a payment and reduces balance correctly', () {
      final container = ProviderContainer();
      final payNotifier = container.read(payControllerProvider.notifier);
      final initialBalance = container.read(balanceProvider);
      expect(initialBalance, 150.25);

      payNotifier.makePayment(30.0, 'John Doe');

      expect(container.read(balanceProvider), 120.25);
    });

    test('Does not allow payment if balance is insufficient', () {
      final container = ProviderContainer();
      final payNotifier = container.read(payControllerProvider.notifier);
      final initialBalance = container.read(balanceProvider);

      expect(initialBalance, 150.25);

      expect(
        () => payNotifier.makePayment(200.0, 'Insufficient User'),
        throwsA(predicate((e) =>
            e is Exception && e.toString().contains('Insufficient balance.'))),
      );

      expect(container.read(balanceProvider), 150.25);
    });

    test('Shows error if amount is 0 or less', () {
      final container = ProviderContainer();
      final payNotifier = container.read(payControllerProvider.notifier);

      expect(
        () => payNotifier.makePayment(0.0, 'Invalid User'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Amount must be greater than zero.'))),
      );
    });

    test('Shows error if name is empty', () {
      final container = ProviderContainer();
      final payNotifier = container.read(payControllerProvider.notifier);

      expect(
        () => payNotifier.makePayment(30.0, ''),
        throwsA(predicate((e) =>
            e is Exception && e.toString().contains('Name cannot be empty.'))),
      );
    });
  });
}
