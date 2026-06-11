import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: OnBoardingController.totalPages,
                itemBuilder: (context, index) {
                  return _OnBoardingPage(data: controller.pages[index]);
                },
              ),
            ),
            _BottomSection(controller: controller),
          ],
        ),
      );
    });
  }
}

class _OnBoardingPage extends StatelessWidget {
  final OnBoardingPageData data;

  const _OnBoardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageSection(imagePath: data.imagePath),
        _TextSection(data: data),
      ],
    );
  }
}

class _ImageSection extends StatelessWidget {
  final String imagePath;

  const _ImageSection({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: context.heightPercentage(50),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          height: context.heightPercentage(50),
          color: AppColors.cardBg,
          child: Icon(
            Icons.image_outlined,
            size: context.sp(64),
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  final OnBoardingPageData data;

  const _TextSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TitleWidget(data: data),
            SizedBox(height: context.h(16)),
            AppText(
              data: data.description,
              fontSize: 15,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              googleFontFamily: GoogleFonts.jost,
              height: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  final OnBoardingPageData data;

  const _TitleWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      final fontSize = context.sp(28);
      final highlightColor = AppColors.primary;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              children: [
                TextSpan(text: data.titleStart),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: _HighlightedWord(
                    text: data.titleHighlight,
                    fontSize: fontSize,
                    color: highlightColor,
                  ),
                ),
                if (data.titleMiddle != null)
                  TextSpan(text: data.titleMiddle),
                if (data.titleHighlight2 != null)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: _HighlightedWord(
                      text: data.titleHighlight2!,
                      fontSize: fontSize,
                      color: highlightColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _HighlightedWord extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const _HighlightedWord({
    required this.text,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: GoogleFonts.jost(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1.3,
          ),
        ),
        SizedBox(height: context.h(2)),
        CustomPaint(
          size: Size(context.w(80), context.h(8)),
          painter: _ArcPainter(color: color),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  const _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.6,
      size.width,
      size.height * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => oldDelegate.color != color;
}

class _BottomSection extends StatelessWidget {
  final OnBoardingController controller;

  const _BottomSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Padding(
        padding: EdgeInsets.only(
          left: context.w(24),
          right: context.w(24),
          bottom: context.h(40),
          top: context.h(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DotsIndicator(controller: controller),
            SizedBox(height: context.h(32)),
            AppButton(
              buttonText: controller.isLastPage ? 'Get Started' : 'Next',
              onPressed: controller.nextPage,
              fillColor: AppColors.primary,
              textColor: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              buttonHeight: 54,
              // googleFontFamily: GoogleFonts.jost,
            ),
          ],
        ),
      );
    });
  }
}

class _DotsIndicator extends StatelessWidget {
  final OnBoardingController controller;

  const _DotsIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnBoardingController.totalPages,
            (index) {
          final isActive = controller.currentPage.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: context.w(4)),
            width: isActive ? context.w(32) : context.w(10),
            height: context.h(8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.25),
              borderRadius: BorderRadius.circular(context.w(8)),
            ),
          );
        },
      ),
    ));
  }
}