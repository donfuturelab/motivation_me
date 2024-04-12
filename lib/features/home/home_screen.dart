import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/models/enum.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import '../../models/default_quote.dart';
import '../../routings/routers.dart';
import '../add_to_collection/add_to_collection_screen.dart';
import '../add_to_collection/add_to_collection_screen2.dart';
import 'home_controller.dart';
import 'reminder_init_bottomsheet.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    // Show reminder init bottomsheet after 30 seconds
    ever(controller.isShowInitReminder, (callback) {
      if (controller.isShowInitReminder.value) {
        Get.bottomSheet(
          SizedBox(
            height: context.height * 0.5,
            child: const ReminderInitBottomsheet(),
          ),
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
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => !controller.isLoading
            ? Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      controller.resetScaleAnimation();
                    },
                    itemCount: controller.quotes.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final quote = controller.quotes[index];
                      final theme = controller
                          .quoteThemes[index % controller.quoteThemes.length];
                      return Stack(children: [
                        ScaleTransition(
                          scale: controller.scaleAnimation!,
                          child: Image.asset(
                              convertImageCodeToPath(theme.imageCode),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                          color: hexStringToColor(
                                              theme.shadowColor!),
                                          offset: const Offset(0, 1),
                                          blurRadius: 10)
                                    ]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //check if author name is not null
                            controller.quotes[index].authorName != null
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
                                IconButton(
                                  onPressed: () =>
                                      controller.toggleLikeQuote(quote, index),
                                  icon: Icon(
                                    quote.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
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
                      onTap: () => Get.toNamed(Routes.categories),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
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
                              controller.selectedCategoryName,
                              style: context.textTheme.labelMedium,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const Center(child: CircleProgressBar()),
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
          height: context.height * 0.9,
          child: AddToCollectionScreen2(
              quoteId: quoteId, quoteSource: QuoteSource.defaultQuote),
        );
      },
    );
  }

  // create bottomsheet to show add to collection
  // void _showAddToCollectionBottomSheet(
  //     BuildContext context, double height, int quoteId) {
  //   Get.bottomSheet(
  //     SizedBox(
  //       height: 1000,
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 50),
  //         child: AddToCollectionScreen2(
  //             quoteId: quoteId, quoteSource: QuoteSource.defaultQuote),
  //       ),
  //     ),
  //     backgroundColor: AppColors.black,
  //     isScrollControlled: false,
  //     clipBehavior: Clip.antiAlias,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //   );
  // }
}

class FavoriteButton extends StatelessWidget {
  final DefaultQuote quote;
  final int index;
  final HomeController controller;

  const FavoriteButton(
      {Key? key,
      required this.quote,
      required this.index,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controller.toggleLikeQuote(quote, index),
      icon: Icon(
        quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
