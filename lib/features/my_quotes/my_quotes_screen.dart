import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import 'my_quote_controller.dart';

class MyQuotesScreen extends StatelessWidget {
  MyQuotesScreen({super.key});

  final _myQuotesController = Get.find<MyQuotesController>();

  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Obx(() => !_myQuotesController.isLoading
          ? _myQuotesController.quotes.isEmpty
              ? Center(
                  child: Stack(children: [
                    ScaleTransition(
                      scale: _myQuotesController.scaleAnimation!,
                      child: Image.asset(
                          convertImageCodeToPath(
                              _myQuotesController.quoteThemes[1].imageCode),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Tap',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: hexStringToColor(_myQuotesController
                                    .quoteThemes[1].fontColor),
                                shadows: [
                                  Shadow(
                                      color: hexStringToColor(
                                          _myQuotesController
                                              .quoteThemes[1].shadowColor!),
                                      offset: const Offset(0, 1),
                                      blurRadius: 10)
                                ],
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: CircleAvatar(
                                    backgroundColor: AppColors.black,
                                    radius: 20,
                                    child: Icon(
                                        color: AppColors.textColor, Icons.add)),
                              ),
                            ),
                            TextSpan(
                              text: 'to add your first new quote',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: hexStringToColor(_myQuotesController
                                      .quoteThemes[1].fontColor),
                                  shadows: [
                                    Shadow(
                                        color: hexStringToColor(
                                            _myQuotesController
                                                .quoteThemes[1].shadowColor!),
                                        offset: const Offset(0, 1),
                                        blurRadius: 10)
                                  ]),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ]),
                )
              : Stack(children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _myQuotesController.resetScaleAnimation();
                    },
                    itemCount: _myQuotesController.quotes.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final quote = _myQuotesController.quotes[index];
                      final theme = _myQuotesController.quoteThemes[
                          index % _myQuotesController.quoteThemes.length];

                      return Stack(children: [
                        ScaleTransition(
                          scale: _myQuotesController.scaleAnimation!,
                          child: Image.asset(
                              convertImageCodeToPath(theme.imageCode),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover),
                        ),
                        // Expanded(
                        //   child: Container(
                        //     color: Colors.grey.withOpacity(0.2),
                        //   ),
                        // ),
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
                                    fontWeight: FontWeight.bold,
                                    fontFamily: theme.fontFamily,
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 150.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () => _myQuotesController
                                        .toggleLikeQuote(quote, index),
                                    icon: Obx(() => quote.isLiked.value
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                            size: 30,
                                          ))),
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
                                  onPressed: () {},
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
                  const Positioned(
                    top: 50,
                    left: 16,
                    child: Text('My Quotes',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 10)
                            ])),
                  ),
                ])
          : const CircleProgressBar()),
    ]));
  }
}
