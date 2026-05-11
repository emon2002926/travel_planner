import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../themes/theme_controller.dart';
import '../../util/screen_size.dart';
import 'package:get/get.dart';
import '../text/app_text.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      final bool isDark = tc?.isActuallyDark ?? false;

      final Color bgColor =
      isDark ? AppColors.navBg : const Color(0xFFF0EFE9);

      final Color borderColor =
      isDark ? AppColors.inputBorder : const Color(0xFFE0DDD7);

      final Color activeColor =
      isDark ? AppColors.navActive : const Color(0xFF3D7060);

      final Color inactiveColor =
      isDark ? AppColors.navInactive : const Color(0xFFB0ADA8);

      final items = [
        {'icon': Icons.home_outlined, 'label': 'Home'},
        {'icon': Icons.history_outlined, 'label': 'History'},
        {'icon': Icons.person_outline, 'label': 'Profile'},
        {'icon': Icons.settings_outlined, 'label': 'Settings'},
      ];

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: context.h(64),
            child: Row(
              children: List.generate(items.length, (index) {
                final isSelected = currentIndex == index;
                final label = items[index]['label'] as String;
                final icon = items[index]['icon'] as IconData;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: context.sp(24),
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                        SizedBox(height: context.h(4)),
                        AppText(
                          data: label,
                          fontSize: 13,
                          googleFontFamily: GoogleFonts.jost,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}