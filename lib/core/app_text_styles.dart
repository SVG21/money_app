import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodyTextWhite = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    wordSpacing: 2,
  );
  static const TextStyle headLineTextBlack = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyTextBlack = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle amountText = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle smallText = TextStyle(
    color: AppColors.greyColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}
