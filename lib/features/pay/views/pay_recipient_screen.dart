import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/core/widgets/app_dailogs.dart';
import 'package:money_app/features/home/controllers/home_controller.dart';
import 'package:money_app/features/pay/controllers/pay_controller.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';

class PayRecipientScreen extends ConsumerWidget {
  final double amount;
  final TextEditingController recipientController = TextEditingController();

  PayRecipientScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBalance = ref.watch(balanceProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MoneyApp',
          style: AppTextStyles.headline.copyWith(fontSize: screenWidth * 0.05),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.whiteColor,
              size: screenWidth * 0.06,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              'To who?',
              style: AppTextStyles.headline.copyWith(
                fontSize: screenWidth * 0.06,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: TextField(
                controller: recipientController,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: AppColors.whiteColor,
                ),
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: screenWidth * 0.05,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.whiteColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.whiteColor),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  final name = recipientController.text.trim();
                  if (name.isEmpty) {
                    AppDialogs.showErrorDialog(
                      context,
                      'Invalid Input',
                      'Name cannot be empty.',
                    );
                    return;
                  }
                  if (amount > currentBalance) {
                    AppDialogs.showErrorDialog(
                      context,
                      'Insufficient Balance',
                      'Amount is insufficient, please top up.',
                    );
                  } else {
                    ref.read(payControllerProvider.notifier).makePayment(
                          amount,
                          name,
                        );
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  backgroundColor: AppColors.secondaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  textStyle: TextStyle(fontSize: screenWidth * 0.05),
                ),
                child: const Text('Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
