import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool oldPasswordVisible = false.obs;
  final RxBool newPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  void toggleOldPassword() =>
      oldPasswordVisible.value = !oldPasswordVisible.value;
  void toggleNewPassword() =>
      newPasswordVisible.value = !newPasswordVisible.value;
  void toggleConfirmPassword() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;

  void onSave() {}

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}