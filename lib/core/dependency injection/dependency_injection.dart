import 'package:get/get.dart';
import 'package:motivation_me/repositories/collections_repository.dart';
import 'package:motivation_me/repositories/save_repository.dart';
import '../../features/create_quote/create_quote_controller.dart';
import '../../features/home/home_controller.dart';
import '../../features/main_screen/main_controller.dart';
import '../../features/me/reminder_controller.dart';
import '../../features/my_quotes/my_quote_controller.dart';
import '../../features/paywall/subscription_controller.dart';
import '../../features/themes/themes_controller.dart';
import '../../repositories/categories_repository.dart';
import '../../repositories/default_quotes_repository.dart';
import '../../repositories/likes_repository.dart';
import '../../repositories/themes_repository.dart';
import '../../repositories/user_quotes_repository.dart';

Future<void> init() async {
  //repository
  Get.lazyPut(() => DefaultQuotesRepository());
  Get.lazyPut(() => LikesRepository());
  Get.lazyPut(() => UserQuotesRepository());
  Get.lazyPut(() => ThemesRepository());
  Get.lazyPut(() => CategoriesRepository(), fenix: true);
  Get.lazyPut(() => CollectionsRepository(), fenix: true);
  Get.lazyPut(() => SavesRepository(), fenix: true);

  //controller
  Get.lazyPut(
      () => HomeController(dfQuotesRepo: Get.find(), likesRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => CreateQuoteController(userQuoteRepo: Get.find()),
      fenix: true);
  Get.lazyPut(
      () =>
          MyQuotesController(userQuoteRepo: Get.find(), likesRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => MainController(), fenix: true);
  Get.lazyPut(() => ThemesController(themesRepo: Get.find()), fenix: true);
  // Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => ReminderController(), fenix: true);
  Get.lazyPut(() => SubscriptionController(), fenix: true);
}
