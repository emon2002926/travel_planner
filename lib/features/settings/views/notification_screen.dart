import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

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
                      onTap: () {Navigator.pop(context);},
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: 'Notification',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                   ),
                  ],
                ),
              ),
              SizedBox(height: context.h(16)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: Container(
                  height: context.h(48),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: Row(
                    children: [
                      _NotifTab(
                        label: 'All',
                        isActive: controller.showAll.value,
                        onTap: () => controller.switchTab(true),
                      ),
                      _NotifTab(
                        label: 'Unread',
                        isActive: !controller.showAll.value,
                        onTap: () => controller.switchTab(false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.h(16)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: context.w(24)),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(context.w(14)),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: AppColors.inputBorder,
                    ),
                    itemBuilder: (_, index) {
                      final item = controller.notifications[index];
                      return Padding(
                        padding: EdgeInsets.all(context.w(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: context.w(44),
                              height: context.w(44),
                              decoration: BoxDecoration(
                                color: item.iconBgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.icon,
                                  color: item.iconColor,
                                  size: context.sp(20)),
                            ),
                            SizedBox(width: context.w(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    data: item.message,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                  SizedBox(height: context.h(4)),
                                  AppText(
                                    data: item.time,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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

class _NotifTab extends StatelessWidget {
  const _NotifTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(context.w(4)),
          decoration: BoxDecoration(
            color: isActive ? AppColors.tabSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(context.w(8)),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ]
                : null,
          ),
          alignment: Alignment.center,
          child: AppText(
            data: label,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}