import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';

final payAmountProvider = StateProvider<String>((ref) => '0.00');

final payControllerProvider =
    StateNotifierProvider<PayController, List<Transaction>>((ref) {
  return PayController(ref);
});

class PayController extends StateNotifier<List<Transaction>> {
  final Ref ref;

  PayController(this.ref) : super([]);

  void makePayment(double amount, String name) {
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero.');
    }

    if (name.isEmpty) {
      throw Exception('Name cannot be empty.');
    }

    final currentBalance = ref.read(balanceProvider);
    if (currentBalance >= amount) {
      ref.read(balanceProvider.notifier).updateBalance(currentBalance - amount);
      ref.read(transactionListProvider.notifier).addTransaction(
            Transaction(
              type: TransactionType.payment,
              name: name,
              amount: amount,
              date: DateTime.now(),
            ),
          );
    } else {
      throw Exception('Insufficient balance.');
    }
  }
}
