import 'package:flutter/material.dart';
import 'package:get/get.dart';







class BaseController extends GetxController {
  final RxInt currentIndex = 0.obs;
  int lastTapTime = 0;

  final homeNavKey     = GlobalKey<NavigatorState>();
  final tripsNavKey  = GlobalKey<NavigatorState>();
  final aiAssistantNavKey  = GlobalKey<NavigatorState>();
  final saftyPageNavKey = GlobalKey<NavigatorState>();
  final settingsNavKey   = GlobalKey<NavigatorState>();
  final progressNavKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  GlobalKey<NavigatorState> keyForIndex(int index) {
    switch (index) {
      case 1:  return tripsNavKey;
      case 2:  return aiAssistantNavKey;
      case 3:  return saftyPageNavKey;
      case 4: return settingsNavKey;
      case 5: return progressNavKey;

      default: return homeNavKey;
    }
  }

  void onTabSelected(int index) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (index == currentIndex.value && currentTime - lastTapTime < 500) {
      keyForIndex(index).currentState?.popUntil((route) => route.isFirst);
    } else {
      currentIndex.value = index;

      // if (index == 3) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     final nutritionController = Get.find<NutritionController>();
      //     nutritionController.showPremiumSheetIfNeeded();
      //   });
      // }
    }

    lastTapTime = currentTime;
  }


}