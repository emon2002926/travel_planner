import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/screen_size.dart';
import 'package:travel_planner/core/constants/app_colors.dart';
import 'package:travel_planner/core/themes/theme_controller.dart';


class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.data,
    this.fontSize = 16,
    this.textScaleFactor = 0.9,
    this.color,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.height,
    this.decoration,
    this.decorationColor,
    this.translate = false,
    this.frosted = false,
    this.latterSpacing,
    this.useResponsiveFontSize = true,
    this.googleFontFamily,
  });

  final String data;
  final double? fontSize;
  final double textScaleFactor;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool translate;
  final bool frosted;
  final double? latterSpacing;
  final bool useResponsiveFontSize;
  final TextStyle Function({TextStyle? textStyle})? googleFontFamily;

  TextStyle _buildTextStyle(BuildContext context) {
    final responsiveFontSize = useResponsiveFontSize && fontSize != null
        ? context.sp(fontSize!)
        : fontSize;

    final resolvedColor = color ?? AppColors.textPrimary;

    TextStyle styleParams(TextStyle style) => style.copyWith(
      height: height,
      fontSize: responsiveFontSize,
      color: resolvedColor,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
      letterSpacing: latterSpacing,
    );

    if (googleFontFamily != null) {
      return styleParams(googleFontFamily!());
    }

    return GoogleFonts.cormorantGaramond(
      height: height,
      fontSize: responsiveFontSize,
      color: resolvedColor,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
      letterSpacing: latterSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;

      tc?.themeMode.value;
      tc?.platformBrightness;

      final textWidget = Text(
        translate ? data.tr : data,
        maxLines: maxLines ?? 20,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: textAlign,
        style: _buildTextStyle(context),
        textScaler: TextScaler.linear(textScaleFactor),
      );

      if (!frosted) return textWidget;

      return ClipRRect(
        borderRadius: BorderRadius.circular(context.w(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(8),
              vertical: context.h(4),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(context.w(10)),
            ),
            child: textWidget,
          ),
        ),
      );
    });
  }
}