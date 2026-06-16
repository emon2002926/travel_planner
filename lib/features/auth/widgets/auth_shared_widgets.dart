import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/text/app_text.dart';

class AuthTripNestWordmark extends StatelessWidget {
  const AuthTripNestWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return RichText(
        text: TextSpan(
          style: GoogleFonts.jost(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: 'Trip',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            TextSpan(
              text: 'Nest',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      );
    });
  }
}

class AuthTabBar extends StatelessWidget {
  const AuthTabBar({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onSignUpTap,
  });
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.tabUnselected,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AuthTabItem(
              label: 'Log In',
              isActive: isLogin,
              onTap: onLoginTap,
            ),
            AuthTabItem(
              label: 'Sign Up',
              isActive: !isLogin,
              onTap: onSignUpTap,
            ),
          ],
        ),
      );
    });
  }
}

class AuthTabItem extends StatelessWidget {
  const AuthTabItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.tabSelected : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive
                    ? AppColors.borderColor
                    : AppColors.tabUnselected,
                width: 1,
              ),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
            alignment: Alignment.center,
            child: AppText(
              data: label,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              googleFontFamily: GoogleFonts.jost,
            ),
          ),
        ),
      );
    });
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.jost(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.jost(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}