import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/features/main_screen/selected_tab_provider.dart';

import '../../core/constant/colors.dart';

import '../create_quote/create_quote_screen.dart';
import '../home/home_screen.dart';
import '../me/me_screen.dart';
import '../my_quotes/my_quotes_screen.dart';
import '../themes/themes_screen.dart';
// import 'main_controller.dart';

class MainScreen extends ConsumerWidget {
  final int? quoteId;
  MainScreen({super.key, this.quoteId});

  // final _mainController = Get.find<MainController>();

  final _icons = <IconData>[
    Icons.format_quote_rounded,
    Icons.edit_document,
    Icons.brush,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    final statusBarHeigh = MediaQuery.of(context).padding.top;

    //create bottomsheet for create quote screen
    void showCreateQuoteBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              color: AppColors.black,
              padding: EdgeInsets.only(top: statusBarHeigh),
              child: const CreateQuoteScreen());
        },
      );
    }

    final List<Widget> screen = <Widget>[
      HomeScreen(quoteId: quoteId),
      const MyQuotesScreen(),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(0);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 0, icons: _icons),
            ),
            IconButton(
                onPressed: () {
                  ref.read(selectedTabProvider.notifier).selectTab(1);
                },
                icon: BottomBarIcon(
                    selectedTab: selectedTab, index: 1, icons: _icons)),
            const SizedBox(width: 50),
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(2);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 2, icons: _icons),
            ),
            IconButton(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).selectTab(3);
              },
              icon: BottomBarIcon(
                  selectedTab: selectedTab, index: 3, icons: _icons),
            ),
          ],
        ),
      );
    }

    // Widget navigationBar() {
    //   return BottomNavigationBar(
    //     type: BottomNavigationBarType.fixed,
    //     backgroundColor: Colors.transparent,
    //     showSelectedLabels: false,
    //     showUnselectedLabels: false,
    //     items: List.generate(
    //       _icons.length,
    //       (index) => BottomNavigationBarItem(
    //         icon: CircleAvatar(
    //             radius: 25,
    //             backgroundColor: selectedTab == index
    //                 ? AppColors.main
    //                 : Colors.black.withOpacity(0.4),
    //             child: Icon(
    //               _icons[index],
    //               size: 30,
    //               color: Colors.white,
    //             )),
    //         label: '',
    //       ),
    //     ),
    //     currentIndex: selectedTab,
    //     onTap: (index) {
    //       ref.read(selectedTabProvider.notifier).selectTab(index);
    //     },
    //   );
    // }

    return Scaffold(
      extendBody: true,
      body: screen[selectedTab],
      bottomNavigationBar: Stack(
        children: [
          buildNavigationBar(),
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  showCreateQuoteBottomSheet();
                },
                backgroundColor: AppColors.middleBlack.withOpacity(0.8),
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(
                  Icons.add,
                  color: AppColors.textColor,
                ),
              ),
            ),
          )
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
