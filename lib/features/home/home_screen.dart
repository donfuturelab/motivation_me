import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/core/ultils/helpers/translate_service/translate_service.dart';
import 'package:motivation_me/models/theme/selected_theme.dart';

import '../../core/ultils/helpers/audio_player/audio_player.dart';
import '../../core/ultils/helpers/in_app_review_service/in_app_review_service.dart';
import '/models/enum.dart';

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
  final int? quoteId;
  HomeScreen({super.key, this.quoteId});

  final InAppReviewService _inAppReviewService = InAppReviewService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show reminder init bottomsheet after 30 seconds

    final themes = ref.watch(selectedThemesProvider);

    final quotes = ref.watch(homeControllerProvider(quoteId: quoteId));

    final category = ref.watch(selectedCategoryProvider);

    final player = ref.watch(audioPlayerProvider);

    // final ttsService = ref.watch(ttsServiceProvider);

    final isTtsEnabled = useState(ConfigurationStorage.getIsVoiceSpeakActive());
    // final currentQuoteContent = useState('');
    // final currentWordStart = useListenable(ttsService.currentWordStart);
    // final currentWordEnd = useListenable(ttsService.currentWordEnd);

    final isTranslateEnabled = useState(false);

    final translatedQuote = useState('');

    final isTranslating = useState(false);

    final animationController =
        useAnimationController(duration: const Duration(seconds: 10));

    final scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(animationController);

    final pageController =
        usePageController(viewportFraction: 1, keepPage: true);

    final statusBarHeight =
        useMemoized(() => MediaQuery.of(context).padding.top);

    useMemoized(() async => await ref.read(audioPlayerProvider).setSpeed(0.8));

    // if TTS is enabled, start reading the quote content
    void handleInitSpeakForFirstQuote(DefaultQuote firstQuote) async {
      if (isTtsEnabled.value) {
        ref
            .read(fetchAndPlayTTSProvider.notifier)
            .playSpeak(player, firstQuote.quoteContent);
      }
    }

    //translate the quote content
    void handleTranslateForQuote(DefaultQuote quote) async {
      if (isTranslateEnabled.value) {
        isTranslating.value = true;
        final translated = await translateService(
            tsLanguage: ConfigurationStorage.getLanguageCode(),
            text: quote.quoteContent);
        translatedQuote.value = translated ?? '';
        isTranslating.value = false;
      }
    }

    //show reminder init bottomsheet after 15 seconds
    useEffect(() {
      animationController.forward();
      if (!ConfigurationStorage.getIsSetInitReminder()) {
        Timer(
          const Duration(seconds: 15),
          () {
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
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const ReminderInitBottomsheet());
                });
          },
        );
      }

      // ask for review if the app has been opened 3 times

      // listen to pageController to fetch more quotes
      pageController.addListener(() {
        //check if pageController has reached the page nearest to the start
        if (pageController.page != null &&
            pageController.page!.round() != pageController.page) {
          // ttsService.resetCurrentWord();
        }

        if (_inAppReviewService.shouldRequestReview()) {
          if (pageController.page!.round() == 2) {
            _inAppReviewService.requestReview();
          }
        }

        //check if pageController has reached the page nearest to the end

        if (pageController.position.pixels ==
            pageController.position.maxScrollExtent -
                pageController.position.viewportDimension) {
          ref
              .read(homeControllerProvider(quoteId: quoteId).notifier)
              .fetchMoreQuotes();
        }
      });

      return null;
    }, const []);

    void resetScaleAnimation() {
      animationController.reset();
      animationController.forward();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: quotes.when(
        data: (quotes) {
          // if TTS is enabled, start speak the first quote content
          handleInitSpeakForFirstQuote(quotes.first);

          return Stack(
            children: [
              PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  resetScaleAnimation();
                  // if TTS is enabled, start reading the quote content

                  if (isTtsEnabled.value) {
                    ref
                        .read(fetchAndPlayTTSProvider.notifier)
                        .stopSpeak(player);
                    Future.delayed(const Duration(seconds: 1), () {
                      ref
                          .read(fetchAndPlayTTSProvider.notifier)
                          .playSpeak(player, quotes[index].quoteContent);
                    });
                  }

                  // if translate is enabled, disable translate
                  if (isTranslateEnabled.value) {
                    isTranslateEnabled.value = false;
                  }
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child:
                              // RichText(
                              //         // RichText widget to highlight the current word being read
                              //         textAlign: TextAlign.center,
                              //         text: TextSpan(
                              //           style: TextStyle(
                              //             fontSize: 25,
                              //             fontFamily: theme.fontFamily,
                              //             fontWeight: FontWeight.bold,
                              //             color: hexStringToColor(theme.fontColor),
                              //             shadows: [
                              //               Shadow(
                              //                   color: hexStringToColor(
                              //                       theme.shadowColor!),
                              //                   offset: const Offset(0, 1),
                              //                   blurRadius: 10)
                              //             ],
                              //           ),
                              //           children: <TextSpan>[
                              //             TextSpan(
                              //               text: quote.quoteContent
                              //                   .substring(0, currentWordStart.value),
                              //             ),
                              //             if (currentWordStart.value <
                              //                 currentWordEnd.value)
                              //               TextSpan(
                              //                 text: quote.quoteContent.substring(
                              //                     currentWordStart.value,
                              //                     currentWordEnd.value),
                              //                 style: const TextStyle(
                              //                   backgroundColor: AppColors.main,
                              //                 ),
                              //               ),
                              //             if (currentWordEnd.value <
                              //                 quote.quoteContent.length)
                              //               TextSpan(
                              //                 text: quote.quoteContent
                              //                     .substring(currentWordEnd.value),
                              //               ),
                              //           ],
                              //         ),
                              //       )
                              //     :
                              !isTranslateEnabled.value
                                  ? QuoteText(
                                      theme: theme,
                                      quoteText: quote.quoteContent)
                                  : isTranslating.value
                                      ? const SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircleProgressBar())
                                      : QuoteText(
                                          theme: theme,
                                          quoteText: translatedQuote.value),
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
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 140.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isTtsEnabled.value
                                ? Center(
                                    child: Image.asset(
                                    'assets/images/icons/audio_playing.webp',
                                    // width: 300,
                                    height: 100,
                                  ))
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    isTtsEnabled.value = !isTtsEnabled.value;
                                    // if TTS is enabled, start reading the quote content
                                    if (isTtsEnabled.value) {
                                      await ConfigurationStorage
                                          .saveIsVoiceSpeakActive(
                                              true); //save first before wait to complete playing
                                      await ref
                                          .watch(
                                              fetchAndPlayTTSProvider.notifier)
                                          .playSpeak(
                                              player, quote.quoteContent);
                                    } else {
                                      await ConfigurationStorage
                                          .saveIsVoiceSpeakActive(false);
                                      await ref
                                          .watch(
                                              fetchAndPlayTTSProvider.notifier)
                                          .stopSpeak(player);
                                    }
                                  },
                                  icon: CircleAvatar(
                                    //create circle with transparent background and having white border color
                                    backgroundColor: isTtsEnabled.value
                                        ? AppColors.textColor
                                        : Colors.transparent,

                                    radius: 20,
                                    child: SvgPicture.asset(
                                      'assets/images/icons/voice_enable.svg',
                                      width: 30,
                                      height: 30,
                                      colorFilter: ColorFilter.mode(
                                          isTtsEnabled.value
                                              ? AppColors.black
                                              : Colors.white,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(width: 10),
                                FavoriteButton(quote: quote, index: index),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    _showAddToCollectionBottomSheet(
                                        context, quote.id, statusBarHeight);
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    isTranslateEnabled.value =
                                        !isTranslateEnabled.value;

                                    handleTranslateForQuote(quote);
                                  },
                                  icon: CircleAvatar(
                                    //create circle with transparent background and having white border color
                                    backgroundColor: isTranslateEnabled.value
                                        ? AppColors.textColor
                                        : Colors.transparent,

                                    radius: 20,
                                    child: SvgPicture.asset(
                                      'assets/images/icons/translate.svg',
                                      width: 25,
                                      height: 25,
                                      colorFilter: ColorFilter.mode(
                                          isTranslateEnabled.value
                                              ? AppColors.black
                                              : Colors.white,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                  onTap: () {
                    if (isTtsEnabled.value) {
                      ref
                          .read(fetchAndPlayTTSProvider.notifier)
                          .stopSpeak(player);
                    }

                    if (isTranslateEnabled.value) {
                      isTranslateEnabled.value = false;
                    }

                    context.push(Routes.categories);
                  },
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
          );
        },
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
  void _showAddToCollectionBottomSheet(
      BuildContext context, int quoteId, double statusBarHeight) {
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
        return Container(
          color: AppColors.black,
          padding: EdgeInsets.only(
            top: statusBarHeight,
          ),
          child: AddToCollectionScreen(
              quoteId: quoteId, quoteSource: QuoteSource.defaultQuote),
        );
      },
    );
  }
}

class QuoteText extends StatelessWidget {
  const QuoteText({
    super.key,
    required this.theme,
    required this.quoteText,
  });

  final SelectedTheme theme;
  final String quoteText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      // RichText widget to highlight the current word being read
      textAlign: TextAlign.center,
      text: TextSpan(
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
          ],
        ),
        children: <TextSpan>[
          TextSpan(text: quoteText),
        ],
      ),
    );
  }
}

class FavoriteButton extends ConsumerWidget {
  final int? quoteId;
  final DefaultQuote quote;
  final int index;

  const FavoriteButton({
    Key? key,
    required this.quote,
    required this.index,
    this.quoteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(homeControllerProvider(quoteId: quoteId).notifier)
          .toggleLikeQuote(quote, index),
      icon: Icon(
        quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
