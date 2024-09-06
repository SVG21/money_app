import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:money_app/core/utils.dart';
import 'package:money_app/features/home/models/home_model.dart';

final balanceProvider = StateProvider<double>((ref) => 150.25);

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>(
  (ref) => TransactionListNotifier(),
);

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  TransactionListNotifier() : super([]) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString('transactions');

    if (transactionsString != null) {
      final List<dynamic> decodedJson = jsonDecode(transactionsString);
      final List<Transaction> loadedTransactions =
          decodedJson.map((json) => Transaction.fromJson(json)).toList();

      state = loadedTransactions;
    }
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> transactionsJson =
        state.map((transaction) => transaction.toJson()).toList();
    prefs.setString('transactions', jsonEncode(transactionsJson));
  }

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
    saveTransactions(); // Save the updated list to shared preferences
  }
}

final transactionGroupedByDateProvider =
    Provider<Map<String, List<Transaction>>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  return groupTransactionsByDate(transactions);
});

Map<String, List<Transaction>> groupTransactionsByDate(
    List<Transaction> transactions) {
  final Map<String, List<Transaction>> grouped = {};

  for (final transaction in transactions) {
    final date = formatDate(transaction.date); // Use the utility function
    if (grouped.containsKey(date)) {
      grouped[date]!.add(transaction);
    } else {
      grouped[date] = [transaction];
    }
  }

  return grouped;
}
