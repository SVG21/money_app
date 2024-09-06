import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:money_app/features/currency_converter/models/currency_model.dart';

class CurrencyRepository {
  Future<List<CurrencyModel>> fetchExchangeRates() async {
    final response = await http.get(
      Uri.parse('https://open.er-api.com/v6/latest/GBP'),
    );
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data.containsKey('rates') && data['rates'] is Map) {
          final rates = (data['rates'] as Map<String, dynamic>)
              .entries
              .map((entry) => CurrencyModel(
                    code: entry.key,
                    rate: entry.value is int
                        ? entry.value.toDouble()
                        : entry.value,
                  ))
              .toList();
          return rates;
        } else {
          throw Exception(
              'Unexpected data format: "rates" key missing or invalid');
        }
      } catch (e) {
        throw Exception('Failed to parse exchange rates: $e');
      }
    } else {
      throw Exception('Failed to load currency rates: ${response.statusCode}');
    }
  }
}

final currencyRepositoryProvider = Provider((ref) => CurrencyRepository());

final currencyRatesProvider = FutureProvider<List<CurrencyModel>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.fetchExchangeRates();
});

final selectedCurrencyProvider = StateProvider<String>((ref) => 'USD');

final selectedCurrencyRateProvider = Provider<double?>((ref) {
  final rates = ref.watch(currencyRatesProvider).maybeWhen(
        data: (rates) => rates,
        orElse: () => null,
      );
  final selectedCurrency = ref.watch(selectedCurrencyProvider);

  if (rates != null) {
    final currency = rates.firstWhere(
      (currency) => currency.code == selectedCurrency,
      orElse: () => CurrencyModel(code: selectedCurrency, rate: 0),
    );
    return currency.rate;
  }
  return null;
});
