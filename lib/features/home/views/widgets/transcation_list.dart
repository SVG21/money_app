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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final sortedKeys = groupedTransactions.keys.toList()
      ..sort((a, b) {
        if (a == 'TODAY') return -1;
        if (b == 'TODAY') return 1;
        if (a == 'YESTERDAY') return -1;
        if (b == 'YESTERDAY') return 1;
        return b.compareTo(a); // Sort other dates in descending order.
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedKeys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.04),
                child: const Text('Recent Activity',
                    style: AppTextStyles.headLineTextBlack),
              ),
            ],
          );
        }

        final date = sortedKeys[index - 1];
        final transactionsForDate = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.04),
              child: Text(date, style: AppTextStyles.smallText),
            ),
            ...transactionsForDate.map((transaction) {
              return Container(
                color: AppColors.whiteColor,
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      // Background color
                      borderRadius: BorderRadius.circular(screenWidth * 0.015),
                      // Adjust rounded corners
                      border: Border.all(
                        color: AppColors.primaryColor, // Border color
                        width: screenWidth * 0.003, // Adjust border width
                      ),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.015),
                    // Adjust padding
                    child: Icon(
                      transaction.type == TransactionType.payment
                          ? Icons.shopping_cart
                          : Icons.add,
                      color: AppColors.whiteColor, // Icon color
                      size: screenWidth * 0.05, // Adjust icon size
                    ),
                  ),
                  title: Text(
                    transaction.name,
                    style: AppTextStyles.bodyTextBlack.copyWith(
                        fontSize: screenWidth * 0.04), // Adjust text size
                  ),
                  trailing: Text(
                    '${transaction.type == TransactionType.topup ? '+' : ''}£'
                    '${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == TransactionType.topup
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      fontSize: screenWidth * 0.045, // Adjust font size
                    ),
                  ),
                ),
              );
            }), // Convert map to list for rendering
          ],
        );
      },
    );
  }
}
