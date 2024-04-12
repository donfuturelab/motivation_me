import 'package:flutter/material.dart';

import '../core/constant/colors.dart';

class ButtonToClose extends StatelessWidget {
  const ButtonToClose({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: AppColors.middleBlack,
      radius: 15,
      child: Icon(
        Icons.close,
        color: AppColors.textColor,
      ),
    );
  }
}
