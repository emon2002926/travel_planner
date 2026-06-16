import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/onboarding/views/onboarding_screen.dart';
import 'package:travel_planner/features/settings/views/change_pin_screen.dart';
import 'package:travel_planner/features/settings/views/faqs_screen.dart';
import 'package:travel_planner/features/settings/views/notification_screen.dart';
import 'package:travel_planner/features/settings/views/terms_conditions_screen.dart';

import '../../../core/themes/theme_controller.dart';
import '../../../core/util/storage_service.dart';
import '../views/change_password_screen.dart';
import '../views/privacy_policy_screen.dart';
import '../views/profile_update_screen.dart';

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

  void onProfileUpdate() {
    AppNavigation.push(ProfileUpdateScreen());
  }
  void onChangePassword() {
    AppNavigation.push(ChangePasswordScreen());
  }
  void onChangePIN() {
    AppNavigation.push(ChangePinScreen());
  }
  void onDeleteAccount() {
    // AppNavigation.push(DeleteAccountScreen());
  }
  void logOut() {
    StorageService.logout();
    AppNavigation.pushAndClear(OnBoardingScreen());
  }
  void onTermsAndConditions() {
    AppNavigation.push(TermsConditionsScreen());
  }
  void onPrivacyPolicy() {
    AppNavigation.push(PrivacyPolicyScreen());
  }
  void onFaqs() {
    AppNavigation.push(FaqsScreen());
  }
  void onNotificationTap() {
    AppNavigation.push(NotificationScreen());
  }
  void onProfileArrowTap() {
    AppNavigation.push(ProfileUpdateScreen());
  }
}