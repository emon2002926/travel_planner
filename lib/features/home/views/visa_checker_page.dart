
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/settings/views/notification_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/visa_checker_controller.dart';

class VisaCheckerPage extends StatelessWidget {
  const VisaCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VisaCheckerController>()) {
      Get.put(VisaCheckerController());
    }
    final controller = Get.find<VisaCheckerController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              _VisaHeader(),
              Expanded(
                child: Obx(() {
                  switch (controller.state.value) {
                    case VisaCheckState.idle:
                      return _IdleBody(controller: controller);
                    case VisaCheckState.loading:
                      return _LoadingBody();
                    case VisaCheckState.result:
                      return _ResultBody(controller: controller);
                  }
                }),
              ),
              Obx(() {
                switch (controller.state.value) {
                  case VisaCheckState.idle:
                    return _PrimaryButton(
                      label: 'Visa Check',
                      onTap: controller.checkVisa,
                    );
                  case VisaCheckState.loading:
                    return _PrimaryButton(label: 'Checking...', onTap: null);
                  case VisaCheckState.result:
                    return _PrimaryButton(
                      label: 'Check Again',
                      onTap: controller.checkAgain,
                    );
                }
              }),
            ],
          ),
        ),
      );
    });
  }
}



class _VisaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: AppText(
              data: 'Visa Checker',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {
              AppNavigation.push(NotificationScreen(),context: context);
              },
            child: Container(
              width: context.w(44),
              height: context.w(44),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: context.sp(22)),
                  Positioned(
                    top: context.h(10),
                    right: context.w(10),
                    child: Container(
                      width: context.w(7),
                      height: context.w(7),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _IdleBody extends StatelessWidget {
  final VisaCheckerController controller;
  const _IdleBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Choose File',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.h(10)),
          GestureDetector(
            onTap: controller.pickFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(10)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(10)),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(context.w(8)),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: AppText(data: 'Choose your file', fontSize: 14, color: AppColors.textPrimary),
                  ),
                  SizedBox(width: context.w(12)),
                  Obx(() => controller.hasFile
                      ? Expanded(
                          child: AppText(
                            data: controller.fileName.value,
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _LoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(height: context.h(20)),
          AppText(data: 'Checking your visa...', fontSize: 15, color: AppColors.textSecondary),

        ],
      ),
    );
  }
}



class _ResultBody extends StatelessWidget {
  final VisaCheckerController controller;
  const _ResultBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isOk = controller.status.value == VisaStatus.ok;
    final statusColor = isOk ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Column(
      children: [
        const Spacer(),
        _CheckmarkCharacter(),
        SizedBox(height: context.h(32)),
        _StatusLine(label: 'Visa Status', value: controller.statusLabel, valueColor: statusColor),
        SizedBox(height: context.h(12)),
        _StatusLine(label: 'Visa End Time', value: controller.visaEndDate.value, valueColor: statusColor),
        const Spacer(),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatusLine({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(data: '$label : ', fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        AppText(data: value, fontSize: 17, fontWeight: FontWeight.w700, color: valueColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Checkmark character illustration
//  Replace with Image.asset('assets/images/visa_check.png') once you provide the asset
// ─────────────────────────────────────────────

class _CheckmarkCharacter extends StatefulWidget {
  @override
  State<_CheckmarkCharacter> createState() => _CheckmarkCharacterState();
}

class _CheckmarkCharacterState extends State<_CheckmarkCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Swap these two lines once asset is ready ──────────────────────────
    // return ScaleTransition(scale: _scale, child: Image.asset('assets/images/visa_check.png', width: context.w(240)));
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: context.w(220),
        height: context.w(220),
        child: CustomPaint(painter: _CheckCharacterPainter()),
      ),
    );
  }
}

class _CheckCharacterPainter extends CustomPainter {
  static const _green = Color(0xFF3DAD5E);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = _green
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.065
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // ── Checkmark outline path ────────────────────────────────────────────
    // left foot → bottom-center → top-right tip
    final path = Path()
      ..moveTo(w * 0.10, h * 0.42)
      ..cubicTo(w * 0.12, h * 0.50, w * 0.20, h * 0.58, w * 0.30, h * 0.72)
      ..cubicTo(w * 0.36, h * 0.80, w * 0.40, h * 0.86, w * 0.42, h * 0.88)
      ..cubicTo(w * 0.46, h * 0.92, w * 0.50, h * 0.92, w * 0.54, h * 0.88)
      ..cubicTo(w * 0.60, h * 0.80, w * 0.70, h * 0.64, w * 0.82, h * 0.42)
      ..cubicTo(w * 0.88, h * 0.30, w * 0.90, h * 0.18, w * 0.88, h * 0.10)
      ..cubicTo(w * 0.84, h * 0.04, w * 0.78, h * 0.04, w * 0.74, h * 0.08)
      ..cubicTo(w * 0.62, h * 0.22, w * 0.52, h * 0.42, w * 0.44, h * 0.60)
      ..cubicTo(w * 0.38, h * 0.50, w * 0.30, h * 0.40, w * 0.22, h * 0.32)
      ..cubicTo(w * 0.16, h * 0.26, w * 0.10, h * 0.26, w * 0.08, h * 0.32)
      ..cubicTo(w * 0.06, h * 0.36, w * 0.08, h * 0.40, w * 0.10, h * 0.42)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // ── Shadow ellipse ────────────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.44, h * 0.94), width: w * 0.55, height: h * 0.06),
      shadowPaint,
    );

    // ── Eyes ──────────────────────────────────────────────────────────────
    _drawEye(canvas, Offset(w * 0.33, h * 0.62), w * 0.07, strokePaint, fillPaint);
    _drawEye(canvas, Offset(w * 0.53, h * 0.62), w * 0.07, strokePaint, fillPaint);

    // ── Smile ─────────────────────────────────────────────────────────────
    final smilePaint = Paint()
      ..color = _green
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(w * 0.30, h * 0.72)
      ..quadraticBezierTo(w * 0.43, h * 0.80, w * 0.56, h * 0.72);
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawEye(Canvas canvas, Offset center, double r, Paint stroke, Paint fill) {
    // outer ring
    canvas.drawCircle(center, r, fill);
    canvas.drawCircle(center, r, stroke);
    // inner pupil
    canvas.drawCircle(center, r * 0.38, Paint()..color = _green..style = PaintingStyle.fill);
    // highlight
    canvas.drawCircle(
      Offset(center.dx - r * 0.22, center.dy - r * 0.22),
      r * 0.18,
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
//  Shared primary button
// ─────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(18)),
          decoration: BoxDecoration(
            color: onTap != null ? AppColors.primary : AppColors.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(context.w(50)),
          ),
          alignment: Alignment.center,
          child: AppText(data: label, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
