import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/currency_converter/controllers/currency_controller.dart';
import 'package:money_app/features/currency_converter/models/currency_model.dart';

class MockCurrencyRepository implements CurrencyRepository {
  @override
  Future<List<CurrencyModel>> fetchExchangeRates() async {
    return [
      CurrencyModel(code: 'USD', rate: 1.2),
      CurrencyModel(code: 'EUR', rate: 0.9),
    ];
  }
}

class MockCurrencyRepositoryWithError implements CurrencyRepository {
  @override
  Future<List<CurrencyModel>> fetchExchangeRates() async {
    throw Exception('Network error');
  }
}

void main() {
  group('Currency Converter Feature', () {
    test('Fetches exchange rates successfully', () async {
      final container = ProviderContainer(overrides: [
        currencyRepositoryProvider.overrideWithValue(MockCurrencyRepository()),
      ]);

      final rates = await container.read(currencyRatesProvider.future);
      expect(rates.length, 2);
      expect(rates[0].code, 'USD');
    });

    test('Handles error when fetching exchange rates fails', () async {
      final container = ProviderContainer(overrides: [
        currencyRepositoryProvider
            .overrideWithValue(MockCurrencyRepositoryWithError()),
      ]);

      expect(container.read(currencyRatesProvider.future), throwsException);
    });

    test('Selected currency updates correctly', () async {
      final container = ProviderContainer();
      expect(container.read(selectedCurrencyProvider), 'USD');

      container.read(selectedCurrencyProvider.notifier).state = 'EUR';
      expect(container.read(selectedCurrencyProvider), 'EUR');
    });

    test('Calculates exchange rate correctly for selected currency', () async {
      final container = ProviderContainer(overrides: [
        currencyRepositoryProvider.overrideWithValue(MockCurrencyRepository()),
      ]);

      await container.read(currencyRatesProvider.future);

      expect(container.read(selectedCurrencyRateProvider), 1.2);

      container.read(selectedCurrencyProvider.notifier).state = 'EUR';
      expect(container.read(selectedCurrencyRateProvider), 0.9);
    });
  });
}
