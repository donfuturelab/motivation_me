import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/models/enum.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../core/local_storage/configuration_storage.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import '../../models/default_quote.dart';
import '../../routings/routers.dart';
import '../add_to_collection/add_to_collection_screen.dart';
import '../themes/selected_theme_provider.dart';
import 'home_controller.dart';
import 'reminder_init_bottomsheet.dart';
import 'selected_category_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show reminder init bottomsheet after 30 seconds

    final animationController =
        useAnimationController(duration: const Duration(seconds: 10));

    final scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(animationController);

    final pageController =
        usePageController(viewportFraction: 1, keepPage: true);

    //show reminder init bottomsheet after 15 seconds
    useEffect(() {
      animationController.forward();
      if (!ConfigurationStorage.getIsSetInitReminder()) {
        Timer(const Duration(seconds: 15), () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (BuildContext bc) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const ReminderInitBottomsheet());
              });
        });
      }
      return null;
    }, const []);

    void resetScaleAnimation() {
      animationController.reset();
      animationController.forward();
    }

    final themes = ref.watch(selectedThemesProvider);

    final quotes = ref.watch(homeControllerProvider);

    final category = ref.watch(selectedCategoryProvider);

    print('category: ${category.name}');
    print('themes: ${themes.length}');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: quotes.when(
        data: (quotes) => Stack(
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                resetScaleAnimation();
              },
              itemCount: quotes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                final theme = themes[index % themes.length];
                return Stack(children: [
                  ScaleTransition(
                    scale: scaleAnimation,
                    child: Image.asset(convertImageCodeToPath(theme.imageCode),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          quote.quoteContent,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: theme.fontFamily,
                              fontWeight: FontWeight.bold,
                              color: hexStringToColor(theme.fontColor),
                              shadows: [
                                Shadow(
                                    color: hexStringToColor(theme.shadowColor!),
                                    offset: const Offset(0, 1),
                                    blurRadius: 10)
                              ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //check if author name is not null
                      quotes[index].authorName != null
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                '-${quote.authorName!}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: theme.fontFamily,
                                    shadows: [
                                      Shadow(
                                          color: hexStringToColor(
                                              theme.shadowColor!),
                                          offset: const Offset(0, 2),
                                          blurRadius: 10)
                                    ],
                                    color: Colors.white),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FavoriteButton(quote: quote, index: index),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              _showAddToCollectionBottomSheet(
                                  context, quote.id);
                            },
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ]);
              },
            ),
            Positioned(
              top: 50,
              left: 16,
              child: GestureDetector(
                onTap: () => context.push(Routes.categories),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        category.name,
                        style: context.textTheme.labelMedium,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        loading: () => const Center(
          child: CircleProgressBar(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  //create bottomsheet to show add to collection do not use Get.bottomSheet
  void _showAddToCollectionBottomSheet(BuildContext context, int quoteId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: context.height,
          child: AddToCollectionScreen(
              quoteId: quoteId, quoteSource: QuoteSource.defaultQuote),
        );
      },
    );
  }
}

class FavoriteButton extends ConsumerWidget {
  final DefaultQuote quote;
  final int index;

  const FavoriteButton({
    Key? key,
    required this.quote,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(homeControllerProvider.notifier)
          .toggleLikeQuote(quote, index),
      icon: Icon(
        quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
