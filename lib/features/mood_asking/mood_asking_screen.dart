import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/common_widgets/circle_progress_bar.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/configurations.dart';
import '../../core/context_provider/context_provider.dart';
import '../../core/local_storage/configuration_storage.dart';
import '../../core/ultils/helpers/audio_player/audio_player.dart';
import '../../core/ultils/helpers/convert_theme_data.dart';
import '../../core/ultils/helpers/translate_service/translate_service.dart';
import '../../models/default_quote.dart';
import '../../models/enums/mood.dart';
import '../home/home_screen.dart';
import '../paywall/paywall_screen.dart';
import '../paywall/subscription_provider.dart';
import '../themes/selected_theme_provider.dart';
import 'moode_asking_provider.dart';

class MoodAskingScreen extends HookConsumerWidget {
  const MoodAskingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectedMood = useState(false);
    final selectedMood = useRef<MoodModal?>(null);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          !isSelectedMood.value
              ? Padding(
                  padding: const EdgeInsets.all(16).copyWith(top: 60),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            'How are you feeling today?',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 30),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 2 / 2.7),
                            itemCount: moodList.length,
                            itemBuilder: (context, index) {
                              final mood = moodList[index];
                              return GestureDetector(
                                onTap: () {
                                  selectedMood.value = mood;
                                  isSelectedMood.value = true;
                                },
                                child: Container(
                                  //border radius 10, border color AppColors.lightBlack, border width 2
                                  //add shadow to the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppColors.black,
                                    // border: Border.all(
                                    //     color: AppColors.lightBlack, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: AppColors.middleBlack,
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Image.asset(mood.image,
                                          width: 70, height: 70),
                                      const Spacer(),
                                      Text(mood.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: mood.color,
                                                  fontSize: 14)),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              : QuoteByMoodScreen(mood: selectedMood.value!),
          Positioned(
            top: 50,
            right: 10,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.lightBlack,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  weight: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteByMoodScreen extends HookConsumerWidget {
  const QuoteByMoodScreen({super.key, required this.mood});
  final MoodModal mood;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(moodAskingProvider(mood));

    final themes = ref.watch(selectedThemesProvider);

    final isSubscribed = ref.watch(subscriptionProvider);

    final player = ref.watch(audioPlayerProvider);
    final isTtsEnabled = useState(ConfigurationStorage.getIsVoiceSpeakActive());
    final isTranslateEnabled = useState(false);

    final translatedQuote = useState('');

    final isTranslating = useState(false);

    final isShowCover = useState(false);

    final animationController =
        useAnimationController(duration: const Duration(seconds: 10));
    final scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(animationController);

    final pageController =
        usePageController(viewportFraction: 1, keepPage: true);

    useMemoized(() async => await ref.read(audioPlayerProvider).setSpeed(0.8));

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

    void resetScaleAnimation() {
      animationController.reset();
      animationController.forward();
    }

    void checkSubscriptionToshow(int index) {
      if (!isSubscribed.value! &&
          index > maximumQuoteForMoodNotSubscribed - 1) {
        isShowCover.value = true;
        //show paywall screen
        Future.delayed(const Duration(milliseconds: 1500), () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                  color: AppColors.black,
                  padding: EdgeInsets.only(top: ref.watch(topPaddingProvider)),
                  child: const PaywallScreen());
            },
          );
        });
      }
    }

    return quotes.when(
      loading: () => const Center(child: CircleProgressBar()),
      error: (error, stack) => const Center(child: Text('Error')),
      data: (quotes) => Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: quotes.length,
            onPageChanged: (index) {
              resetScaleAnimation();
              // if TTS is enabled, start reading the quote content

              if (isTtsEnabled.value) {
                ref.read(fetchAndPlayTTSProvider.notifier).stopSpeak(player);
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

              // check if user is not subscribed, and the index is greater than maximumQuoteForMoodNotSubscribed
              checkSubscriptionToshow(index);
            },
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
                      child: !isTranslateEnabled.value
                          ? QuoteText(
                              theme: theme, quoteText: quote.quoteContent)
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
                const SizedBox(height: 20),
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
                                  await ConfigurationStorage.saveIsVoiceSpeakActive(
                                      true); //save first before wait to complete playing
                                  await ref
                                      .watch(fetchAndPlayTTSProvider.notifier)
                                      .playSpeak(player, quote.quoteContent);
                                } else {
                                  await ConfigurationStorage
                                      .saveIsVoiceSpeakActive(false);
                                  await ref
                                      .watch(fetchAndPlayTTSProvider.notifier)
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
                            // IconButton(
                            //   onPressed: () {
                            //     _showAddToCollectionBottomSheet(
                            //         context, quote.id, statusBarHeight);
                            //   },
                            //   icon: const Icon(
                            //     Icons.bookmark_border,
                            //     color: Colors.white,
                            //     size: 35,
                            //   ),
                            // ),
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
            top: ref.watch(topPaddingProvider) + 10,
            left: 16,
            child: Row(
              children: [
                Text(
                  'Quotes for ${mood.title}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      shadows: [
                        const Shadow(
                            color: AppColors.middleBlack,
                            offset: Offset(0, 2),
                            blurRadius: 10)
                      ]),
                ),
                const SizedBox(width: 10),
                // asset mood image
                Image.asset(mood.image, width: 30, height: 30),
              ],
            ),
          ),
          //show cover quote for not subscribed user
          isShowCover.value
              ? const CoverQuoteForNotSubscribed()
              : const SizedBox(),
        ],
      ),
    );
  }
}

