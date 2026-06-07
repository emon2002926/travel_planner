import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/change_pin_controller.dart';

class ChangePinScreen extends StatelessWidget {
  const ChangePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePinController());

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
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(16)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: 'Change PIN',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: context.h(28)),
                _PinRow(
                  label: 'Current PIN',
                  controllers: controller.currentPinControllers,
                  focusNodes: controller.currentFocusNodes,
                  onChanged: (v, i) =>
                      controller.onChanged(v, i, controller.currentFocusNodes),
                ),
                SizedBox(height: context.h(20)),
                _PinRow(
                  label: 'New PIN',
                  controllers: controller.newPinControllers,
                  focusNodes: controller.newFocusNodes,
                  onChanged: (v, i) =>
                      controller.onChanged(v, i, controller.newFocusNodes),
                ),
                SizedBox(height: context.h(20)),
                _PinRow(
                  label: 'Re Type PIN',
                  controllers: controller.retypePinControllers,
                  focusNodes: controller.retypeFocusNodes,
                  onChanged: (v, i) =>
                      controller.onChanged(v, i, controller.retypeFocusNodes),
                ),
                SizedBox(height: context.h(28)),
                AppButton(
                  buttonText: 'Save',
                  onPressed: controller.onSave,
                  buttonHeight: 54,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _PinRow extends StatelessWidget {
  const _PinRow({
    required this.label,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });
  final String label;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String, int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
                (index) => SizedBox(
              width: context.w(58),
              child: AppTextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                hintText: '-',
                keyboardType: TextInputType.number,
                isHintTextInMiddle: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}