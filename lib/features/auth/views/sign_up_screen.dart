import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_planner/features/auth/controllers/sign_up_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/buttons/social_login_buttons.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../widgets/auth_shared_widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

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
          AppText(
            data: 'Password',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            googleFontFamily: GoogleFonts.jost,
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
          const SizedBox(height: 20),
          AppText(
            data: 'Re Type Password',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            googleFontFamily: GoogleFonts.jost,
          ),
          const SizedBox(height: 8),
          AppTextField(
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
            buttonText: 'Sign up',
            onPressed: controller.onSignUp,
            buttonHeight: 54,
          ),
          const SizedBox(height: 16),
          AppText(
            data: 'By clicking the "sign up" button, you accept the terms of the Privacy Policy.',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            googleFontFamily: GoogleFonts.jost,
          ),
          const SizedBox(height: 24),
        ],
      );
    });
  }
}