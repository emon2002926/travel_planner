import 'dart:async';
import 'package:get/get.dart';
import 'package:travel_planner/features/auth/views/auth_screen.dart';
import 'package:travel_planner/features/base_screen/views/base_page.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/util/app_navigation.dart';
import '../../onboarding/views/onboarding_screen.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      final String? accessToken = StorageService.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        AppNavigation.pushAndClear(OnBoardingScreen());

      } else {
        // AppNavigation.pushAndClear(OnBoardingScreen());
        // AppNavigation.pushAndClear(AuthScreen());
        AppNavigation.pushAndClear(BasePage());
      }
    });
  }
}
