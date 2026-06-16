import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/base_screen/views/base_page.dart';

import '../../../core/util/storage_service.dart';
import '../../base_screen/controllers/base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../views/forgot_password_screen.dart';
import 'account_selection_controller.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool passwordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  void togglePassword() => passwordVisible.value = !passwordVisible.value;

  void onForgotPassword() {
    AppNavigation.push(ForgotPasswordScreen());
  }

  // void onSignIn() {AppNavigation.push(SettingsScreen());}
  void onSignIn() {

    if (StorageService.userRole == null) {
      saveRole();
      Get.delete<BaseController>(force: true);
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().printRole();
      }
      AppNavigation.pushAndClear(BasePage());
    } else {
      Get.delete<BaseController>(force: true); // if it caches tab/session state

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().printRole();
      }
      AppNavigation.push(BasePage());


    }

  }


  Future<void> saveRole() async {
    await StorageService.saveUserRole(UserRole.viewer);
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}