import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/features/home/views/widgets/transcation_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionListProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyApp', style: AppTextStyles.headline),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.currency_exchange,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Navigator.pushNamed(context, '/converter'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                color: AppColors.primaryColor,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '£',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: screenWidth * 0.06,
                              ),
                            ),
                            TextSpan(
                              text: balance.toStringAsFixed(2).split('.')[0],
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: screenWidth * 0.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '.${balance.toStringAsFixed(2).split('.')[1]}',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: screenWidth * 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.13),
                  ],
                ),
              ),
              Expanded(
                child: transactions.isNotEmpty
                    ? const TransactionList()
                    : const Center(
                        child: Text(
                          'No transactions available',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenHeight * 0.17,
            child: Card(
              elevation: 2,
              color: AppColors.whiteColor,
              shadowColor: AppColors.greyColor,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/pay'),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.payment,
                              color: AppColors.blackColor,
                              size: 28,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pay',
                              style: AppTextStyles.bodyTextBlack,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/topup'),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.receipt,
                              color: AppColors.blackColor,
                              size: 28,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Top Up',
                              style: AppTextStyles.bodyTextBlack,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
