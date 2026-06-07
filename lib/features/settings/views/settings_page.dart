import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

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
            padding: EdgeInsets.symmetric(horizontal: context.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    AppText(
                      data: 'Home',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    GestureDetector(
                      onTap: controller.onNotificationTap,
                      child: Container(
                        width: context.w(40),
                        height: context.w(40),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(Icons.notifications_outlined,
                                  color: AppColors.textPrimary,
                                  size: context.sp(20)),
                            ),
                            Positioned(
                              top: context.h(8),
                              right: context.w(8),
                              child: Container(
                                width: context.w(8),
                                height: context.w(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Container(
                  padding: EdgeInsets.all(context.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(context.w(16)),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://i.pravatar.cc/150',
                          width: context.w(52),
                          height: context.w(52),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: context.w(14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              data: 'Kurt Cobain',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            SizedBox(height: context.h(2)),
                            AppText(
                              data: 'Kurtcobain@email.com',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onProfileArrowTap,
                        child: Container(
                          width: context.w(40),
                          height: context.w(40),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward,
                              color: Colors.white, size: context.sp(18)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.h(20)),
                _SettingsSection(
                  title: 'Profile',
                  children: [
                    _SettingsNavItem(
                      label: 'Profile Update',
                      onTap: controller.onProfileUpdate,
                    ),
                    _SettingsToggleItem(
                      label: 'Dark Mode',
                      value: controller.isDarkMode.value,
                      onChanged: controller.toggleDarkMode,
                    ),
                  ],
                ),
                SizedBox(height: context.h(16)),
                _SettingsSection(
                  title: 'Account',
                  children: [
                    _SettingsNavItem(
                      label: 'Change Password',
                      onTap: controller.onChangePassword,
                    ),
                    _SettingsNavItem(
                      label: 'Change PIN',
                      onTap: controller.onChangePIN,
                    ),
                    _SettingsNavItem(
                      label: 'Delete Account',
                      onTap: controller.onDeleteAccount,
                    ),
                  ],
                ),
                SizedBox(height: context.h(16)),
                _SettingsSection(
                  title: 'More',
                  children: [
                    _SettingsToggleItem(
                      label: 'Notification Preferences',
                      value: controller.notificationsEnabled.value,
                      onChanged: controller.toggleNotifications,
                    ),
                    _SettingsNavItem(
                      label: 'Terms & Conditions',
                      onTap: controller.onTermsAndConditions,
                    ),
                    _SettingsNavItem(
                      label: 'Privacy Policy',
                      onTap: controller.onPrivacyPolicy,
                    ),
                    _SettingsNavItem(
                      label: "Faq's",
                      onTap: controller.onFaqs,
                    ),
                  ],
                ),
                SizedBox(height: context.h(32)),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: title,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: context.h(12)),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  const _SettingsNavItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(8)),
        padding: EdgeInsets.symmetric(
            horizontal: context.w(14), vertical: context.h(14)),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(context.w(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              data: label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: context.sp(20)),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  const _SettingsToggleItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(8)),
      padding: EdgeInsets.symmetric(
          horizontal: context.w(14), vertical: context.h(10)),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(context.w(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            data: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}