//create function to show snackbar
import 'package:flutter/material.dart';
import 'package:motivation_me/core/constant/colors.dart';

void showSnackbar(BuildContext context,
    {Color backgroundColor = AppColors.lightBlack,
    Duration duration = const Duration(seconds: 3),
    required String content,
    required Color textColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
