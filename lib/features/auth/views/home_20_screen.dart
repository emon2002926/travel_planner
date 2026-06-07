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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: controller.onDismiss,
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
                          Expanded(
                            child: Center(child: const AuthTripNestWordmark()),
                          ),
                          const SizedBox(width: 36),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AppText(
                        data: 'Upgrade to access premium features',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: 20),
                      ...plans.map(
                            (plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PlanCard(
                            data: plan,
                            selectedPlan: controller.selectedPlan.value,
                            onTap: () => controller.selectPlan(plan.plan),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: AppButton(
                  buttonText: 'Next',
                  onPressed: controller.onNext,
                  buttonHeight: 54,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.data,
    required this.selectedPlan,
    required this.onTap,
  });

  final PlanData data;
  final PlanType selectedPlan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = data.plan == selectedPlan;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          data.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        data: data.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (data.price != null)
                      AppText(
                        data: data.price!,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ...data.features.map(
                      (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          feature.included
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 18,
                          color: feature.included
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppText(
                            data: feature.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (data.badge != null)
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
                  data: data.badge!,
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