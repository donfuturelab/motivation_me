import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/core/context_provider/context_provider.dart';
import '../../core/local_storage/configuration_storage.dart';
import '/features/mood_asking/mood_asking_screen.dart';
import '/features/main_screen/selected_tab_provider.dart';

import '../../core/constant/colors.dart';

// import '../create_quote/create_quote_screen.dart';
import '../home/home_screen.dart';
import '../me/me_screen.dart';
import '../themes/themes_screen.dart';
// import 'main_controller.dart';

class MainScreen extends HookConsumerWidget {
  final int? quoteId;
  MainScreen({super.key, this.quoteId});

  // final _mainController = Get.find<MainController>();

  final _icons = <IconData>[
    Icons.format_quote_rounded,
    // Icons.edit_document,
    Icons.brush,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    void showMoodQuoteBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              // padding: EdgeInsets.only(top: statusBarHeigh),
              child: const MoodAskingScreen());
        },
      );
    }

    //create bottomsheet for create quote screen
    // void showCreateQuoteBottomSheet() {
    //   showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (context) {
    //       return Container(
    //           color: AppColors.black,
    //           padding: EdgeInsets.only(top: statusBarHeigh),
    //           child: const CreateQuoteScreen());
    //     },
    //   );
    // }

    final List<Widget> screen = <Widget>[
      HomeScreen(quoteId: quoteId),
      // const MoodAskingScreen(),
      // const MyQuotesScreen(),
      // const CreateQuoteScreen(),
      const ThemesScreen(),
      const MeScreen()
    ];

    Widget buildNavigationBar() {
      return BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        height: 80,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(0);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 0, icons: _icons),
            ),
            IconButton(
              onPressed: () => showMoodQuoteBottomSheet(),
              icon: const Icon(
                Icons.emoji_emotions,
                color: AppColors.textColor,
                size: 45,
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       ref.read(selectedTabProvider.notifier).selectTab(1);
            //     },
            //     icon: BottomBarIcon(
            //         selectedTab: selectedTab, index: 1, icons: _icons)),
            // const SizedBox(width: 50),
            const Spacer(),
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(1);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 1, icons: _icons),
            ),
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(2);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 2, icons: _icons),
            ),
          ],
        ),
      );
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedTabProvider.notifier).selectTab(0);
        // check if user has not yet opened the app today
        // show mood quote bottom sheet
        if (!ConfigurationStorage.isTodayOpenedApp()) {
          showMoodQuoteBottomSheet();
          ConfigurationStorage.saveLastOpenAppDate(DateTime.now());
        }

        ref.read(topPaddingProvider.notifier).state =
            MediaQuery.of(context).padding.top.toDouble();
      });
      return;
    }, []);

    return Scaffold(
      extendBody: true,
      body: screen[selectedTab],
      bottomNavigationBar: Stack(
        children: [
          buildNavigationBar(),
          // Positioned(
          //   top: 10,
          //   left: MediaQuery.of(context).size.width / 2 - 30,
          //   child: SizedBox(
          //     width: 60,
          //     height: 60,
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         showMoodQuoteBottomSheet();
          //       },
          //       backgroundColor: AppColors.middleBlack.withOpacity(0.8),
          //       shape: const CircleBorder(),
          //       elevation: 0,
          //       child: const Icon(
          //         Icons.emoji_emotions,
          //         color: AppColors.textColor,
          //         size: 35,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class BottomBarIcon extends StatelessWidget {
  const BottomBarIcon({
    super.key,
    required this.selectedTab,
    required this.index,
    required this.icons,
  });

  final int selectedTab;
  final int index;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: selectedTab == index
          ? AppColors.main.withOpacity(0.8)
          : AppColors.middleBlack.withOpacity(0.8),
      child: Icon(
        icons[index],
        color: AppColors.textColor,
      ),
    );
  }
}