class CoverQuoteForNotSubscribed extends StatelessWidget {
  const CoverQuoteForNotSubscribed({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        //create border radius 20, padding 20, margin 20, height 25% of screen height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.black.withOpacity(0.9),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height * 0.25,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have reached the maximum number of quotes. Subscribe to unlock more quotes',
              style: TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MoodFavoriteButton extends ConsumerWidget {
  final int? quoteId;
  final DefaultQuote quote;
  final int index;
  final MoodModal mood;

  const MoodFavoriteButton({
    Key? key,
    required this.quote,
    required this.index,
    this.quoteId,
    required this.mood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(moodAskingProvider(mood).notifier)
            .toggleLikeQuote(quote, index);
      },
      icon: Icon(
        quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class MoodModal {
  final MoodType code;
  final String image;
  final String title;
  final Color color;

  MoodModal(
      {required this.code,
      required this.image,
      required this.title,
      required this.color});
}

final moodList = [
  MoodModal(
      code: MoodType.happy,
      image: 'assets/images/moods/happy.png',
      title: 'Happy',
      color: Colors.yellow),
  MoodModal(
      code: MoodType.sad,
      image: 'assets/images/moods/sad.png',
      title: 'Sad',
      color: Colors.grey),
  MoodModal(
      code: MoodType.angry,
      image: 'assets/images/moods/angry.png',
      title: 'Angry',
      color: Colors.red),
  MoodModal(
      code: MoodType.challenged,
      image: 'assets/images/moods/challenged.png',
      title: 'Challenged',
      color: Colors.white),
  MoodModal(
      code: MoodType.love,
      image: 'assets/images/moods/love.png',
      title: 'Love',
      color: Colors.pinkAccent),
  MoodModal(
      code: MoodType.bored,
      image: 'assets/images/moods/bored.png',
      title: 'Bored',
      color: Colors.deepOrange),
  MoodModal(
      code: MoodType.tired,
      image: 'assets/images/moods/tired.png',
      title: 'Tired',
      color: Colors.green),
  MoodModal(
      code: MoodType.discouraged,
      image: 'assets/images/moods/discouraged.png',
      title: 'Discouraged',
      color: Colors.grey),
  MoodModal(
      code: MoodType.ok,
      image: 'assets/images/moods/ok.png',
      title: 'Ok',
      color: Colors.blue),
  MoodModal(
      code: MoodType.worried,
      image: 'assets/images/moods/worried.png',
      title: 'Worried',
      color: Colors.yellow),
];
