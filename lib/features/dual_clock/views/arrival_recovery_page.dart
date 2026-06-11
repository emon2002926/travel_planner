import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';

class _RecoveryTip {
  final String emoji;
  final String title;
  final String subtitle;
  const _RecoveryTip({required this.emoji, required this.title, required this.subtitle});
}

class ArrivalRecoveryPage extends StatelessWidget {
  const ArrivalRecoveryPage({super.key});

  static const _tips = [
    _RecoveryTip(emoji: '☀️', title: 'GET SUNLIGHT',    subtitle: 'Spend time outdoors to reset your body clock'),
    _RecoveryTip(emoji: '💧', title: 'STAY HYDRATED',   subtitle: 'Drink plenty of water'),
    _RecoveryTip(emoji: '🥱', title: 'SMART SLEEP',     subtitle: 'Avoid long naps, sleep at local night time'),
    _RecoveryTip(emoji: '🍴', title: 'EAT LOCAL TIME',  subtitle: 'Follow destination meal schedule'),
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
              _ArrivalHeader(),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(context.w(16), context.h(16), context.w(16), context.h(32)),
                  itemCount: _tips.length,
                  separatorBuilder: (_, _) => SizedBox(height: context.h(14)),
                  itemBuilder: (context, i) => _TipCard(tip: _tips[i]),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ArrivalHeader extends StatelessWidget {
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
          AppText(data: 'Arrival Recovery', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final _RecoveryTip tip;
  const _TipCard({required this.tip});

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
          Row(
            children: [
              Text(tip.emoji, style: TextStyle(fontSize: context.sp(18))),
              SizedBox(width: context.w(6)),
              AppText(data: tip.title, fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ],
          ),
          SizedBox(height: context.h(6)),
          AppText(data: tip.subtitle, fontSize: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
