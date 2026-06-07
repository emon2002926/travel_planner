import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';

import '../views/forgot_password_screen.dart';
import '../views/sign_up_screen.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool passwordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  void togglePassword() => passwordVisible.value = !passwordVisible.value;

  void onForgotPassword() {
    AppNavigation.push(ForgotPasswordScreen());
  }

  void onSignIn() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}