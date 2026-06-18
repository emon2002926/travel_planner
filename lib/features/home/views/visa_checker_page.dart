
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/settings/views/notification_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/visa_checker_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/settings/views/notification_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/visa_checker_controller.dart';

class VisaCheckerPage extends StatelessWidget {
  const VisaCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VisaCheckerController>()) {
      Get.put(VisaCheckerController());
    }
    final controller = Get.find<VisaCheckerController>();

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
              _VisaHeader(),
              Expanded(
                child: Obx(() {
                  switch (controller.state.value) {
                    case VisaCheckState.idle:
                      return _IdleBody(controller: controller);
                    case VisaCheckState.loading:
                      return _LoadingBody();
                    case VisaCheckState.result:
                      return _ResultBody(controller: controller);
                  }
                }),
              ),
              Obx(() {
                switch (controller.state.value) {
                  case VisaCheckState.idle:
                    return _PrimaryButton(
                      label: 'Visa Check',
                      onTap: controller.checkVisa,
                    );
                  case VisaCheckState.loading:
                    return _PrimaryButton(label: 'Checking...', onTap: null);
                  case VisaCheckState.result:
                    return _PrimaryButton(
                      label: 'Check Again',
                      onTap: controller.checkAgain,
                    );
                }
              }),
            ],
          ),
        ),
      );
    });
  }
}

class _VisaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: AppText(
              data: 'Visa Checker',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {
              AppNavigation.push(NotificationScreen(), context: context);
            },
            child: Container(
              width: context.w(44),
              height: context.w(44),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: context.sp(22)),
                  Positioned(
                    top: context.h(10),
                    right: context.w(10),
                    child: Container(
                      width: context.w(7),
                      height: context.w(7),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
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

class _IdleBody extends StatelessWidget {
  final VisaCheckerController controller;
  const _IdleBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Choose File',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.h(10)),
          GestureDetector(
            onTap: controller.pickFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(10)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(10)),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(context.w(8)),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: AppText(data: 'Choose your file', fontSize: 14, color: AppColors.textPrimary),
                  ),
                  SizedBox(width: context.w(12)),
                  Obx(() => controller.hasFile
                      ? Expanded(
                    child: AppText(
                      data: controller.fileName.value,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  )
                      : const SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(height: context.h(20)),
          AppText(data: 'Checking your visa...', fontSize: 15, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  final VisaCheckerController controller;
  const _ResultBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isOk = controller.status.value == VisaStatus.ok;
    final statusColor = isOk ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Column(
      children: [
        const Spacer(),
        _CheckmarkCharacter(),
        SizedBox(height: context.h(32)),
        _StatusLine(label: 'Visa Status', value: controller.statusLabel, valueColor: statusColor),
        SizedBox(height: context.h(12)),
        _StatusLine(label: 'Visa End Time', value: controller.visaEndDate.value, valueColor: statusColor),
        const Spacer(),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatusLine({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(data: '$label : ', fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        AppText(data: value, fontSize: 17, fontWeight: FontWeight.w700, color: valueColor),
      ],
    );
  }
}

class _CheckmarkCharacter extends StatefulWidget {
  @override
  State<_CheckmarkCharacter> createState() => _CheckmarkCharacterState();
}

class _CheckmarkCharacterState extends State<_CheckmarkCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Image.asset(
        'assets/images/visa_check.png',
        width: context.w(400),
        height: context.w(400),
        fit: BoxFit.contain,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(18)),
          decoration: BoxDecoration(
            color: onTap != null ? AppColors.primary : AppColors.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(context.w(50)),
          ),
          alignment: Alignment.center,
          child: AppText(data: label, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}