import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/packing_templates_controller.dart';

class PackingTemplatesPage extends StatelessWidget {
  const PackingTemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PackingTemplatesController>()) {
      Get.put(PackingTemplatesController());
    }
    final controller = Get.find<PackingTemplatesController>();

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
              _TemplatesHeader(),
              SizedBox(height: context.h(12)),
              _FilterChips(controller: controller),
              SizedBox(height: context.h(16)),
              Expanded(
                child: Obx(() {
                  final items = controller.filtered;
                  if (items.isEmpty) {
                    return Center(
                      child: AppText(data: 'No templates found.', fontSize: 15, color: AppColors.textSecondary),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: context.h(14)),
                    itemBuilder: (_, i) => _TemplateCard(template: items[i], controller: controller),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _TemplatesHeader extends StatelessWidget {
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
          Expanded(
            child: AppText(data: 'Packing Templates', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          Container(
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
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final PackingTemplatesController controller;
  const _FilterChips({required this.controller});

  static const _filters = [
    (label: 'All Template', value: TemplateFilter.all),
    (label: 'Mine',         value: TemplateFilter.mine),
    (label: 'AI Generated', value: TemplateFilter.aiGenerated),
    (label: 'System',       value: TemplateFilter.system),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Obx(() => Row(
        children: _filters.map((f) {
          final selected = controller.activeFilter.value == f.value;
          return GestureDetector(
            onTap: () => controller.setFilter(f.value),
            child: Container(
              margin: EdgeInsets.only(right: context.w(8)),
              padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(50)),
                border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder),
              ),
              child: AppText(
                data: f.label,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          );
        }).toList(),
      )),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final PackingTemplate template;
  final PackingTemplatesController controller;
  const _TemplateCard({required this.template, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Expanded(
                child: AppText(
                  data: '${template.title} · ${template.days} days',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: context.w(12)),
              GestureDetector(
                onTap: () => controller.useTemplate(template.id),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(10)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: AppText(data: 'Use', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          Row(
            children: [
              AppText(data: '${template.itemCount} item', fontSize: 13, color: AppColors.textSecondary),
              Container(
                width: context.w(4), height: context.w(4),
                margin: EdgeInsets.symmetric(horizontal: context.w(8)),
                decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.5), shape: BoxShape.circle),
              ),
              AppText(data: '${template.avgDays} days avg', fontSize: 13, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: context.h(12)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(6),
            children: template.tags.map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(6)),
              decoration: BoxDecoration(
                color: tag.isHighlighted ? const Color(0xFFDCFCE7) : AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(context.w(50)),
                border: Border.all(
                  color: tag.isHighlighted ? const Color(0xFF16A34A).withOpacity(0.3) : AppColors.inputBorder,
                ),
              ),
              child: AppText(
                data: tag.label,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: tag.isHighlighted ? const Color(0xFF16A34A) : AppColors.textSecondary,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
