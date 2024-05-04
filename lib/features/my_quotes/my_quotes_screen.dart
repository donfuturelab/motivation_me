import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/features/themes/selected_theme_provider.dart';
import 'package:motivation_me/models/user_quote.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import 'my_quote_controller.dart';

class MyQuotesScreen extends HookConsumerWidget {
  const MyQuotesScreen({super.key});

  // final _myQuotesController = Get.find<MyQuotesController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController =
        useAnimationController(duration: const Duration(seconds: 10));

    final scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(animationController);

    final pageController =
        usePageController(viewportFraction: 1, keepPage: true);

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    void resetScaleAnimation() {
      animationController.reset();
      animationController.forward();
    }

    final controller = ref.watch(myQuoteControllerProvider);
    final themes = ref.watch(selectedThemesProvider);

    Widget buildEmptyQuote() {
      return Stack(children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: Image.asset(convertImageCodeToPath(themes[1].imageCode),
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
                    color: hexStringToColor(themes[1].fontColor),
                    shadows: [
                      Shadow(
                          color: hexStringToColor(themes[1].shadowColor!),
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
                        child: Icon(color: AppColors.textColor, Icons.add)),
                  ),
                ),
                TextSpan(
                  text: 'to add your first new quote',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: hexStringToColor(themes[1].fontColor),
                      shadows: [
                        Shadow(
                            color: hexStringToColor(themes[1].shadowColor!),
                            offset: const Offset(0, 1),
                            blurRadius: 10)
                      ]),
                )
              ]),
            ),
          ),
        ),
      ]);
    }

    return Scaffold(
      body: Stack(children: [
        controller.when(
            data: (quotes) {
              if (quotes.isEmpty) {
                return buildEmptyQuote();
              } else {
                return Stack(
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  FavoriteButtonMyQuote(
                                    quote: quote,
                                    index: index,
                                  ),

                                  // const SizedBox(width: 10),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: const Icon(
                                  //     Icons.share,
                                  //     color: Colors.white,
                                  //     size: 30,
                                  //   ),
                                  // ),
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
                      child: Text(
                        'My Quotes',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 10)
                            ]),
                      ),
                    ),
                  ],
                );
              }
            },
            loading: () => const CircleProgressBar(),
            error: (error, stack) => Center(
                  child: Text('Error: $error'),
                )),
      ]),
    );
  }
}

class FavoriteButtonMyQuote extends ConsumerWidget {
  final UserQuote quote;
  final int index;

  const FavoriteButtonMyQuote({
    Key? key,
    required this.quote,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(myQuoteControllerProvider.notifier)
          .toggleLikeQuote(quote, index),
      icon: Icon(
        quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
