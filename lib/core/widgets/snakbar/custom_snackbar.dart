import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:travel_planner/core/constants/app_colors.dart';
import 'package:travel_planner/core/themes/theme_controller.dart';

class CustomSnackBar {
  CustomSnackBar._();

  static bool get _isDark {
    final tc = GetInstance().isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : null;
    return tc?.isActuallyDark ?? false;
  }

  static Color get _textColor =>
      _isDark ? AppColors.textPrimary : Colors.white;

  static void _show(
      String message, {
        required Color color,
        IconData? icon,
        Duration duration = const Duration(seconds: 3),
        SnackBarAction? action,
      }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: _textColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: _textColor),
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 8,
      mainButton: action != null
          ? TextButton(
        onPressed: action.onPressed,
        child: Text(action.label,
            style: TextStyle(color: _textColor)),
      )
          : null,
    );
  }

  static void success(String message,
      {Duration? duration, SnackBarAction? action}) =>
      _show(message,
          color: AppColors.success,
          icon: Icons.check_circle,
          duration: duration ?? const Duration(seconds: 3),
          action: action);

  static void error(String message,
      {Duration? duration, SnackBarAction? action}) =>
      _show(message,
          color: AppColors.error,
          icon: Icons.error,
          duration: duration ?? const Duration(seconds: 4),
          action: action);

  static void warning(String message,
      {Duration? duration, SnackBarAction? action}) =>
      _show(message,
          color: Colors.amber.shade800,
          icon: Icons.warning,
          duration: duration ?? const Duration(seconds: 3),
          action: action);

  static void info(String message,
      {Duration? duration, SnackBarAction? action}) =>
      _show(message,
          color: AppColors.accent,
          icon: Icons.info_outline,
          duration: duration ?? const Duration(seconds: 3),
          action: action);

  static void show(String message,
      {Duration? duration, SnackBarAction? action}) =>
      info(message, duration: duration, action: action);
}