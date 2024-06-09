import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/core/ultils/helpers/send_feedback.dart';

import '../../core/constant/colors.dart';
import 'reminder_bottomsheet.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text('Yours', style: context.textTheme.displayLarge),
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.middleBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => showReminderBottomSheet(context),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications,
                          size: 25, color: Colors.white),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Reminders',
                          style: context.textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Icon(
                          size: 20,
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.lightBlack),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: AppColors.lightBlack,
                  thickness: 0.5,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => sendFeedback(),
                  child: Row(
                    children: [
                      const Icon(Icons.mail, size: 25, color: Colors.white),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Feedback',
                          style: context.textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Icon(
                          size: 20,
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.lightBlack),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void showReminderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final padding = MediaQuery.of(context).padding.top;
        return Container(
          color: AppColors.black,
          padding: EdgeInsets.only(top: padding),
          child: const RemiderBottomSheet(),
        );
      },
      backgroundColor: AppColors.black,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
