import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool passwordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  void togglePassword() => passwordVisible.value = !passwordVisible.value;

  void toggleConfirmPassword() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;

  void onSignUp() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}