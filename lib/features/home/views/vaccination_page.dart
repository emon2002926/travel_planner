import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/settings/views/notification_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/vaccination_controller.dart';


class VaccinationPage extends StatelessWidget {
  const VaccinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VaccinationController>()) {
      Get.put(VaccinationController());
    }
    final controller = Get.find<VaccinationController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: BuildAppBar(
          title: 'Vaccination Tracking',
          titleFontSize: 20,
          fontWeight: FontWeight.w700,
          titleColor: AppColors.textPrimary,
          iconColor: AppColors.textPrimary,
          backgroundColor: AppColors.scaffoldBg,
          showBackButton: true,
          sideButtonIcon: Icons.notifications_outlined,
          onSideButtonPressed: () {
            AppNavigation.push(NotificationScreen(),context:context);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.w(16), context.h(20),
                  context.w(16), context.h(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Vaccine Name',
                      hintText: 'Corona -1',
                      controller: controller.nameController,
                    ),
                    SizedBox(height: context.h(20)),
                    AppTextField(
                      label: 'Dose Number',
                      hintText: '1st',
                      controller: controller.doseController,
                    ),
                    SizedBox(height: context.h(20)),
                    AppText(
                      data: 'Vaccination Date',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: context.h(8)),
                    Obx(() => _DateField(
                      onTap: () => controller.pickVaccinationDate(context),
                      dateValue: controller.vaccinationDate.value,
                      formatDate: controller.formatDate,
                    )),
                    SizedBox(height: context.h(20)),
                    AppText(
                      data: 'Next Dose Date (if applicable)',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: context.h(8)),
                    Obx(() => _DateField(
                      onTap: () => controller.pickNextDoseDate(context),
                      dateValue: controller.nextDoseDate.value,
                      formatDate: controller.formatDate,
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(16), context.h(8),
                context.w(16), context.h(24),
              ),
              child: AppButton(
                buttonText: 'Save',
                onPressed: (){controller.save(context);},
                borderRadius: 50,
                buttonHeight: 56,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DateField extends StatelessWidget {
  final VoidCallback onTap;
  final DateTime? dateValue;
  final String Function(DateTime) formatDate;
  const _DateField({required this.onTap, required this.dateValue, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(16)),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(context.w(10)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                data: dateValue != null ? formatDate(dateValue!) : 'Select Date',
                fontSize: 14,
                color: dateValue != null ? AppColors.textPrimary : AppColors.inputHint,
              ),
            ),
            Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: context.sp(22)),
          ],
        ),
      ),
    );
  }
}