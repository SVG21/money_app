import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/core/widgets/app_dailogs.dart';
import 'package:money_app/features/top_up/controllers/top_up_controller.dart';
import 'package:money_app/core/widgets/numeric_keyboard.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/core/utils.dart';

class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(topUpAmountProvider.notifier).state = '0.00';
    });
  }

  @override
  Widget build(BuildContext context) {
    final topUpAmount = ref.watch(topUpAmountProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final parts = topUpAmount.split('.');
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
          SizedBox(width: screenWidth * 0.02),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Top Up',
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
                    text: integerPart,
                    style: AppTextStyles.amountText
                        .copyWith(fontSize: screenWidth * 0.16),
                  ),
                  TextSpan(
                    text: '.$decimalPart',
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
                ref.read(topUpAmountProvider.notifier).state =
                    updateAmount(ref.read(topUpAmountProvider), value);
              },
              onBackspace: () => ref.read(topUpAmountProvider.notifier).state =
                  updateAmount(ref.read(topUpAmountProvider), '<'),
              onDot: () => ref.read(topUpAmountProvider.notifier).state =
                  updateAmount(ref.read(topUpAmountProvider), '.'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
              child: ElevatedButton(
                onPressed: () async {
                  final double enteredAmount =
                      double.tryParse(topUpAmount) ?? 0.0;
                  if (enteredAmount == 0.0) {
                    AppDialogs.showErrorDialog(
                      context,
                      'Invalid Amount',
                      'Amount cannot be 0 or 0.00.',
                    );
                    return;
                  }

                  ref
                      .read(topUpControllerProvider.notifier)
                      .topUp(enteredAmount);

                  // Navigate back
                  Navigator.pop(context);
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
                child: Text(
                  'Top Up',
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
