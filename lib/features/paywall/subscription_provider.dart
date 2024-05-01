import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constant/revenue_cat.dart';

part 'subscription_provider.g.dart';

@riverpod
class Subscription extends _$Subscription {
  @override
  FutureOr<bool> build() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
    return entitlement?.isActive ?? false;
  }

  Future<bool> purchaseSubscription() async {
    state = const AsyncLoading();
    try {
      Offerings offerings = await Purchases.getOfferings();

      Package? package = offerings.getOffering(offeringIdentifier)?.annual;

      if (package != null) {
        CustomerInfo customerInfo = await Purchases.purchasePackage(package);
        EntitlementInfo? entitlement =
            customerInfo.entitlements.all[entitlementID];

        state = AsyncValue.data(entitlement?.isActive ??
            false); // return true if subscription is active

        return entitlement?.isActive ??
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
    state = const AsyncLoading();
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      state = AsyncValue.data(entitlement?.isActive ?? false);
    } on PurchasesError catch (e) {
      print(e);
    }
  }
}
