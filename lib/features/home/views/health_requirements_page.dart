import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/health_requirements_controller.dart';

class HealthRequirementsPage extends StatelessWidget {
  const HealthRequirementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HealthRequirementsController>()) {
      Get.put(HealthRequirementsController());
    }
    final controller = Get.find<HealthRequirementsController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: BuildAppBar(
          title: 'Health Requirements',
          titleFontSize: 20,
          fontWeight: FontWeight.w700,
          titleColor: AppColors.textPrimary,
          iconColor: AppColors.textPrimary,
          backgroundColor: AppColors.scaffoldBg,
          showBackButton: true,
          showSideButton: true,
          sideButtonIcon: Icons.notifications_outlined,
          onSideButtonPressed: () {},
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.w(16), context.h(16),
                    context.w(16), context.h(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _VaccinationSection(controller: controller),
                      SizedBox(height: context.h(28)),
                      _MedicalConditionsSection(controller: controller),
                      SizedBox(height: context.h(28)),
                      _AllergiesSection(controller: controller),
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
                  onPressed: controller.save,
                  borderRadius: 50,
                  buttonHeight: 56,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


class _VaccinationSection extends StatelessWidget {
  final HealthRequirementsController controller;
  const _VaccinationSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: 'Vaccination Status', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        SizedBox(height: context.h(14)),
        AppText(data: 'Vaccine Name', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(10)),
        Obx(() => _YesNoRow(
          value: controller.isVaccinated.value,
          onChanged: (v) => controller.isVaccinated.value = v,
        )),
        SizedBox(height: context.h(16)),
        AppTextField(
          label: 'Dose Name',
          hintText: 'Corona -1',
          controller: controller.doseNameController,
        ),
        SizedBox(height: context.h(16)),
        AppTextField(
          label: 'Dose Completed',
          hintText: '1st',
          controller: controller.doseCompletedController,
        ),
        SizedBox(height: context.h(16)),
        AppText(data: 'Last Dose Date', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(8)),
        Obx(() => _DateField(
          onTap: () => controller.pickLastDoseDate(context),
          dateValue: controller.lastDoseDate.value,
          formatDate: controller.formatDate,
        )),
      ],
    );
  }
}



class _MedicalConditionsSection extends StatelessWidget {
  final HealthRequirementsController controller;
  const _MedicalConditionsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: 'Medical Conditions', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        SizedBox(height: context.h(14)),
        AppText(data: 'Do you have any existing conditions?', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        SizedBox(height: context.h(10)),
        Obx(() => _YesNoRow(
          value: controller.hasConditions.value,
          onChanged: (v) => controller.hasConditions.value = v,
        )),
        Obx(() {
          if (!controller.hasConditions.value) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(14)),
              AppText(data: 'If yes', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              SizedBox(height: context.h(10)),
              _ConditionsGrid(controller: controller),
            ],
          );
        }),
      ],
    );
  }
}

class _ConditionsGrid extends StatelessWidget {
  final HealthRequirementsController controller;
  const _ConditionsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final conditions = HealthRequirementsController.conditionOptions;
    final rows = <Widget>[];
    for (var i = 0; i < conditions.length; i += 2) {
      final left  = conditions[i];
      final right = i + 1 < conditions.length ? conditions[i + 1] : null;
      rows.add(Padding(
        padding: EdgeInsets.only(bottom: context.h(10)),
        child: Row(
          children: [
            Expanded(child: Obx(() => _RadioOption(
              label: left,
              selected: controller.selectedConditions.contains(left),
              onTap: () => controller.toggleCondition(left),
            ))),
            if (right != null)
              Expanded(child: Obx(() => _RadioOption(
                label: right,
                selected: controller.selectedConditions.contains(right),
                onTap: () => controller.toggleCondition(right),
              ))),
          ],
        ),
      ));
    }
    return Column(children: rows);
  }
}



class _AllergiesSection extends StatelessWidget {
  final HealthRequirementsController controller;
  const _AllergiesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: 'Allergies', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        SizedBox(height: context.h(14)),
        AppText(data: 'Any allergies?', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        SizedBox(height: context.h(10)),
        Obx(() => _YesNoRow(
          value: controller.hasAllergies.value,
          onChanged: (v) => controller.hasAllergies.value = v,
        )),
        Obx(() {
          if (!controller.hasAllergies.value) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(14)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(data: 'If yes', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: TextField(
                      controller: controller.allergyController,
                      style: TextStyle(fontSize: context.sp(14), color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'e.g., food, medicine',
                        hintStyle: TextStyle(color: AppColors.inputHint, fontSize: context.sp(14)),
                        border: const UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: context.h(6)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}



class _YesNoRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _YesNoRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RadioOption(label: 'Yes', selected: value,  onTap: () => onChanged(true)),
        SizedBox(width: context.w(32)),
        _RadioOption(label: 'No',  selected: !value, onTap: () => onChanged(false)),
      ],
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.w(22),
            height: context.w(22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            child: selected
                ? Container(
                    margin: EdgeInsets.all(context.w(3)),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: context.sp(11)),
                  )
                : null,
          ),
          SizedBox(width: context.w(8)),
          AppText(data: label, fontSize: 14, color: AppColors.textPrimary),
        ],
      ),
    );
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
