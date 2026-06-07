import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/home_20_controller.dart';
import '../widgets/auth_shared_widgets.dart';



class Home20Screen extends StatelessWidget {
  const Home20Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Home20Controller());

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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: controller.onClose,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cardBg,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(child: AuthTripNestWordmark()),
                const SizedBox(height: 32),
                _PlanCard(
                  emoji: '⭐',
                  title: 'Monthly',
                  description: 'Perfect for short-term travelers',
                  price: '\$4.99',
                  plan: PlanType.monthly,
                  selectedPlan: controller.selectedPlan.value,
                  onTap: () => controller.selectPlan(PlanType.monthly),
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  emoji: '🏆',
                  title: 'Quarterly',
                  description: 'Save more with 3-month access',
                  price: '\$13.99',
                  plan: PlanType.quarterly,
                  selectedPlan: controller.selectedPlan.value,
                  onTap: () => controller.selectPlan(PlanType.quarterly),
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  emoji: '👑',
                  title: 'Annual',
                  description: 'Full-year access with premium benefits',
                  price: '\$49.99',
                  plan: PlanType.annual,
                  selectedPlan: controller.selectedPlan.value,
                  onTap: () => controller.selectPlan(PlanType.annual),
                  badge: 'Save \$9.99',
                ),
                const Spacer(),
                AppButton(
                  buttonText: 'Next',
                  onPressed: controller.onNext,
                  buttonHeight: 54,
                ),
                const SizedBox(height: 12),
                Center(
                  child: AppText(
                    data: 'Enjoy 3 days free, then \$49 per year',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.price,
    required this.plan,
    required this.selectedPlan,
    required this.onTap,
    this.badge,
  });

  final String emoji;
  final String title;
  final String description;
  final String price;
  final PlanType plan;
  final PlanType selectedPlan;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isSelected = plan == selectedPlan;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
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
                      const SizedBox(height: 2),
                      AppText(
                        data: description,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                AppText(
                  data: price,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -10,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: AppText(
                  data: badge!,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}