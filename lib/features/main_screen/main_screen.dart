import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../routings/app_routes.dart';
import '../create_quote/create_quote_screen.dart';
import '../home/home_screen.dart';
import '../me/me_screen.dart';
import '../my_quotes/my_quotes_screen.dart';
import '../themes/themes_screen.dart';
import 'main_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _mainController = Get.find<MainController>();

  final List<Widget> _screen = <Widget>[
    HomeScreen(),
    MyQuotesScreen(),
    CreateQuoteScreen(),
    ThemesScreen(),
    const MeScreen()
  ];

  final _icons = <IconData>[
    Icons.format_quote_rounded,
    Icons.edit_document,
    Icons.add,
    Icons.brush,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() => _screen[_mainController.selectedIndex]),
      bottomNavigationBar: _navigationBar(),
    );
  }

  Widget _navigationBar() {
    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(
          _icons.length,
          (index) => BottomNavigationBarItem(
            icon: CircleAvatar(
                radius: 25,
                backgroundColor: _mainController.selectedIndex == index
                    ? AppColors.main
                    : Colors.black.withOpacity(0.4),
                child: Icon(
                  _icons[index],
                  size: 30,
                  color: Colors.white,
                )),
            label: '',
          ),
        ),
        currentIndex: _mainController.selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Get.toNamed(Routes.createQuote);
            return;
          }
          if (index == 3) {
            Get.toNamed(Routes.themes);
            return;
          }
          _mainController.selectScreen(index);
        },
      ),
    );
  }
}
