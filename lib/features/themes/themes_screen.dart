import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/features/paywall/paywall_screen.dart';
import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/background_images.dart';
import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import '../../models/enums/add_theme_status.dart';
import '../../models/enums/theme.dart';
import '../../models/theme/quote_theme.dart';
import '../paywall/subscription_controller.dart';
import 'themes_controller.dart';

class ThemesScreen extends StatelessWidget {
  ThemesScreen({super.key});

  final _controller = Get.find<ThemesController>();
  final _subscriptionController = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          'Themes',
          style: context.textTheme.displayLarge,
        ),
        backgroundColor: AppColors.black,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => _controller.isLoading
            ? const CircleProgressBar()
            : SafeArea(
                child: Scrollbar(
                  thickness: 6,
                  radius: const Radius.circular(3),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                'Your themes',
                                style: context.textTheme.displayMedium,
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () =>
                                      _controller.toggleEditTheme(),
                                  child: Obx(() => Text(
                                        _controller.isEditingUserTheme
                                            ? 'Done'
                                            : 'Edit',
                                        style: context.textTheme.labelMedium,
                                      )))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        //create list of background but can scroll horizontal and the first item have left margin 16
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _controller.selectedThemes.length + 1,
                            itemBuilder: (context, index) {
                              QuoteTheme? theme =
                                  index == _controller.selectedThemes.length
                                      ? null
                                      : _controller.selectedThemes[index];

                              return theme == null
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 16),
                                      width: 100,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.black,
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: const Icon(
                                        Icons.add,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Obx(
                                      () => Container(
                                        margin: index == 0
                                            ? const EdgeInsets.only(left: 16)
                                            : const EdgeInsets.only(left: 20),
                                        width: 100,
                                        height: 150,
                                        alignment: Alignment.topRight,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    '$rootBackgroundUrl${theme.imageCode}.jpg'),
                                                fit: BoxFit.cover)),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(
                                                'Abcd',
                                                style: TextStyle(
                                                    fontSize: (_controller
                                                            .selectedThemes[
                                                                index]
                                                            .fontSize!)
                                                        .toDouble(),
                                                    fontWeight: FontWeight.bold,
                                                    // fontFamily: _controller
                                                    //     .selectedThemes[index].fontFamily,
                                                    fontFamily:
                                                        theme.fontFamily,
                                                    color: hexStringToColor(
                                                        theme.fontColor)),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Obx(
                                                () => _controller
                                                        .isEditingUserTheme
                                                    ? IconButton(
                                                        onPressed: () =>
                                                            _controller
                                                                .removeTheme(
                                                                    theme),
                                                        icon:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              AppColors.main,
                                                          radius: 12,
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      )
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                right: 10),
                                                        child: Icon(
                                                            Icons.check_circle,
                                                            color: Colors.white,
                                                            size: 25),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildFreeThemes(context),
                        const SizedBox(height: 20),
                        _buildThemesByCategory(
                            context, _controller.themeCategorySections[0]),
                        const SizedBox(height: 20),
                        _buildThemesByCategory(
                            context, _controller.themeCategorySections[1]),
                        const SizedBox(height: 20),
                        _buildThemesByCategory(
                            context, _controller.themeCategorySections[2]),
                        const SizedBox(height: 20),
                        _buildThemesByCategory(
                            context, _controller.themeCategorySections[3]),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildFreeThemes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Free today',
            style: context.textTheme.displayMedium,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _controller.freeThemes.length,
            itemBuilder: (context, index) {
              final theme = _controller.freeThemes[index];
              return Container(
                margin: index == 0
                    ? const EdgeInsets.only(left: 16)
                    : index ==
                            _controller.freeThemes.length -
                                1 //check if it is the last item
                        ? const EdgeInsets.only(left: 20, right: 16)
                        : const EdgeInsets.only(left: 20),
                width: 100,
                height: 150,
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(
                            '$rootBackgroundUrl${theme.imageCode}.jpg'),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Abcd',
                        style: TextStyle(
                            fontSize: (theme.fontSize!).toDouble(),
                            fontWeight: FontWeight.bold,
                            // fontFamily: _controller
                            //     .selectedThemes[index].fontFamily,
                            fontFamily: theme.fontFamily,
                            color: hexStringToColor(theme.fontColor)),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Obx(
                          () => theme.isSelected.value
                              ? const Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, right: 10),
                                  child: Icon(Icons.check_circle,
                                      color: Colors.white, size: 25),
                                )
                              : IconButton(
                                  onPressed: () =>
                                      _addTheme(context.height, theme),
                                  icon: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        )),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildThemesByCategory(
      BuildContext context, ThemeCategory themeCategory) {
    String themKey = themeCategoryToString(themeCategory);
    List<QuoteTheme> themes = _controller.themeByCategories[themKey]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            themeCategoryToLabel(themeCategory),
            style: context.textTheme.displayMedium,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final theme = themes[index];
              return Container(
                margin: index == 0
                    ? const EdgeInsets.only(left: 16)
                    : index == themes.length - 1
                        ? const EdgeInsets.only(
                            left: 20, right: 16) //check if it is the last item
                        : const EdgeInsets.only(left: 20),
                width: 100,
                height: 150,
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(
                            '$rootBackgroundUrl${theme.imageCode}.jpg'),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Abcd',
                        style: TextStyle(
                            fontSize: (theme.fontSize!).toDouble(),
                            fontWeight: FontWeight.bold,
                            // fontFamily: _controller
                            //     .selectedThemes[index].fontFamily,
                            fontFamily: theme.fontFamily,
                            color: hexStringToColor(theme.fontColor)),
                      ),
                    ),
                    Obx(() => !_subscriptionController.isSubscribed &&
                            theme.themeType == ThemeType.premium
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 10),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white.withOpacity(0.6),
                                size: 20,
                              ),
                            ),
                          )
                        : const SizedBox()),
                    Align(
                        alignment: Alignment.topRight,
                        child: Obx(
                          () => theme.isSelected.value
                              ? const Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, right: 10),
                                  child: Icon(Icons.check_circle,
                                      color: Colors.white, size: 25),
                                )
                              : IconButton(
                                  onPressed: () =>
                                      _addTheme(context.height, theme),
                                  icon: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //handle save theme action
  void _addTheme(double heightScreen, QuoteTheme theme) async {
    final addThemeResult = await _controller.addTheme(theme);
    //use switch case to handle the result
    switch (addThemeResult) {
      case AddThemeStatus.exist:
        Get.snackbar('Exist', 'Theme is already added',
            duration: 5.seconds,
            colorText: Colors.white,
            backgroundColor: AppColors.middleBlack,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(right: 50, left: 50, bottom: 100));
        break;
      case AddThemeStatus.overLimitForFree:
        _buildPaywallBottomSheet(heightScreen);
        break;
      case AddThemeStatus.notFree:
        // Get.snackbar(
        //     'Upgrade to premium', 'Upgrdate to premium to add this theme',
        //     duration: 5.seconds,
        //     colorText: Colors.white,
        //     backgroundColor: AppColors.middleBlack,
        //     snackPosition: SnackPosition.BOTTOM,
        //     margin: const EdgeInsets.only(right: 50, left: 50, bottom: 100));

        // push bottom sheet to show paywall
        _buildPaywallBottomSheet(heightScreen);

        break;
      case AddThemeStatus.success:
        break;
      case AddThemeStatus.overMaxLimit:
        Get.snackbar('Over limit', 'You have reached maximum limit',
            duration: 5.seconds,
            colorText: Colors.white,
            backgroundColor: AppColors.middleBlack,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(right: 50, left: 50, bottom: 100));
        break;
      default:
        Get.snackbar('Error', 'Failed to add theme',
            duration: 5.seconds,
            colorText: Colors.white,
            backgroundColor: AppColors.middleBlack,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(right: 50, left: 50, bottom: 100));
    }
  }

  void _buildPaywallBottomSheet(double heightScreen) {
    Get.bottomSheet(
        SizedBox(
          height: heightScreen,
          child: PaywallScreen(),
        ),
        isScrollControlled: true);
  }
}
