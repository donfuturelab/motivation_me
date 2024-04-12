import 'package:get/get.dart';

class MainController extends GetxController {
  MainController();

  final _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void selectScreen(int index) {
    _selectedIndex.value = index;
  }
}
