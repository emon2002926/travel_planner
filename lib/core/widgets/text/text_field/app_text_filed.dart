import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';
import '../../../util/screen_size.dart';
import '../app_text.dart';


import 'package:get/get.dart';
import 'package:travel_planner/core/themes/theme_controller.dart';


class AppTextField extends StatefulWidget {
  final String? label;
  final String? label2;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? suffixIconOnTap;
  final VoidCallback? onSuffixIconTap;
  final Color? borderColor;
  final Color? focusedErrorBorderColor;
  final TextInputType? keyboardType;
  final bool enabled;
  final VoidCallback? label2OnClick;
  final Color? fillColor;
  final Color? inputTextColor;
  final Color? hintTextColor;
  final double elevation;
  final Color? shadowColor;
  final BorderRadius? customBorderRadius;
  final bool isHintTextInMiddle;
  final Widget? suffixWidget;

  const AppTextField({
    super.key,
    this.label,
    this.label2,
    this.label2OnClick,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.suffixIconOnTap,
    this.onSuffixIconTap,
    this.borderColor,
    this.focusedErrorBorderColor,
    this.keyboardType,
    this.enabled = true,
    this.fillColor,
    this.inputTextColor,
    this.hintTextColor,
    this.elevation = 0,
    this.shadowColor,
    this.customBorderRadius,
    this.isHintTextInMiddle = false,
    this.suffixWidget,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _effectiveFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _effectiveFocusNode.hasFocus);
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _effectiveFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      final effectiveSuffixTap =
          widget.suffixIconOnTap ?? widget.onSuffixIconTap;

      final double inputFontSize = context.sp(14);
      final double iconSize = context.sp(20);
      final double borderRadiusValue = context.w(10);
      final double verticalPadding = context.h(14);
      final double horizontalPadding = context.w(16);
      final double spacing = context.h(8);

      final BorderRadius effectiveBorderRadius =
          widget.customBorderRadius ??
              BorderRadius.circular(borderRadiusValue);

      final Color resolvedFillColor = widget.enabled
          ? (widget.fillColor ?? AppColors.inputFill)
          : AppColors.inputFill.withOpacity(0.5);

      final Color resolvedInputTextColor =
          widget.inputTextColor ?? AppColors.textPrimary;

      final Color resolvedHintColor =
          widget.hintTextColor ?? AppColors.inputHint;

      final Color resolvedPrefixIconColor = _isFocused
          ? (widget.focusedErrorBorderColor ?? AppColors.primary)
          : AppColors.textSecondary;

      final Color activeBorderColor = _isFocused
          ? (widget.focusedErrorBorderColor ?? AppColors.primary)
          : (widget.borderColor ?? AppColors.inputBorder);

      final borderSide = BorderSide(
          color: activeBorderColor, width: _isFocused ? 1.5 : 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  data: widget.label!,
                  fontWeight: FontWeight.w600,
                  color: _isFocused
                      ? (widget.focusedErrorBorderColor ?? AppColors.primary)
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
                if (widget.label2 != null)
                  GestureDetector(
                    onTap: widget.label2OnClick,
                    child: AppText(
                      data: widget.label2!,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing),
          ],
          Material(
            elevation: widget.elevation,
            shadowColor: widget.shadowColor ?? Colors.black,
            borderRadius: effectiveBorderRadius,
            color: Colors.transparent,
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              validator: widget.validator,
              focusNode: _effectiveFocusNode,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              textAlign: widget.isHintTextInMiddle
                  ? TextAlign.center
                  : TextAlign.start,
              style: GoogleFonts.nunito(
                color: resolvedInputTextColor,
                fontSize: inputFontSize,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.nunito(
                  color: resolvedHintColor,
                  fontSize: inputFontSize,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: resolvedFillColor,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                  widget.prefixIcon,
                  color: resolvedPrefixIconColor,
                  size: iconSize,
                )
                    : null,
                suffixIcon: widget.suffixWidget ??
                    (widget.suffixIcon != null
                        ? GestureDetector(
                      onTap: effectiveSuffixTap,
                      child: Icon(
                        widget.suffixIcon,
                        color: AppColors.accent,
                        size: iconSize,
                      ),
                    )
                        : null),
                contentPadding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                border: OutlineInputBorder(
                    borderRadius: effectiveBorderRadius,
                    borderSide: borderSide),
                enabledBorder: OutlineInputBorder(
                    borderRadius: effectiveBorderRadius,
                    borderSide: borderSide),
                focusedBorder: OutlineInputBorder(
                    borderRadius: effectiveBorderRadius,
                    borderSide: borderSide),
              ),
            ),
          ),
        ],
      );
    });
  }
}