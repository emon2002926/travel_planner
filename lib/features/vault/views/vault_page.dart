import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/app_navigation.dart';
import '../../settings/views/notification_screen.dart';
import '../controllers/vault_controller.dart';
import 'vault_document_view_page.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VaultController>()) {
      Get.put(VaultController());
    }
    final controller = Get.find<VaultController>();

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
              _VaultHeader(),
              Expanded(
                child: Obx(() {
                  if (controller.documents.isEmpty) {
                    return _EmptyState();
                  }
                  return _DocumentList(controller: controller);
                }),
              ),
              _AddDocumentsButton(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}

class _VaultHeader extends StatelessWidget {
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
          SizedBox(width: context.w(12)),
          Expanded(
            child: AppText(data: 'Vault', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SizedBox(
          width: context.w(120),
          height: context.w(120),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.insert_drive_file_outlined, size: context.sp(90), color: AppColors.textSecondary.withOpacity(0.35)),
              Positioned(
                right: context.w(8),
                bottom: context.h(16),
                child: Container(
                  width: context.w(34),
                  height: context.w(34),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inputBorder, width: 1.5),
                  ),
                  child: Icon(Icons.close, size: context.sp(18), color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.h(20)),
        AppText(
          data: 'No documents are available right now.',
          fontSize: 15,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        _DataSecurityCard(),
        SizedBox(height: context.h(12)),
      ],
    );
  }
}

class _DocumentList extends StatelessWidget {
  final VaultController controller;
  const _DocumentList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      children: [
        SizedBox(height: context.h(8)),
        _OfflineReadyBanner(controller: controller),
        SizedBox(height: context.h(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(data: 'Documents', fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            Row(
              children: [
                Icon(Icons.sync, size: context.sp(15), color: AppColors.textSecondary),
                SizedBox(width: context.w(5)),
                AppText(data: 'Offline Sync', fontSize: 13, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
        SizedBox(height: context.h(14)),
        ...controller.documents.map((doc) => Padding(
          padding: EdgeInsets.only(bottom: context.h(14)),
          child: _DocCard(doc: doc, controller: controller),
        )),
        _DataSecurityCard(),
        SizedBox(height: context.h(12)),
      ],
    );
  }
}

class _OfflineReadyBanner extends StatelessWidget {
  final VaultController controller;
  const _OfflineReadyBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(16)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wifi_off_outlined, color: Colors.white, size: context.sp(22)),
          ),
          SizedBox(width: context.w(14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: 'Offline Ready', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              SizedBox(height: context.h(3)),
              AppText(
                data: 'All ${controller.offlineCount} documents are cached offline',
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  final VaultDocument doc;
  final VaultController controller;
  const _DocCard({required this.doc, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bgColor   = VaultController.bgColorForType(doc.type);
    final iconColor = VaultController.iconColorForType(doc.type);
    final icon      = VaultController.iconForType(doc.type);

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.w(46),
                height: context.w(46),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(context.w(10)),
                ),
                child: Icon(icon, color: iconColor, size: context.sp(22)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.deleteDocument(doc.id),
                child: Container(
                  width: context.w(34),
                  height: context.w(34),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(context.w(8)),
                  ),
                  child: Icon(Icons.delete_outline, color: const Color(0xFFEF4444), size: context.sp(18)),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(10)),
          AppText(data: doc.name, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          SizedBox(height: context.h(3)),
          AppText(data: doc.subtitle, fontSize: 13, color: AppColors.textSecondary),
          SizedBox(height: context.h(12)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAuthSheet(context, doc, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: context.h(11)),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(context.w(10)),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    alignment: Alignment.center,
                    child: AppText(data: 'View Document', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
              ),
              SizedBox(width: context.w(10)),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: context.w(42),
                  height: context.w(42),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(context.w(10)),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Icon(Icons.download_outlined, color: AppColors.textPrimary, size: context.sp(20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAuthSheet(BuildContext context, VaultDocument doc, VaultController controller) {
    final authType = controller.preferredAuthType;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _AuthSheet(
        authType: authType,
        onSuccess: () {
          Get.back();
          Get.to(() => VaultDocumentViewPage(doc: doc));
        },
      ),
    );
  }
}

class _AuthSheet extends StatelessWidget {
  final VaultAuthType authType;
  final VoidCallback onSuccess;
  const _AuthSheet({required this.authType, required this.onSuccess});

  String get _title {
    switch (authType) {
      case VaultAuthType.fingerprint: return 'Use Fingerprint for Authentication';
      case VaultAuthType.faceId:      return 'Use FaceID for Authentication';
      case VaultAuthType.pin:         return 'Use PIN for Authentication';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.w(24), context.h(24), context.w(24), context.h(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    data: _title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () {Navigator.pop(context);},
                  child: Icon(Icons.close, color: AppColors.textPrimary, size: context.sp(22)),
                ),
              ],
            ),
            SizedBox(height: context.h(40)),
            if (authType == VaultAuthType.fingerprint)
              _FingerprintWidget(onTap: onSuccess),
            if (authType == VaultAuthType.faceId)
              _FaceIdWidget(onTap: onSuccess),
            if (authType == VaultAuthType.pin)
              _PinWidget(onSuccess: onSuccess),
            SizedBox(height: context.h(16)),
          ],
        ),
      ),
    );
  }
}

class _FingerprintWidget extends StatelessWidget {
  final VoidCallback onTap;
  const _FingerprintWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: context.w(80),
        height: context.w(80),
        child: CustomPaint(painter: _FingerprintPainter()),
      ),
    );
  }
}

class _FingerprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    for (var i = 1; i <= 5; i++) {
      final r = (size.width / 2) * (i / 5.5);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        i.isOdd ? 3.14 * 1.1 : 3.14 * 0.9,
        i.isOdd ? 3.14 * 0.9 : 3.14 * 1.1,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FaceIdWidget extends StatelessWidget {
  final VoidCallback onTap;
  const _FaceIdWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.face_outlined, size: context.sp(72), color: AppColors.textPrimary),
    );
  }
}

