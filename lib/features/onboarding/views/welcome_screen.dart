import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/buttons/social_login_buttons.dart';
import '../../../core/widgets/text/app_text.dart';

class WelcomeController extends GetxController {
  void onContinueWithEmail() => Get.toNamed('/login');
  void onContinueWithGoogle() {}
  void onTermsTap() => Get.toNamed('/terms');
  void onPrivacyTap() => Get.toNamed('/privacy');
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WelcomeController());

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/icons/app_logo.png',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 20),
                        const _TripNestWordmark(),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SocialButton(
                      onTap: controller.onContinueWithEmail,
                      text: 'Continue With Email',
                      iconPath: 'assets/images/icons/gmail.png',
                      height: 54,
                    ),
                    const SizedBox(height: 14),
                    SocialButton(
                      onTap: controller.onContinueWithGoogle,
                      text: 'Continue With Google',
                      iconPath: 'assets/images/icons/google.png',
                      height: 54,
                    ),
                    const SizedBox(height: 20),
                    _LegalText(
                      onTermsTap: controller.onTermsTap,
                      onPrivacyTap: controller.onPrivacyTap,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _TripNestWordmark extends StatelessWidget {
  const _TripNestWordmark();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return RichText(
        text: TextSpan(
          style: GoogleFonts.jost(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: 'Trip',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            TextSpan(
              text: 'Nest',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      );
    });
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({required this.onTermsTap, required this.onPrivacyTap});
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.jost(
            color: AppColors.textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            const TextSpan(
                text: 'By continuing with any account, you agree to our '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: onTermsTap,
                child: AppText(
                  data: 'Terms & Conditions',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textSecondary,
                  googleFontFamily: GoogleFonts.jost,
                ),
              ),
            ),
            const TextSpan(text: ' and '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: onPrivacyTap,
                child: AppText(
                  data: 'Privacy Policy',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textSecondary,
                  googleFontFamily: GoogleFonts.jost,
                ),
              ),
            ),
            const TextSpan(text: ' of our app.'),
          ],
        ),
      );
    });
  }
}