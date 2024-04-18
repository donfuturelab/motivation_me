import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/common_widgets/buttons.dart';

import '../../core/constant/colors.dart';
import 'subscription_controller.dart';

class PaywallScreen extends StatelessWidget {
  final _subscriptionController = Get.find<SubscriptionController>();

  PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      color: AppColors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: AppColors.black,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const ButtonToClose(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Try Motivation Happy Premium',
                  style: context.textTheme.displayLarge?.copyWith(
                      fontSize: 30, fontWeight: FontWeight.bold, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Image.asset(
                //   width: 100,
                //   height: 100,
                //   fit: BoxFit.cover,
                //   'assets/images/icons/app_icon.png',
                // ),
                const Icon(
                  Icons.workspace_premium_sharp,
                  size: 80,
                  color: AppColors.textColor,
                ),
                const SizedBox(height: 40),
                _buildFeature(context, 'Unlimited access to all quotes'),
                const SizedBox(height: 10),
                _buildFeature(context, 'Unlock all themes'),
                const SizedBox(height: 10),
                _buildFeature(context, 'Remove all ads'),
                const SizedBox(height: 10),
                _buildFeature(context, 'Unlock all categories'),
                const SizedBox(height: 10),
                _buildFeature(context, '7 days free, then \$9.9/year'),
                const SizedBox(height: 10),
                _buildFeature(context, 'Only \$0.83/month, billed annually'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final isSuccess =
                        await _subscriptionController.purchaseSubscription();
                    if (isSuccess) {
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Something went wrong');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Continue',
                      style: context.textTheme.displayLarge
                          ?.copyWith(color: AppColors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextButton(
                      onPressed: () =>
                          _subscriptionController.restoreSubscription(),
                      child: Text(
                        'Restore',
                        style: context.textTheme.displaySmall,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildFeature(BuildContext context, String featureName) {
    return Row(
      children: [
        const CircleAvatar(
            radius: 10,
            child: Icon(
              Icons.check,
              color: AppColors.black,
              size: 13,
              weight: 30,
            )),
        const SizedBox(width: 10),
        Text(
          featureName,
          style: context.textTheme.displayMedium,
        ),
      ],
    );
  }
}
