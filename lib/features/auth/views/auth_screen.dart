import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/features/auth/views/sign_in_screen.dart';
import 'package:travel_planner/features/auth/views/sign_up_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

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
                AuthTabBar(
                  isLogin: controller.isLoginTab.value,
                  onLoginTap: controller.switchToLogin,
                  onSignUpTap: controller.switchToSignUp,
                ),
                const SizedBox(height: 28),
                if (controller.isLoginTab.value)
                  SignInForm()
                else
                  SignUpForm(),
              ],
            ),
          ),
        ),
      );
    });
  }
}