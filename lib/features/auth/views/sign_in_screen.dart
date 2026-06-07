import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_planner/core/widgets/buttons/app_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/social_login_buttons.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/sign_in_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Email Address',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            googleFontFamily: GoogleFonts.jost,
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: controller.emailController,
            hintText: 'Rhebhek@gmail.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                data: 'Password',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                googleFontFamily: GoogleFonts.jost,
              ),
              GestureDetector(
                onTap: controller.onForgotPassword,
                child: AppText(
                  data: 'Forgot Password',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  googleFontFamily: GoogleFonts.jost,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: controller.passwordController,
            hintText: '********',
            obscureText: !controller.passwordVisible.value,
            suffixIcon: controller.passwordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconOnTap: controller.togglePassword,
          ),
          if (controller.errorMessage.value.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.red, size: 16),
                const SizedBox(width: 6),
                AppText(
                  data: controller.errorMessage.value,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                  googleFontFamily: GoogleFonts.jost,
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          AppButton(
            buttonText: 'Sign in',
            onPressed: controller.onSignIn,
            buttonHeight: 54,
          ),
          const SizedBox(height: 24),
        ],
      );
    });
  }
}