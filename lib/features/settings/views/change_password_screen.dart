import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(16)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: 'Change Password',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: context.h(28)),
                AppTextField(
                  label: 'Old Password',
                  controller: controller.oldPasswordController,
                  hintText: '********',
                  obscureText: !controller.oldPasswordVisible.value,
                  suffixIcon: controller.oldPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  suffixIconOnTap: controller.toggleOldPassword,
                ),
                SizedBox(height: context.h(16)),
                AppTextField(
                  label: 'New Password',
                  controller: controller.newPasswordController,
                  hintText: '********',
                  obscureText: !controller.newPasswordVisible.value,
                  suffixIcon: controller.newPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  suffixIconOnTap: controller.toggleNewPassword,
                ),
                SizedBox(height: context.h(16)),
                AppTextField(
                  label: 'Re Type Password',
                  controller: controller.confirmPasswordController,
                  hintText: '********',
                  obscureText: !controller.confirmPasswordVisible.value,
                  suffixIcon: controller.confirmPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  suffixIconOnTap: controller.toggleConfirmPassword,
                ),
                SizedBox(height: context.h(28)),
                AppButton(
                  buttonText: 'Save',
                  onPressed: controller.onSave,
                  buttonHeight: 54,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}