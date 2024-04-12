import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../me/reminder_controller.dart';

class ReminderInitBottomsheet extends GetView<ReminderController> {
  const ReminderInitBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        centerTitle: true,
        title: Text('Reminders', style: context.textTheme.displayLarge),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: AppColors.textColor,
            )),
      ),
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              color: AppColors.black,
              child: Column(
                children: [
                  Text(
                    'Unlock Daily Inspiration! 🌈 Enable notifications to receive daily quotes that motivate and inspire. Set your preferred reminder time and never miss your daily boost of positivity. Turn off at any time',
                    textAlign: TextAlign.center,
                    style:
                        context.textTheme.displayMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      controller.initReminder();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Accept Notification',
                      style: context.textTheme.labelMedium,
                    ),
                  )
                ],
              ))),
    );
  }
}
