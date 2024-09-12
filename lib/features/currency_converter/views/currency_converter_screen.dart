import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_app/core/widgets/app_dailogs.dart';
import 'package:money_app/features/currency_converter/controllers/currency_controller.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:money_app/core/app_text_styles.dart';
import 'package:money_app/features/currency_converter/models/currency_model.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  CurrencyConverterScreenState createState() => CurrencyConverterScreenState();
}

class CurrencyConverterScreenState
    extends ConsumerState<CurrencyConverterScreen> {
  late TextEditingController amountController;
  late FocusNode amountFocusNode;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    amountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exchangeRates = ref.watch(currencyRatesProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final selectedCurrencyRate = ref.watch(selectedCurrencyRateProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.greyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Currency Converter',
          style: AppTextStyles.headline.copyWith(fontSize: screenWidth * 0.05),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: AppColors.whiteColor,
              radius: screenWidth * 0.035,
              child: Icon(
                Icons.close,
                color: AppColors.primaryColor,
                size: screenWidth * 0.045,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Convert Currency',
              style: AppTextStyles.bodyTextBlack
                  .copyWith(fontSize: screenWidth * 0.06),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),

            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: exchangeRates.when(
                data: (rates) {
                  if (rates.isEmpty) {
                    return const Text('No rates available.');
                  }
                  return DropdownButton<String>(
                    value: selectedCurrency,
                    onChanged: (newValue) {
                      ref.read(selectedCurrencyProvider.notifier).state =
                          newValue!;
                    },
                    items: rates.map<DropdownMenuItem<String>>(
                      (CurrencyModel currency) {
                        return DropdownMenuItem<String>(
                          value: currency.code,
                          child: Text(
                            currency.code,
                            style: AppTextStyles.bodyTextBlack
                                .copyWith(fontSize: screenWidth * 0.05),
                          ),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    underline: Container(),
                    dropdownColor: AppColors.whiteColor,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  return Text('Error loading rates: ${error.toString()}');
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: amountController,
                focusNode: amountFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount in GBP',
                  labelStyle: AppTextStyles.headLineTextBlack
                      .copyWith(fontSize: screenWidth * 0.045),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.bodyTextBlack
                    .copyWith(fontSize: screenWidth * 0.05),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            if (selectedCurrencyRate != null)
              Column(
                children: [
                  Text(
                    'Exchange Rate: 1 GBP = '
                    '${selectedCurrencyRate.toStringAsFixed(2)} '
                    '$selectedCurrency',
                    style: AppTextStyles.bodyTextBlack
                        .copyWith(fontSize: screenWidth * 0.045),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      final amount =
                          double.tryParse(amountController.text) ?? 0.0;
                      if (amount <= 0) {
                        AppDialogs.showErrorDialog(
                          context,
                          'Invalid Amount',
                          'Please enter a valid amount greater than 0.',
                        );
                        return;
                      }
                      final convertedAmount = amount * selectedCurrencyRate;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Converted Amount'),
                            content: Text(
                              '$amount GBP = '
                              '${convertedAmount.toStringAsFixed(2)} '
                              '$selectedCurrency',
                              style: AppTextStyles.headLineTextBlack
                                  .copyWith(fontSize: screenWidth * 0.045),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Clear the text field after showing the result
                                  amountController.clear();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.whiteColor,
                      backgroundColor: AppColors.secondaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      'Convert',
                      style: AppTextStyles.bodyTextWhite
                          .copyWith(fontSize: screenWidth * 0.05),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
