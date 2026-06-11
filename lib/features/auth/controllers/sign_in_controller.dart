import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/base_screen/views/base_page.dart';

import '../views/forgot_password_screen.dart';

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
    AppNavigation.push(BasePage());

  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}