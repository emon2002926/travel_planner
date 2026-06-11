import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/faqs_controller.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaqsController());

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
              SizedBox(height: context.h(16)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: "FAQ's",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(20)),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  itemCount: controller.faqs.length,
                  separatorBuilder: (_, _) => SizedBox(height: context.h(12)),
                  itemBuilder: (_, index) {
                    final faq = controller.faqs[index];
                    return Obx(
                          () => GestureDetector(
                        onTap: () => controller.toggle(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.w(16),
                              vertical: context.h(16)),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius:
                            BorderRadius.circular(context.w(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppText(
                                  data: faq.question,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Icon(
                                faq.isExpanded.value
                                    ? Icons.remove
                                    : Icons.add,
                                color: AppColors.primary,
                                size: context.sp(20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      );
    });
  }
}
