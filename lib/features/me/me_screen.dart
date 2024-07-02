import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/core/local_storage/configuration_storage.dart';
import 'package:motivation_me/core/ultils/helpers/send_feedback.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/languages.dart';
import '../../core/ultils/helpers/in_app_review_service/in_app_review_service.dart';
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
                GestureDetector(
                  onTap: () async {
                    final language = await showLanguageBottomSheet(context);
                    if (language != null) {
                      ConfigurationStorage.saveLanguageCode(language['code']!);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 25, color: Colors.white),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Translate Language',
                          style: context.textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(width: 15),
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
                const SizedBox(height: 10),
                const Divider(
                  color: AppColors.lightBlack,
                  thickness: 0.5,
                ),
                GestureDetector(
                  onTap: () async {
                    await InAppReviewService().openStoreListing();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 25, color: Colors.white),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Rate app on store',
                          style: context.textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(width: 15),
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

  Future<Map<String, String>?> showLanguageBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                color: AppColors.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Select Language',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          controller: controller,
                          itemCount: languages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: const BoxDecoration(
                                //create only bottom border
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.middleBlack,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  languages[index]['name']!,
                                  style: context.textTheme.displayMedium,
                                ),
                                onTap: () {
                                  // Handle language selection
                                  Navigator.pop(context, languages[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
