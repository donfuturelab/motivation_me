import 'package:purchases_flutter/purchases_flutter.dart';

import 'store_config.dart';

Future<void> configSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration;
  configuration = PurchasesConfiguration(
    StoreConfig.instance.apiKey,
  )
    ..appUserID = null
    ..observerMode = false;
  configuration.entitlementVerificationMode =
      EntitlementVerificationMode.informational;
  await Purchases.configure(configuration);

  await Purchases.enableAdServicesAttributionTokenCollection();
}
