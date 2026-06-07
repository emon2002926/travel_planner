import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LegalScreen(title: 'Privacy Policy');
  }
}

class _LegalScreen extends StatelessWidget {
  const _LegalScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.h(16)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: title,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(20)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data:
                        'This Privacy Policy describes how we collect, use, and protect your information when you use our Money Management App ("we," "our," or "us"). By using the app, you agree to this policy.',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: context.h(20)),
                      _LegalSection(
                        heading: 'Information We Collect',
                        bullets: [
                          'Personal details such as your name, email, and phone number.',
                          'Financial data you enter manually, such as income, expenses, and savings goals.',
                          'Device information (for performance and analytics).',
                        ],
                      ),
                      _LegalSection(
                        heading: 'How We Use Your Data',
                        bullets: [
                          'To track and visualize your spending and income.',
                          'To personalize insights, reminders, and budgeting tips.',
                          'To improve app performance and user experience.',
                        ],
                      ),
                      _LegalSection(
                        heading: 'Data Security',
                        body:
                        'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
                      ),
                      _LegalSection(
                        heading: 'Third-Party Services',
                        body:
                        'Some app features may integrate with secure third-party services (like Google or Apple Sign-In). We never share your financial data without your consent.',
                      ),
                      SizedBox(height: context.h(32)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.heading, this.bullets, this.body});
  final String heading;
  final List<String>? bullets;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: heading,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(8)),
        if (bullets != null)
          ...bullets!.map(
                (b) => Padding(
              padding: EdgeInsets.only(bottom: context.h(4)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: '• ',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                  Expanded(
                    child: AppText(
                      data: b,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (body != null)
          AppText(
            data: body!,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}