import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
              _AppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.w(20),
                    context.h(8),
                    context.w(20),
                    context.h(40),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data:
                        'This Privacy Policy describes how we collect, use, and protect your information when you use our Travel Planner App ("we," "our," or "us"). By using the app, you agree to this policy.',
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        maxLines: 10,
                      ),
                      SizedBox(height: context.h(24)),
                      _PolicySection(
                        title: 'Information We Collect',
                        bullets: const [
                          'Personal details such as your name, email, and phone number.',
                          'Trip data you enter manually, such as destinations, itineraries, and budgets.',
                          'Device information (for performance and analytics).',
                        ],
                      ),
                      _PolicySection(
                        title: 'How We Use Your Data',
                        bullets: const [
                          'To track and manage your trips, packing lists, and expenses.',
                          'To personalize insights, reminders, and travel tips.',
                          'To improve app performance and user experience.',
                        ],
                      ),
                      _PolicySection(
                        title: 'Data Security',
                        body:
                        'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
                      ),
                      _PolicySection(
                        title: 'Third-Party Services',
                        body:
                        'Some app features may integrate with secure third-party services (like Google or Apple Sign-In). We never share your travel data without your consent.',
                      ),
                      _PolicySection(
                        title: 'Your Control',
                        body:
                        'You can delete your account and all associated data at any time from the Settings page. You may also request a copy of your data by contacting our support team.',
                      ),
                      _PolicySection(
                        title: 'Offline Vault',
                        body:
                        'Documents stored in your Offline Vault are encrypted locally on your device. We do not have access to vault contents and cannot recover them if your device is lost.',
                      ),
                      _PolicySection(
                        title: 'Children\'s Privacy',
                        body:
                        'Our app is not intended for children under 13. We do not knowingly collect data from children. If you believe a child has provided us with information, please contact us.',
                      ),
                      _PolicySection(
                        title: 'Changes to This Policy',
                        body:
                        'We may update this policy from time to time. We will notify you of significant changes via the app or email. Continued use of the app after changes constitutes acceptance.',
                      ),
                      _PolicySection(
                        title: 'Contact Us',
                        body:
                        'If you have any questions about this Privacy Policy, please reach out to us at privacy@travelplanner.app or through the Help & Support section in Settings.',
                      ),
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

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(8),
        vertical: context.h(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: context.sp(20),
              color: AppColors.textPrimary,
            ),
          ),
          AppText(
            data: 'Terms and Conditions',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String? body;
  final List<String>? bullets;

  const _PolicySection({
    required this.title,
    this.body,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: title,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            // googleFontFamily: FontStyle.italic,
          ),
          SizedBox(height: context.h(10)),
          if (body != null)
            AppText(
              data: body!,
              fontSize: 15,
              color: AppColors.textPrimary,
              maxLines: 10,
            ),
          if (bullets != null)
            ...bullets!.map(
                  (b) => Padding(
                padding: EdgeInsets.only(bottom: context.h(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.h(7),
                        right: context.w(10),
                        left: context.w(4),
                      ),
                      child: Container(
                        width: context.w(5),
                        height: context.w(5),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        data: b,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}