import 'package:flutter/foundation.dart';

class NavigationController {
  NavigationController._();

  static final ValueNotifier<int> currentIndex =
      ValueNotifier<int>(0);

  static void goTo(int index) {
    currentIndex.value = index;
  }
}