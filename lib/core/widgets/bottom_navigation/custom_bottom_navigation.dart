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
  final VoidCallback? onSupportPressed;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.onSupportPressed,
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

      final Color barColor = isDark ? AppColors.navBg : Colors.white;
      final Color activeColor =
      isDark ? AppColors.primaryLight : AppColors.primary;
      final Color inactiveColor = AppColors.navInactive;
      final Color centerCircleColor =
      isDark ? AppColors.iconBg : const Color(0xFFF1F2F4);

      final leftItems = [
        {
          'activeIcon': Icons.home,
          'icon': Icons.home_outlined,
          'label': 'Home',
          'index': 0,
        },
        {
          'activeIcon': Icons.luggage,
          'icon': Icons.luggage_outlined,
          'label': 'Trips',
          'index': 1,
        },
      ];

      final rightItems = [
        {
          'activeIcon': Icons.verified_user,
          'icon': Icons.shield_outlined,
          'label': 'Safety',
          'index': 3,
        },
        {
          'activeIcon': Icons.more_horiz,
          'icon': Icons.more_horiz,
          'label': 'More',
          'index':4,
        },
      ];

      Widget buildItem(Map<String, dynamic> item) {
        final int index = item['index'] as int;
        final bool isSelected = currentIndex == index;
        final IconData icon = isSelected
            ? item['activeIcon'] as IconData
            : item['icon'] as IconData;
        final String label = item['label'] as String;

        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: context.sp(26),
                  color: isSelected ? activeColor : inactiveColor,
                ),
                SizedBox(height: context.h(4)),
                AppText(
                  data: label,
                  fontSize: 13,
                  googleFontFamily: GoogleFonts.jost,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ],
            ),
          ),
        );
      }

      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: context.w(16),
            right: context.w(16),
            top: context.h(26),
            bottom: context.h(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: context.h(68),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(context.w(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    buildItem(leftItems[0]),
                    buildItem(leftItems[1]),
                    SizedBox(width: context.w(64)),
                    buildItem(rightItems[0]),
                    buildItem(rightItems[1]),
                  ],
                ),
              ),
              Positioned(
                top: -context.h(22),
                child: GestureDetector(
                  onTap: onSupportPressed,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: context.w(62),
                    height: context.w(62),
                    decoration: BoxDecoration(
                      color: centerCircleColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: barColor,
                        width: context.w(5),
                      ),
                    ),
                    child: Icon(
                      Icons.headset_mic,
                      size: context.sp(28),
                      color: activeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}