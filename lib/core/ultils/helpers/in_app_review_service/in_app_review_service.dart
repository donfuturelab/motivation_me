// ignore_for_file: avoid_print

import 'package:in_app_review/in_app_review.dart';
import 'package:motivation_me/core/constant/request_review_time.dart';

import '../../../local_storage/configuration_storage.dart';

class InAppReviewService {
  final InAppReview _inAppReview = InAppReview.instance;
  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  Future<void> openStoreListing() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.openStoreListing(
        appStoreId: 'com.onepercent.motivationhappy',
      );
    }
  }

  bool shouldRequestReview() {
    final openAppCount = ConfigurationStorage.getOpenAppCount();
    return requestReviewTime.contains(openAppCount);
  }
}
