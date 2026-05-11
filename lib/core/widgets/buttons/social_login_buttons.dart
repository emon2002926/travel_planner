import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/screen_size.dart';
import '../text/app_text.dart';

import 'package:get/get.dart';
import 'package:travel_planner/core/constants/app_colors.dart';
import 'package:travel_planner/core/themes/theme_controller.dart';


class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? iconPath;
  final IconData? icon;
  final double height;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.text,
    this.iconPath,
    this.icon,
    required this.height,
  }) : assert(
  iconPath != null || icon != null,
  'Provide either iconPath or icon',
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      final Color bgColor =
      tc?.isActuallyDark == true ? AppColors.cardBg : const Color(0xFFE8E5DF);

      final Color iconColor =
      tc?.isActuallyDark == true ? AppColors.textPrimary : Colors.black;

      final Color textColor =
      tc?.isActuallyDark == true ? AppColors.textSecondary : const Color(0xFF555555);

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: context.responsiveSize(height),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
            BorderRadius.circular(context.responsiveSize(28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null)
                SizedBox(
                  width: context.responsiveSize(24),
                  height: context.responsiveSize(24),
                  child: Image.asset(
                    iconPath!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Text(
                      'G',
                      style: TextStyle(
                        fontSize: context.responsiveSize(20),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4285F4),
                      ),
                    ),
                  ),
                )
              else if (icon != null)
                Icon(
                  icon,
                  color: iconColor,
                  size: context.responsiveSize(24),
                ),
              SizedBox(width: context.responsiveSize(12)),
              AppText(
                data: text,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
                useResponsiveFontSize: true,
                googleFontFamily: GoogleFonts.jost,
              ),
            ],
          ),
        ),
      );
    });
  }
}