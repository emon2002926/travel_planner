import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/themes/theme_controller.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final RxBool notificationsEnabled = false.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    if (GetInstance().isRegistered<ThemeController>()) {
      Get.find<ThemeController>().toggleTheme();
    }
  }

  void toggleNotifications(bool value) =>
      notificationsEnabled.value = value;

  void onProfileUpdate() {}
  void onChangePassword() {}
  void onChangePIN() {}
  void onDeleteAccount() {}
  void onTermsAndConditions() {}
  void onPrivacyPolicy() {}
  void onFaqs() {}
  void onNotificationTap() {}
  void onProfileArrowTap() {}
}