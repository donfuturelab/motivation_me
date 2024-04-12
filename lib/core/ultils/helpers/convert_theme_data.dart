import 'dart:ui';

import '../../constant/background_images.dart';

String getImageBackground(int index) {
  return backgroundImages[index % backgroundImages.length];
}

String convertImageCodeToPath(String code) {
  return 'assets/images/backgrounds/$code.jpg';
}

Color hexStringToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
