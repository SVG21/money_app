import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/core/widgets/app_dailogs.dart';
import 'package:money_app/features/pay/controllers/pay_controller.dart';
import 'package:money_app/features/pay/views/pay_recipient_screen.dart';
import 'package:money_app/core/widgets/numeric_keyboard.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/core/utils.dart';

class PayAmountScreen extends ConsumerWidget {
  const PayAmountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(payAmountProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final parts = amount.split('.');
    final integerPart = parts.isNotEmpty ? parts[0] : '0';
    final decimalPart = parts.length > 1 ? parts[1] : '00';

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
          InkWell(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: AppColors.whiteColor,
              radius: screenWidth * 0.035,
              child: Icon(Icons.close,
                  color: AppColors.primaryColor, size: screenWidth * 0.045),
            ),
          ),
          SizedBox(width: screenWidth * 0.02)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              'How much?',
              style: AppTextStyles.bodyTextWhite
                  .copyWith(fontSize: screenWidth * 0.06),
            ),
            SizedBox(height: screenHeight * 0.04),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '£',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: screenWidth * 0.08),
                  ),
                  TextSpan(
                    text: integerPart, // Use the integer part
                    style: AppTextStyles.amountText
                        .copyWith(fontSize: screenWidth * 0.16),
                  ),
                  TextSpan(
                    text: '.$decimalPart', // Use the decimal part
                    style: AppTextStyles.amountText.copyWith(
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            AppNumericKeyboard(
              onKeyboardTap: (value) {
                ref.read(payAmountProvider.notifier).state =
                    updateAmount(ref.read(payAmountProvider), value);
              },
              onBackspace: () => ref.read(payAmountProvider.notifier).state =
                  updateAmount(ref.read(payAmountProvider), '<'),
              onDot: () => ref.read(payAmountProvider.notifier).state =
                  updateAmount(ref.read(payAmountProvider), '.'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
              child: ElevatedButton(
                onPressed: () {
                  final double enteredAmount = double.tryParse(amount) ?? 0.0;
                  if (enteredAmount == 0.0) {
                    AppDialogs.showErrorDialog(
                      context,
                      'Invalid Amount',
                      'Amount cannot be 0 or 0.00.',
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PayRecipientScreen(amount: enteredAmount),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.whiteColor,
                  backgroundColor: AppColors.secondaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                child: Text('Next',
                    style: TextStyle(fontSize: screenWidth * 0.05)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
