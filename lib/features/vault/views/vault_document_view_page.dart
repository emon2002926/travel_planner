import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/util/screen_size.dart';
import '../controllers/vault_controller.dart';

class VaultDocumentViewPage extends StatelessWidget {
  final VaultDocument doc;
  const VaultDocumentViewPage({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            _ViewHeader(doc: doc),
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(16),
                    ),
                    child: doc.imagePath != null
                        ? Image.asset(doc.imagePath!, fit: BoxFit.contain)
                        : _PlaceholderDocument(doc: doc),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewHeader extends StatelessWidget {
  final VaultDocument doc;
  const _ViewHeader({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Text(
              doc.name,
              style: TextStyle(
                fontSize: context.sp(18),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.download_outlined, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderDocument extends StatelessWidget {
  final VaultDocument doc;
  const _PlaceholderDocument({required this.doc});

  @override
  Widget build(BuildContext context) {
    final icon  = VaultController.iconForType(doc.type);
    final color = VaultController.iconColorForType(doc.type);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: context.h(400)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: context.sp(80), color: color.withOpacity(0.4)),
          SizedBox(height: context.h(16)),
          Text(
            doc.name,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: context.h(8)),
          Text(
            doc.subtitle,
            style: TextStyle(fontSize: context.sp(14), color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
