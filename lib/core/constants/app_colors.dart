import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../themes/theme_controller.dart';


class AppColors {
  AppColors._();

  static ThemeController? get _c =>
      GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;

  static bool get _dark {
    final controller = _c;
    if (controller == null) return false;
    return controller.isActuallyDark;
  }


  static Color get scaffoldBg =>
      _dark ? const Color(0xFF0A0F1E) : const Color(0xFFF2F4F7);

  static Color get surface =>
      _dark ? const Color(0xFF0F1729) : const Color(0xFFFFFFFF);

  static Color get cardBg =>
      _dark ? const Color(0xFF1A2540) : const Color(0xFFFFFFFF);

  static const Color primary      = Color(0xFF1C4DB8);
  static const Color primaryLight = Color(0xFF2E60CC);
  static const Color accent       = Color(0xFF4A90D9);

  static Color get tripCardBg =>
      _dark ? const Color(0xFF1E3A6E) : const Color(0xFF1C4DB8);



  static Color get borderColor =>
      _dark ? const Color(0xFFD9D9D9) : const Color(0xFF989898);

  static Color get textPrimary =>
      _dark ? const Color(0xFFFFFFFF) : const Color(0xFF111827);

  static Color get textSecondary =>
      _dark ? const Color(0xFF8FA3C8) : const Color(0xFF6B7280);

  static Color get textHint =>
      _dark ? const Color(0xFF4A5E80) : const Color(0xFF9CA3AF);

  static Color get textOnPrimary => const Color(0xFFFFFFFF);

  static Color get inputFill =>
      _dark ? const Color(0xFF152035) : const Color(0xFFFFFFFF);

  static Color get inputBorder =>
      _dark ? const Color(0xFF1F3050) : const Color(0xFFE5E7EB);

  static Color get inputHint =>
      _dark ? const Color(0xFF4A5E80) : const Color(0xFF9CA3AF);

  static const Color error   = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color secured = Color(0xFF1DB954);

  static Color get iconBg =>
      _dark ? const Color(0xFF1A2D4A) : const Color(0xFFDBEAFE);

  static const Color iconColor = Color(0xFF1C4DB8);

  static Color get navBg =>
      _dark ? const Color(0xFF0F1729) : const Color(0xFFFFFFFF);

  static const Color navActive   = Color(0xFF1C4DB8);
  static const Color navInactive = Color(0xFF9CA3AF);

  static Color get tabSelected =>
      _dark ? const Color(0xFF0F1729) : const Color(0xFFFFFFFF);

  static Color get tabUnselected =>
      _dark ? const Color(0xFF1A2540) : const Color(0xFFF2F4F7);
}