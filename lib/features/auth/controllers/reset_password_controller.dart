import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';

import '../views/auth_screen.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool passwordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  void togglePassword() => passwordVisible.value = !passwordVisible.value;

  void toggleConfirmPassword() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;

  void onConfirm() {
    AppNavigation.push(AuthScreen());
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}