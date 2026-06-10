import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../controllers/packing_templates_controller.dart';

class AddItemSheet extends StatelessWidget {
  final void Function(String name, String emoji, int qty, double? weight, bool isCritical) onSave;
  const AddItemSheet({super.key, required this.onSave});

  static void show(
    BuildContext context, {
    required void Function(String name, String emoji, int qty, double? weight, bool isCritical) onSave,
  }) {
    Get.find<PackingTemplatesController>().resetAddItem();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => AddItemSheet(onSave: onSave),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PackingTemplatesController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20), context.h(28),
        context.w(20), MediaQuery.of(context).viewInsets.bottom + context.h(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: 'Add Item', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(4)),
          AppText(data: 'You can add your item by filling this filled.', fontSize: 14, color: AppColors.textSecondary),
          SizedBox(height: context.h(20)),
          AppText(data: 'Item Name', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          SizedBox(height: context.h(8)),
          _InputField(controller: controller.nameController, hint: 'Type Here...'),
          SizedBox(height: context.h(16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(data: 'Emoji', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    SizedBox(height: context.h(8)),
                    _InputField(controller: controller.emojiController, hint: 'Add Emoji'),
                  ],
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(data: 'Quantity', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    SizedBox(height: context.h(8)),
                    _QuantitySelector(controller: controller),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          AppText(data: 'Item Weight (Per item)(Optional)', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          SizedBox(height: context.h(8)),
          _InputField(
            controller: controller.weightController,
            hint: 'Type Here...',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          ),
          SizedBox(height: context.h(16)),
          Obx(() => GestureDetector(
            onTap: () => controller.isCritical.value = !controller.isCritical.value,
            child: Row(
              children: [
                Container(
                  width: context.w(20),
                  height: context.w(20),
                  decoration: BoxDecoration(
                    color: controller.isCritical.value ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(context.w(4)),
                    border: Border.all(
                      color: controller.isCritical.value ? AppColors.primary : AppColors.inputBorder,
                      width: 1.5,
                    ),
                  ),
                  child: controller.isCritical.value
                      ? Icon(Icons.check, color: Colors.white, size: context.sp(14))
                      : null,
                ),
                SizedBox(width: context.w(10)),
                AppText(data: 'Mark as Critical', fontSize: 15, color: AppColors.textSecondary),
              ],
            ),
          )),
          SizedBox(height: context.h(22)),
          GestureDetector(
            onTap: () {
              final name = controller.nameController.text.trim();
              if (name.isEmpty) return;
              final weight = double.tryParse(controller.weightController.text.trim());
              onSave(name, controller.emojiController.text.trim(), controller.quantity.value, weight, controller.isCritical.value);
              Get.back();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: context.h(17)),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(context.w(50)),
              ),
              alignment: Alignment.center,
              child: AppText(data: 'Save', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(context.w(12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(fontSize: context.sp(15), color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: context.sp(15)),
          contentPadding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(14)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final PackingTemplatesController controller;
  const _QuantitySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(context.w(12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(14)),
              child: AppText(
                data: controller.quantity.value == 1 ? 'Select' : '${controller.quantity.value}',
                fontSize: 15,
                color: controller.quantity.value == 1 ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
          ),
          Container(width: 1, height: context.h(20), color: AppColors.inputBorder),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: controller.incrementQty,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(context.w(10), context.h(4), context.w(10), context.h(2)),
                  child: Icon(Icons.keyboard_arrow_up, size: context.sp(18), color: AppColors.textPrimary),
                ),
              ),
              GestureDetector(
                onTap: controller.decrementQty,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(context.w(10), context.h(2), context.w(10), context.h(4)),
                  child: Icon(Icons.keyboard_arrow_down, size: context.sp(18), color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
