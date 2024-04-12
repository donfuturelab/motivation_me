import 'dart:math';

import '../../constant/background_images.dart';

String getRandomImageUrl() {
  Random random = Random();
  int index = random.nextInt(backgroundImages.length);
  return backgroundImages[index];
}
