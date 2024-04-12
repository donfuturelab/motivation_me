import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/constant/revenue_cat.dart';

class SubscriptionController extends GetxController {
  final _isSubscribed = false.obs;
  bool get isSubscribed => _isSubscribed.value;

  @override
  void onInit() {
    super.onInit();
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);
    _checkSubscription();
  }

  @override
  void onClose() {
    super.onClose();
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdate);
  }

  void _onCustomerInfoUpdate(CustomerInfo purchaserInfo) async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
    _isSubscribed.value = entitlement?.isActive ?? false;
  }

  Future<void> _checkSubscription() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
    _isSubscribed.value = entitlement?.isActive ?? false;
  }

  Future<bool> purchaseSubscription() async {
    try {
      Offerings offerings = await Purchases.getOfferings();

      Package? package = offerings.getOffering(offeringIdentifier)?.annual;

      if (package != null) {
        CustomerInfo customerInfo = await Purchases.purchasePackage(package);
        EntitlementInfo? entitlement =
            customerInfo.entitlements.all[entitlementID];

        return _isSubscribed.value = entitlement?.isActive ??
            false; // return true if subscription is active
      } else {
        return false;
      }
    } on PurchasesError catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> restoreSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      _isSubscribed.value = entitlement?.isActive ?? false;
    } on PurchasesError catch (e) {
      print(e);
    }
  }
}
