import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/dual_clock_controller.dart';
import 'jet_lag_page.dart';

class DualClockPage extends StatelessWidget {
  const DualClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DualClockController>()) {
      Get.put(DualClockController());
    }
    final controller = Get.find<DualClockController>();

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
              _DualClockHeader(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                  child: Column(
                    children: [
                      SizedBox(height: context.h(16)),
                      _FormatToggle(controller: controller),
                      SizedBox(height: context.h(20)),
                      _ClockCard(controller: controller),
                    ],
                  ),
                ),
              ),
              _PrimaryButton(
                label: 'Jet Lag Preparation Plan',
                onTap: () => Get.to(() => const JetLagPage()),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DualClockHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          AppText(data: 'Dual Clock Screen', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _FormatToggle extends StatelessWidget {
  final DualClockController controller;
  const _FormatToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ToggleChip(label: '12-HOUR', selected: controller.is12Hour.value,  onTap: () => controller.is12Hour.value = true),
        SizedBox(width: context.w(20)),
        _ToggleChip(label: '24-HOUR', selected: !controller.is12Hour.value, onTap: () => controller.is12Hour.value = false),
      ],
    ));
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(22), vertical: context.h(10)),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(8)),
          border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder),
        ),
        child: AppText(
          data: label,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  final DualClockController controller;
  const _ClockCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Obx(() => Column(
        children: [
          Row(
            children: [
              Expanded(child: _ClockColumn(
                cityLabel: controller.homeCityLabel,
                time: controller.formatTime(controller.homeTime),
                amPm: controller.amPm(controller.homeTime),
                show12Hour: controller.is12Hour.value,
                onChangeTap: () => _showZonePicker(context, controller, isHome: true),
              )),
              Container(width: 1, height: context.h(80), color: AppColors.inputBorder),
              Expanded(child: _ClockColumn(
                cityLabel: controller.destCityLabel,
                time: controller.formatTime(controller.destTime),
                amPm: controller.amPm(controller.destTime),
                show12Hour: controller.is12Hour.value,
                onChangeTap: () => _showZonePicker(context, controller, isHome: false),
              )),
            ],
          ),
          SizedBox(height: context.h(16)),
          Divider(color: AppColors.inputBorder, height: 1),
          SizedBox(height: context.h(12)),
          AppText(
            data: controller.diffLabel,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }

  void _showZonePicker(BuildContext context, DualClockController controller, {required bool isHome}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _ZonePickerSheet(controller: controller, isHome: isHome),
    );
  }
}

class _ClockColumn extends StatelessWidget {
  final String cityLabel;
  final String time;
  final String amPm;
  final bool show12Hour;
  final VoidCallback onChangeTap;
  const _ClockColumn({
    required this.cityLabel,
    required this.time,
    required this.amPm,
    required this.show12Hour,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText(data: cityLabel, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        SizedBox(height: context.h(6)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(data: time, fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.primary),
            if (show12Hour) ...[
              SizedBox(width: context.w(4)),
              Padding(
                padding: EdgeInsets.only(bottom: context.h(6)),
                child: AppText(data: amPm, fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ],
        ),
        SizedBox(height: context.h(8)),
        GestureDetector(
          onTap: onChangeTap,
          child: AppText(data: 'CHANGE', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ZonePickerSheet extends StatelessWidget {
  final DualClockController controller;
  final bool isHome;
  const _ZonePickerSheet({required this.controller, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.w(20), context.h(24), context.w(20), context.h(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: isHome ? 'Select Home Timezone' : 'Select Destination Timezone', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            SizedBox(height: context.h(16)),
            ...DualClockController.zones.map((z) => GestureDetector(
              onTap: () {
                isHome ? controller.setHomeZone(z) : controller.setDestZone(z);
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: context.h(10)),
                padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(context.w(12)),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    Expanded(child: AppText(data: z.city, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    AppText(data: z.label, fontSize: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
            )),
          ],
        ),
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
