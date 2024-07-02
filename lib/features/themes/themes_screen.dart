import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/common_widgets/snackbar.dart';
import '/features/paywall/paywall_screen.dart';
import '/features/themes/selected_theme_provider.dart';
import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/background_images.dart';
import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import '../../models/enums/add_theme_status.dart';
import '../../models/enums/theme.dart';
import '../../models/theme/quote_theme.dart';
import '../../models/theme/selected_theme.dart';
import 'themes_controller.dart';

class ThemesScreen extends HookConsumerWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final isEditedUserTheme = useState(false);

    final controller = ref.watch(themesControllerProvider);

    void buildPaywallBottomSheet(BuildContext context, double statusBarHeight) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              color: AppColors.black,
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const PaywallScreen());
        },
      );
    }

    void handleAddTheme(AddThemeStatus addThemeResult) async {
      //use switch case to handle the result
      switch (addThemeResult) {
        case AddThemeStatus.exist:
          showSnackbar(context,
              content: 'Theme is already added',
              textColor: AppColors.textColor,
              duration: const Duration(seconds: 5),
              backgroundColor: AppColors.middleBlack);

          break;
        case AddThemeStatus.overLimitForFree:
          buildPaywallBottomSheet(context, statusBarHeight);
          break;
        case AddThemeStatus.notFree:
          buildPaywallBottomSheet(context, statusBarHeight);
          break;
        case AddThemeStatus.success:
          break;
        case AddThemeStatus.overMaxLimit:
          showSnackbar(context,
              content: 'Over limit, You have reached maximum limit',
              textColor: AppColors.textColor,
              duration: const Duration(seconds: 5),
              backgroundColor: AppColors.middleBlack);
          break;
        default:
          showSnackbar(context,
              content: 'Failed to add theme',
              textColor: AppColors.textColor,
              duration: const Duration(seconds: 5),
              backgroundColor: AppColors.middleBlack);
      }
    }

    Widget buildFreeThemes(List<QuoteTheme> freeThemes) {
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
              itemCount: freeThemes.length,
              itemBuilder: (context, index) {
                final theme = freeThemes[index];
                return Container(
                  margin: index == 0
                      ? const EdgeInsets.only(left: 16)
                      : index ==
                              freeThemes.length -
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
                        child: theme.isSelected
                            ? const Padding(
                                padding: EdgeInsets.only(top: 10.0, right: 10),
                                child: Icon(Icons.check_circle,
                                    color: Colors.white, size: 25),
                              )
                            : IconButton(
                                onPressed: () async {
                                  final status = await ref
                                      .read(selectedThemesProvider.notifier)
                                      .addTheme(theme);
                                  handleAddTheme(status);
                                },
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
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      );
    }

    Widget buildThemesByCategory(bool isSubscribed, ThemeCategory themeCategory,
        Map<String, List<QuoteTheme>> themesMap) {
      String themKey = themeCategoryToString(themeCategory);
      List<QuoteTheme> themes = themesMap[themKey]!;
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
                              left: 20,
                              right: 16) //check if it is the last item
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
                      !isSubscribed && theme.themeType == ThemeType.premium
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
                          : const SizedBox(),
                      Align(
                        alignment: Alignment.topRight,
                        child: theme.isSelected
                            ? const Padding(
                                padding: EdgeInsets.only(top: 10.0, right: 10),
                                child: Icon(Icons.check_circle,
                                    color: Colors.white, size: 25),
                              )
                            : IconButton(
                                onPressed: () async {
                                  final status = await ref
                                      .read(selectedThemesProvider.notifier)
                                      .addTheme(theme);
                                  handleAddTheme(status);
                                },
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: controller.when(
        data: (controller) => Padding(
          padding: EdgeInsets.only(bottom: 110, top: statusBarHeight),
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
                          'Selected themes',
                          style: context.textTheme.displayMedium,
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () => isEditedUserTheme.value =
                                !isEditedUserTheme.value,
                            child: Text(
                              isEditedUserTheme.value ? 'Done' : 'Edit',
                              style: context.textTheme.labelMedium,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectedThemes(isEditedUserTheme: isEditedUserTheme.value),
                  const SizedBox(height: 20),
                  buildFreeThemes(controller.freeThemes),
                  const SizedBox(height: 20),
                  buildThemesByCategory(controller.isSubscribed,
                      themeCategorySections[0], controller.categoryThemes),
                  const SizedBox(height: 20),
                  buildThemesByCategory(controller.isSubscribed,
                      themeCategorySections[1], controller.categoryThemes),
                  const SizedBox(height: 20),
                  buildThemesByCategory(controller.isSubscribed,
                      themeCategorySections[2], controller.categoryThemes),
                  const SizedBox(height: 20),
                  buildThemesByCategory(controller.isSubscribed,
                      themeCategorySections[3], controller.categoryThemes),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        loading: () => const CircleProgressBar(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class SelectedThemes extends ConsumerWidget {
  const SelectedThemes({super.key, required this.isEditedUserTheme});
  final bool isEditedUserTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemes = ref.watch(selectedThemesProvider);

    return Container(
      color: AppColors.lightBlack.withOpacity(0.5),
      height: 190,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedThemes.length + 1,
        itemBuilder: (context, index) {
          SelectedTheme? theme =
              index == selectedThemes.length ? null : selectedThemes[index];

          return theme == null
              ? Container(
                  margin: const EdgeInsets.only(left: 20, right: 16),
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.black,
                      border: Border.all(color: Colors.white)),
                  child: const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.white,
                  ),
                )
              : Container(
                  margin: index == 0
                      ? const EdgeInsets.only(left: 16)
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
                              fontSize:
                                  (selectedThemes[index].fontSize!).toDouble(),
                              fontWeight: FontWeight.bold,
                              // fontFamily: _controller
                              //     .selectedThemes[index].fontFamily,
                              fontFamily: theme.fontFamily,
                              color: hexStringToColor(theme.fontColor)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: isEditedUserTheme
                            ? IconButton(
                                onPressed: () => ref
                                    .read(selectedThemesProvider.notifier)
                                    .removeTheme(index),
                                icon: const CircleAvatar(
                                  backgroundColor: AppColors.main,
                                  radius: 12,
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(top: 10.0, right: 10),
                                child: Icon(Icons.check_circle,
                                    color: Colors.white, size: 25),
                              ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
