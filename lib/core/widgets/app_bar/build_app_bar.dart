import 'package:flutter/material.dart';
import 'dart:ui';

import '../../util/screen_size.dart';
import '../text/app_text.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Color? subtitleColor;
  final double? subtitleSize;
  final FontWeight? subtitleFontWeight;
  final Color? titleColor;
  final Color? iconColor;
  final bool enableFrostEffect;
  final bool showSideButton;
  final VoidCallback? onSideButtonPressed;
  final IconData sideButtonIcon;
  final bool showBackButton;
  final Color? backgroundColor;
  final double? titleFontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onBackButtonPressed;
  final bool useCircularBackButton;
  final Color? circularButtonColor;
  final double? circularButtonSize;
  final IconData backButtonIcon;
  final bool useMinimalStyle;

  const BuildAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.subtitleColor,
    this.subtitleSize,
    this.subtitleFontWeight,
    this.titleColor,
    this.iconColor,
    this.enableFrostEffect = false,
    this.showSideButton = false,
    this.onSideButtonPressed,
    this.sideButtonIcon = Icons.more_vert,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleFontSize,
    this.fontWeight,
    this.onBackButtonPressed,
    this.useCircularBackButton = false,
    this.circularButtonColor,
    this.circularButtonSize,
    this.backButtonIcon = Icons.arrow_back,
    this.useMinimalStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    // ── Minimal style ──────────────────────────────────────────────────────────
    if (useMinimalStyle) {
      return Container(
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveSize(16),
                vertical: context.responsiveSize(14),
              ),
              child: Column(
                children: [
                  SizedBox(height: context.heightPercentage(3)),
                  Row(
                    children: [
                      // ── Back Button ──
                      showBackButton
                          ? GestureDetector(
                        onTap: onBackButtonPressed ?? () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.only(right: context.responsiveSize(8)),
                          child: Icon(
                            Icons.chevron_left,
                            size: context.responsiveSize(32),
                            color: iconColor ?? const Color(0xFF78584A),
                          ),
                        ),
                      )
                          : SizedBox(width: context.responsiveSize(32)),

                      // ── Centered Title + Subtitle ──
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (title != null)
                              AppText(
                                data: title!,
                                fontSize: titleFontSize ?? 20,
                                fontWeight: fontWeight ?? FontWeight.w900,
                                color: titleColor ?? const Color(0xFF78584A),
                                useResponsiveFontSize: true,
                                textAlign: TextAlign.center,
                              ),
                            if (subtitle != null)
                              AppText(
                                data: subtitle!,
                                fontSize: subtitleSize ?? 14,
                                fontWeight: subtitleFontWeight ?? FontWeight.w800,
                                color: subtitleColor ?? const Color(0xFFD97706),
                                useResponsiveFontSize: true,
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),

                      // ── Right Side Balance / Action Button ──
                      showSideButton
                          ? GestureDetector(
                        onTap: onSideButtonPressed,
                        child: Icon(
                          sideButtonIcon,
                          size: context.responsiveSize(32),
                          color: iconColor ?? const Color(0xFF78584A),
                        ),
                      )
                          : SizedBox(width: context.responsiveSize(32)),
                    ],
                  ),


                ],
              ),
            ),
            Container(width: MediaQuery.of(context).size.width,
              height: context.responsiveSize(1),color: Colors.black12,)
          ],
        ),
      );
    }

    // ── Original style ────────────────────────────────────────────────────────

    Widget buildCircularBackButton() {
      final size = circularButtonSize ?? context.responsiveSize(60);
      final color = circularButtonColor ?? const Color(0xFF0047AB);

      return Padding(
        padding: EdgeInsets.only(
          left: context.responsiveSize(16),
          top: context.responsiveSize(8),
          bottom: context.responsiveSize(8),
        ),
        child: GestureDetector(
          onTap: onBackButtonPressed ?? () => Navigator.pop(context),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                backButtonIcon,
                color: iconColor ?? Colors.black,
                size: context.responsiveSize(32),
              ),
            ),
          ),
        ),
      );
    }

    Widget buildStandardBackButton() {
      return IconButton(
        icon: Icon(backButtonIcon, color: iconColor ?? Colors.black),
        onPressed: onBackButtonPressed ?? () => Navigator.pop(context),
      );
    }

    final appBarContent = AppBar(
      backgroundColor: backgroundColor ??
          (enableFrostEffect
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? (useCircularBackButton
          ? buildCircularBackButton()
          : buildStandardBackButton())
          : null,
      leadingWidth: useCircularBackButton
          ? context.responsiveSize(74)
          : null,
      title: title != null
        ?AppText(data:title!,
        fontSize: titleFontSize??24,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: titleColor ?? Color(0xFF624D40),
      )
          : null,
      centerTitle: true,
      actions: showSideButton
          ? [
        IconButton(
          icon: Icon(sideButtonIcon, color: iconColor ?? Colors.white),
          onPressed: onSideButtonPressed,
          iconSize: 24,
        ),
      ]
          : null,
    );

    return enableFrostEffect
        ? ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: backgroundColor?.withOpacity(0.2) ?? Colors.transparent,
          child: appBarContent,
        ),
      ),
    )
        : appBarContent;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}