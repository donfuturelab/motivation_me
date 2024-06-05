import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/common_widgets/buttons.dart';
import 'package:motivation_me/common_widgets/snackbar.dart';
import 'package:motivation_me/core/constant/term_privacy.dart';
import 'package:motivation_me/features/paywall/subscription_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constant/colors.dart';

class PaywallScreen extends HookConsumerWidget {
  const PaywallScreen({super.key});

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPurchasing = useState(false);
    final isRestoring = useState(false);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        // toolbarHeight: 50,
        backgroundColor: AppColors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
              'Try Motivation Me Premium',
              style: context.textTheme.displayLarge?.copyWith(
                  fontSize: 30, fontWeight: FontWeight.bold, height: 1.5),
            ),
            const SizedBox(height: 20),

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
            //create text as rich text for "7 days free, then \$9.9/year"
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '7 days free,',
                    style: context.textTheme.displayMedium,
                  ),
                  TextSpan(
                      text: ' then just ',
                      style: context.textTheme.displayMedium?.copyWith(
                        color: Colors.grey,
                      )),
                  TextSpan(
                    text: '\$9.9/year',
                    style: context.textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                if (isPurchasing.value) {
                  return;
                }
                isPurchasing.value = true;
                final purchaseStatus = await ref
                    .read(subscriptionProvider.notifier)
                    .purchaseSubscription();
                isPurchasing.value = false;
                switch (purchaseStatus) {
                  case PurchaseStatus.error:
                    if (context.mounted) {
                      showSnackbar(context,
                          content: 'Something wrong happens',
                          textColor: AppColors.textColor);
                    }
                    break;
                  case PurchaseStatus.success:
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    break;
                  case PurchaseStatus.cancelPurchase:
                    break;
                  case PurchaseStatus.fail:
                    if (context.mounted) {
                      showSnackbar(context,
                          content: 'Opps, Purchase failed',
                          textColor: AppColors.textColor);
                    }
                    break;
                }
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                // padding: const EdgeInsets.symmetric(vertical: 20),
                child: isPurchasing.value
                    ? const CircularProgressIndicator(
                        color: AppColors.black,
                      )
                    : Text(
                        'Continue',
                        style: context.textTheme.displayLarge
                            ?.copyWith(color: AppColors.black),
                      ),
              ),
            ),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () async {
                        if (isRestoring.value) {
                          return;
                        }
                        isRestoring.value = true;
                        final restoreStatus = await ref
                            .read(subscriptionProvider.notifier)
                            .restoreSubscription();
                        isRestoring.value = false;
                        switch (restoreStatus) {
                          case RestoreStatus.error:
                            if (context.mounted) {
                              showSnackbar(context,
                                  content: 'Something wrong happens',
                                  textColor: AppColors.textColor);
                            }
                            break;
                          case RestoreStatus.success:
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            break;
                          case RestoreStatus.cancelRestore:
                            break;
                          case RestoreStatus.fail:
                            if (context.mounted) {
                              showSnackbar(context,
                                  content:
                                      'Opps, Cannot restore your subscription',
                                  textColor: AppColors.textColor);
                            }
                            break;
                        }
                      },
                      child: isRestoring.value
                          ? const CircularProgressIndicator(
                              color: AppColors.textColor,
                            )
                          : Text(
                              'Restore',
                              style: context.textTheme.displaySmall,
                            )),
                  TextButton(
                      onPressed: () async => await _launchURL(termUrl),
                      child: Text('Terms of Service',
                          style: context.textTheme.displaySmall)),
                  TextButton(
                      onPressed: () async => await _launchURL(privacyUrl),
                      child: Text(
                        'Privacy Policy',
                        style: context.textTheme.displaySmall,
                      )),
                ],
              ),
            ),
          ],
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
