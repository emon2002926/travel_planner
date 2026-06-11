import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/forgot_password_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

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
                  data: 'Forget Password',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Email Addess',
                  controller: controller.emailController,
                  hintText: 'Rhebhek@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 28),
                AppButton(
                  buttonText: 'Send OTP',
                  onPressed: controller.onSendOtp,
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