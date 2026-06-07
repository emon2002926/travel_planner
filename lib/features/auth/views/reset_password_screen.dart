
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Center(child: AuthTripNestWordmark()),
                const SizedBox(height: 32),
                AppText(
                  data: 'Reset Your Password',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Password',
                  controller: controller.passwordController,
                  hintText: '********',
                  obscureText: !controller.passwordVisible.value,
                  suffixIcon: controller.passwordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  suffixIconOnTap: controller.togglePassword,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 28),
                AppButton(
                  buttonText: 'Confirm',
                  onPressed: controller.onConfirm,
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