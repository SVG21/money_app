import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/features/home/views/widgets/transcation_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsyncValue = ref.watch(balanceProvider.notifier).loadBalance();
    final transactionsAsyncValue =
        ref.watch(transactionListProvider.notifier).loadTransactions();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconHeight = screenWidth * 0.12;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyApp', style: AppTextStyles.headline),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/currencyConverterIcon.svg',
              height: iconHeight,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Navigator.pushNamed(context, '/converter'),
          ),
          SizedBox(
            width: screenWidth * 0.04,
          )
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
                      child: FutureBuilder(
                        future: balanceAsyncValue,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: AppColors.whiteColor,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style:
                                  const TextStyle(color: AppColors.whiteColor),
                            );
                          } else {
                            final balance = ref.watch(balanceProvider);
                            return RichText(
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
                                    text: balance
                                        .toStringAsFixed(2)
                                        .split('.')[0],
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
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.13),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: transactionsAsyncValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final transactions = ref.watch(transactionListProvider);
                      return transactions.isNotEmpty
                          ? const TransactionList()
                          : const Center(
                              child: Text(
                                'No transactions available',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                    }
                  },
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
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/payIcon.svg',
                              height: iconHeight,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pay',
                              style: AppTextStyles.bodyTextBlack,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/topup'),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/topUpIcon.svg',
                              height: iconHeight,
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
