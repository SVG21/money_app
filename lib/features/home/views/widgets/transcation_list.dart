import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/features/home/models/home_model.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedTransactions = ref.watch(transactionGroupedByDateProvider);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final transactionsForDate = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 72),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text('Recent Activity',
                  style: AppTextStyles.headLineTextBlack),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(date, style: AppTextStyles.smallText),
            ),
            ...transactionsForDate.map((transaction) {
              return Container(
                color: AppColors.whiteColor,
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor, // Background color
                      borderRadius: BorderRadius.circular(
                          6), // Slightly smaller rounded corners
                      border: Border.all(
                        color: AppColors.primaryColor, // Border color
                        width: 1.2, // Slightly thinner border
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        6), // Reduced padding for a smaller size
                    child: Icon(
                      transaction.type == TransactionType.payment
                          ? Icons.shopping_cart
                          : Icons.add,
                      color: AppColors.whiteColor, // Icon color
                      size: 18, // Slightly smaller icon size
                    ),
                  ),
                  title: Text(
                    transaction.name,
                    style: AppTextStyles.bodyTextBlack,
                  ),
                  trailing: Text(
                    '${transaction.type == TransactionType.topup ? '+' : ''}£'
                    '${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == TransactionType.topup
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
