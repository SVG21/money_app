import 'package:flutter/material.dart';
import 'package:money_app/core/app_colors.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';

class AppNumericKeyboard extends StatelessWidget {
  final Function(String) onKeyboardTap;
  final VoidCallback onBackspace;
  final VoidCallback onDot;

  const AppNumericKeyboard({
    super.key,
    required this.onKeyboardTap,
    required this.onBackspace,
    required this.onDot,
  });

  @override
  Widget build(BuildContext context) {
    return NumericKeyboard(
      onKeyboardTap: onKeyboardTap,
      textStyle: const TextStyle(color: AppColors.whiteColor),
      rightButtonFn: onBackspace,
      rightIcon: const Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
      leftButtonFn: onDot,
      leftIcon: const Icon(Icons.circle, color: AppColors.whiteColor, size: 10),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
