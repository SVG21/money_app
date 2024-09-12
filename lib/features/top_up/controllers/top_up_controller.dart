import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/home/models/home_model.dart';

final topUpAmountProvider = StateProvider<String>((ref) => '0.00');

final topUpControllerProvider =
    StateNotifierProvider<TopUpController, List<Transaction>>((ref) {
  return TopUpController(ref);
});

class TopUpController extends StateNotifier<List<Transaction>> {
  final Ref ref;

  TopUpController(this.ref) : super([]);

  void topUp(double amount) {
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    final currentBalance = ref.read(balanceProvider);
    ref.read(balanceProvider.notifier).updateBalance(currentBalance + amount);
    ref.read(transactionListProvider.notifier).addTransaction(
          Transaction(
            type: TransactionType.topup,
            name: 'Top Up',
            amount: amount,
            date: DateTime.now(),
          ),
        );
  }
}
