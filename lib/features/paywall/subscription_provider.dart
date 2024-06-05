import 'package:flutter/services.dart';
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

  Future<void> updateSubscriptionStatus({required bool isSubscribed}) async {
    state = AsyncValue.data(isSubscribed);
  }

  Future<PurchaseStatus> purchaseSubscription() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      Package? package = offerings.getOffering(offeringIdentifier)?.annual;
      if (package != null) {
        CustomerInfo customerInfo = await Purchases.purchasePackage(package);
        EntitlementInfo? entitlement =
            customerInfo.entitlements.all[entitlementID];

        state = AsyncValue.data(entitlement?.isActive ?? false);
        return PurchaseStatus.success; // return true if subscription is active
      } else {
        state = const AsyncValue.data(false);
        return PurchaseStatus.fail;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      switch (errorCode) {
        case PurchasesErrorCode.purchaseCancelledError:
          state = const AsyncValue.data(false);
          return PurchaseStatus.cancelPurchase;
        default:
          state = const AsyncValue.data(false);
          return PurchaseStatus.error;
      }
    }

    // state = const AsyncLoading();
    // state = await AsyncValue.guard(() async {
    //   Offerings offerings = await Purchases.getOfferings();

    //   Package? package = offerings.getOffering(offeringIdentifier)?.annual;

    //   if (package != null) {
    //     CustomerInfo customerInfo = await Purchases.purchasePackage(package);
    //     EntitlementInfo? entitlement =
    //         customerInfo.entitlements.all[entitlementID];

    //     return entitlement?.isActive ??
    //         false; // return true if subscription is active

    //     // return true if subscription is active
    //   } else {
    //     return false;
    //   }

    // try {
    //   Offerings offerings = await Purchases.getOfferings();

    //   Package? package = offerings.getOffering(offeringIdentifier)?.annual;

    //   if (package != null) {
    //     CustomerInfo customerInfo = await Purchases.purchasePackage(package);
    //     EntitlementInfo? entitlement =
    //         customerInfo.entitlements.all[entitlementID];

    //     state = AsyncValue.data(entitlement?.isActive ??
    //         false); // return true if subscription is active

    //     return entitlement?.isActive ??
    //         false; // return true if subscription is active
    //   } else {

    //     return false;
    //   }
    // } on PurchasesError catch (e) {
    //   print(e);
    //   return false;
    // }
  }

  Future<RestoreStatus> restoreSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      if (entitlement?.isActive ?? false) {
        state = const AsyncValue.data(true);
        return RestoreStatus.success;
      } else {
        state = const AsyncValue.data(false);
        return RestoreStatus.fail;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      switch (errorCode) {
        case PurchasesErrorCode.missingReceiptFileError:
          state = const AsyncValue.data(false);
          return RestoreStatus.cancelRestore;
        default:
          state = const AsyncValue.data(false);
          return RestoreStatus.error;
      }
    }
  }
}

enum PurchaseStatus {
  success,
  fail,
  cancelPurchase,
  error,
}

enum RestoreStatus {
  success,
  fail,
  error,
  cancelRestore,
}




// try {
//    PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
// } on PlatformException catch (e) {
//     var errorCode = PurchasesErrorHelper.getErrorCode(e);
//     switch(errorCode) {
//     case PurchasesErrorCode.purchaseCancelledError:
//       print("User cancelled");
//       break;
//     case PurchasesErrorCode.purchaseNotAllowedError:
//       print("User not allowed to purchase");
//       break;
//     default:
//       // Do other stuff
//       break;
//   }
