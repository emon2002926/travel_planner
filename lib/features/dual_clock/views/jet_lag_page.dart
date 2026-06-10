import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import 'arrival_recovery_page.dart';

class JetLagPlanDay {
  final String day;
  final List<String> tips;
  const JetLagPlanDay({required this.day, required this.tips});
}

class JetLagPage extends StatelessWidget {
  const JetLagPage({super.key});

  static const _plan = [
    JetLagPlanDay(day: 'DAY-1', tips: ['Sleep aligned with destination time']),
    JetLagPlanDay(day: 'DAY-3', tips: ['Sleep 1 hour earlier', 'Reduce caffeine']),
    JetLagPlanDay(day: 'DAY-2', tips: ['Shift meals earlier', 'Increase water intake']),
  ];

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
              _JetLagHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(context.w(16), context.h(16), context.w(16), context.h(32)),
                  child: Column(
                    children: [
                      _AiAssistantCard(),
                      SizedBox(height: context.h(14)),
                      ..._plan.map((d) => Padding(
                        padding: EdgeInsets.only(bottom: context.h(14)),
                        child: _DayCard(planDay: d),
                      )),
                    ],
                  ),
                ),
              ),
              _PrimaryButton(
                label: 'Arrival Recovery',
                onTap: () => Get.to(() => const ArrivalRecoveryPage()),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _JetLagHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          AppText(data: 'Jet Lag Preparation Plan', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _AiAssistantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined, color: AppColors.primary, size: context.sp(24)),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: 'AI Travel Assistant', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                SizedBox(height: context.h(3)),
                AppText(
                  data: 'Smart suggestions based on your trip and time zone"',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final JetLagPlanDay planDay;
  const _DayCard({required this.planDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: planDay.day, fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(10)),
          ...planDay.tips.map((tip) => Padding(
            padding: EdgeInsets.only(bottom: context.h(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: context.w(10),
                  height: context.w(10),
                  margin: EdgeInsets.only(right: context.w(12)),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
                Expanded(child: AppText(data: tip, fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(18)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(context.w(50)),
          ),
          alignment: Alignment.center,
          child: AppText(data: label, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
