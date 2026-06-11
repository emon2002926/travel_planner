import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../controllers/policy_storage_controller.dart';

class PolicyStoragePage extends StatelessWidget {
  const PolicyStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PolicyStorageController>()) {
      Get.put(PolicyStorageController());
    }
    final controller = Get.find<PolicyStorageController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: BuildAppBar(
          title: 'Policy Storage',
          titleFontSize: 20,
          fontWeight: FontWeight.w700,
          titleColor: AppColors.textPrimary,
          iconColor: AppColors.textPrimary,
          backgroundColor: AppColors.scaffoldBg,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final policy = controller.current;
                  if (policy == null) {
                    return _UploadState(controller: controller);
                  }
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      context.w(16), context.h(16),
                      context.w(16), context.h(24),
                    ),
                    child: Column(
                      children: [
                        _PolicyInfoCard(policy: policy),
                        SizedBox(height: context.h(14)),
                        _CoverageStatusCard(policy: policy),
                        SizedBox(height: context.h(14)),
                        _CoverageChecklistCard(policy: policy),
                        SizedBox(height: context.h(14)),
                        _ProviderContactCard(policy: policy),
                      ],
                    ),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(16), context.h(8),
                  context.w(16), context.h(24),
                ),
                child: AppButton(
                  buttonText: 'Add New Insurance',
                  onPressed: () => _showUploadSheet(context, controller),
                  borderRadius: 50,
                  buttonHeight: 56,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showUploadSheet(BuildContext context, PolicyStorageController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.w(20), context.h(24), context.w(20), context.h(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: 'Add New Insurance', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              SizedBox(height: context.h(20)),
              _UploadDropzone(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}



class _UploadState extends StatelessWidget {
  final PolicyStorageController controller;
  const _UploadState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.w(16)),
      child: Center(child: _UploadDropzone(controller: controller)),
    );
  }
}

class _UploadDropzone extends StatelessWidget {
  final PolicyStorageController controller;
  const _UploadDropzone({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: DottedBorder(
        radius: context.w(12),
        color: AppColors.inputBorder,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(36), horizontal: context.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, size: context.sp(40), color: AppColors.textPrimary),
              SizedBox(height: context.h(16)),
              Obx(() => AppText(
                data: controller.hasFile
                    ? controller.uploadedFileName.value
                    : 'Upload a PNG or JPG file to continue.',
                fontSize: 15,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              )),
              SizedBox(height: context.h(20)),
              GestureDetector(
                onTap: controller.pickFile,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(36), vertical: context.h(14)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: AppText(data: 'Choose', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _PolicyInfoCard extends StatelessWidget {
  final InsurancePolicy policy;
  const _PolicyInfoCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledRow(label: 'Provider', value: policy.provider),
          SizedBox(height: context.h(8)),
          _LabeledRow(label: 'Policy No', value: policy.policyNo),
          SizedBox(height: context.h(8)),
          _LabeledRow(label: 'Valid Till', value: policy.validTill),
        ],
      ),
    );
  }
}

class _CoverageStatusCard extends StatelessWidget {
  final InsurancePolicy policy;
  const _CoverageStatusCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledRow(label: 'Coverage', value: policy.coverage),
          SizedBox(height: context.h(8)),
          _LabeledRow(label: 'Status', value: policy.status, valueColor: const Color(0xFF16A34A)),
        ],
      ),
    );
  }
}

class _CoverageChecklistCard extends StatelessWidget {
  final InsurancePolicy policy;
  const _CoverageChecklistCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: 'COVERAGE CHECKLIST', fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(14)),
          ...policy.checklist.map((item) => Padding(
            padding: EdgeInsets.only(bottom: context.h(12)),
            child: Row(
              children: [
                Container(
                  width: context.w(24),
                  height: context.w(24),
                  decoration: BoxDecoration(
                    color: item.isCovered ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isCovered ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: context.sp(15),
                  ),
                ),
                SizedBox(width: context.w(12)),
                AppText(data: item.label, fontSize: 15, color: AppColors.textSecondary),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _ProviderContactCard extends StatelessWidget {
  final InsurancePolicy policy;
  const _ProviderContactCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledRow(label: 'Insurance Provider', value: policy.provider),
          SizedBox(height: context.h(8)),
          _LabeledRow(label: 'Emergency Number', value: policy.emergencyNumber),
          SizedBox(height: context.h(8)),
          _LabeledRow(label: 'Available', value: policy.availability),
        ],
      ),
    );
  }
}



class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: child,
    );
  }
}

class _LabeledRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _LabeledRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: '$label : ', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        Expanded(
          child: AppText(
            data: value,
            fontSize: 15,
            fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}


class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  const DottedBorder({super.key, required this.child, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: color, radius: radius),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
