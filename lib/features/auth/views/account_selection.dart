import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/account_selection_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class AccountSelectionScreen extends StatelessWidget {
  const AccountSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountSelectionController());

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Center(child: AuthTripNestWordmark()),
                const SizedBox(height: 32),
                AppText(
                  data: 'Select who you are',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 24),
                _RoleCard(
                  title: 'Owner',
                  description:
                  'Create trips, manage team members, and edit all trip and backpack details',
                  role: UserRole.owner,
                  selectedRole: controller.selectedRole.value,
                  onTap: () => controller.selectRole(UserRole.owner),
                ),
                const SizedBox(height: 12),
                _RoleCard(
                  title: 'Editor',
                  description:
                  'Edit trip details, backpack items, and team information, but cannot create trips.',
                  role: UserRole.editor,
                  selectedRole: controller.selectedRole.value,
                  onTap: () => controller.selectRole(UserRole.editor),
                ),
                const SizedBox(height: 12),
                _RoleCard(
                  title: 'Viewer',
                  description:
                  'View trips, backpack details, and team updates without making any changes.',
                  role: UserRole.viewer,
                  selectedRole: controller.selectedRole.value,
                  onTap: () => controller.selectRole(UserRole.viewer),
                ),
                const Spacer(),
                AppButton(
                  buttonText: 'Next',
                  onPressed: controller.onNext,
                  buttonHeight: 54,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.role,
    required this.selectedRole,
    required this.onTap,
  });

  final String title;
  final String description;
  final UserRole role;
  final UserRole selectedRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = role == selectedRole;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: title,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    data: description,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}