class _PinWidget extends StatelessWidget {
  final VoidCallback onSuccess;
  const _PinWidget({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VaultController>();
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = controller.pinDigits[i].isNotEmpty;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: context.w(6)),
          width: context.w(52),
          height: context.w(52),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(12)),
            border: Border.all(color: AppColors.inputBorder, width: 1.5),
          ),
          alignment: Alignment.center,
          child: AppText(
            data: filled ? '•' : '–',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        );
      }),
    ));
  }
}

class _DataSecurityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(38),
            height: context.w(38),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: Color(0xFF16A34A), size: 20),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: 'Data security', fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A)),
                SizedBox(height: context.h(4)),
                AppText(
                  data: 'All documents are end-to-end encrypted and synced to your devices. Available without internet.',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddDocumentsButton extends StatelessWidget {
  final VaultController controller;
  const _AddDocumentsButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: () => _showAddDocSheet(context, controller),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.w(50)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          alignment: Alignment.center,
          child: AppText(data: 'Add Documents', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  void _showAddDocSheet(BuildContext context, VaultController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _AddDocSheet(controller: controller),
    );
  }
}

class _AddDocSheet extends StatefulWidget {
  final VaultController controller;
  const _AddDocSheet({required this.controller});

  @override
  State<_AddDocSheet> createState() => _AddDocSheetState();
}

class _AddDocSheetState extends State<_AddDocSheet> {
  final _nameController = TextEditingController();
  String _fileName = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(28),
        context.w(20),
        MediaQuery.of(context).viewInsets.bottom + context.h(32),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: 'Add Documents', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            SizedBox(height: context.h(6)),
            AppText(data: 'Add your offline documents for future safety.', fontSize: 14, color: AppColors.textSecondary),
            SizedBox(height: context.h(22)),
            AppText(data: 'Document Name', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            SizedBox(height: context.h(8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(context.w(12)),
              ),
              child: TextField(
                controller: _nameController,
                style: TextStyle(fontSize: context.sp(15), color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Passport',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: context.sp(15)),
                  contentPadding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: context.h(18)),
            AppText(data: 'Select File', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            SizedBox(height: context.h(8)),
            GestureDetector(
              onTap: () => setState(() => _fileName = 'passport_scan.pdf'),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(10)),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.inputBorder),
                  borderRadius: BorderRadius.circular(context.w(12)),
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
                    if (_fileName.isNotEmpty)
                      Expanded(
                        child: AppText(data: _fileName, fontSize: 13, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(22)),
            GestureDetector(
              onTap: () {
                if (_nameController.text.trim().isNotEmpty) {
                  widget.controller.addDocument(_nameController.text.trim(), VaultDocType.other);
                  Get.back();
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: context.h(16)),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(context.w(50)),
                ),
                alignment: Alignment.center,
                child: AppText(data: 'Upload', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
