import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum VaultDocType { passport, boarding, creditCard, other }
enum VaultAuthType { fingerprint, faceId, pin }

class VaultDocument {
  final String id;
  final String name;
  final String subtitle;
  final VaultDocType type;
  final String? imagePath;

  const VaultDocument({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.type,
    this.imagePath,
  });
}

class VaultController extends GetxController {
  final RxList<VaultDocument> documents = <VaultDocument>[].obs;
  final RxBool isOfflineReady = true.obs;
  final RxString pendingViewDocId = ''.obs;
  final RxList<String> pinDigits = List.filled(5, '').obs;

  int get offlineCount => documents.length;

  static IconData iconForType(VaultDocType type) {
    switch (type) {
      case VaultDocType.passport:    return Icons.language_outlined;
      case VaultDocType.boarding:    return Icons.insert_drive_file_outlined;
      case VaultDocType.creditCard:  return Icons.credit_card_outlined;
      case VaultDocType.other:       return Icons.description_outlined;
    }
  }

  static Color bgColorForType(VaultDocType type) {
    switch (type) {
      case VaultDocType.passport:   return const Color(0xFFEEF2FF);
      case VaultDocType.boarding:   return const Color(0xFFEFF6FF);
      case VaultDocType.creditCard: return const Color(0xFFEFF6FF);
      case VaultDocType.other:      return const Color(0xFFF1F5F9);
    }
  }

  static Color iconColorForType(VaultDocType type) {
    switch (type) {
      case VaultDocType.passport:   return const Color(0xFF4F46E5);
      case VaultDocType.boarding:   return const Color(0xFF2563EB);
      case VaultDocType.creditCard: return const Color(0xFF2563EB);
      case VaultDocType.other:      return const Color(0xFF64748B);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    documents.assignAll([
      const VaultDocument(id: 'vd1', name: 'Passport',        subtitle: 'Expires: Oct 2029',           type: VaultDocType.passport),
      const VaultDocument(id: 'vd2', name: 'Boarding pass',   subtitle: 'Flight QR701 - Gate B4',      type: VaultDocType.boarding),
      const VaultDocument(id: 'vd3', name: 'Credit Card Info',subtitle: 'Added Apr 20, 2026',           type: VaultDocType.creditCard),
    ]);
  }

  void addDocument(String name, VaultDocType type) {
    documents.add(VaultDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      subtitle: 'Added ${_todayLabel()}',
      type: type,
    ));
  }

  void deleteDocument(String id) => documents.removeWhere((d) => d.id == id);

  VaultDocument? getById(String id) {
    try { return documents.firstWhere((d) => d.id == id); } catch (_) { return null; }
  }

  void enterPin(String digit) {
    final idx = pinDigits.indexWhere((d) => d.isEmpty);
    if (idx == -1) return;
    pinDigits[idx] = digit;
    pinDigits.refresh();
  }

  void clearPin() {
    for (var i = 0; i < pinDigits.length; i++) pinDigits[i] = '';
    pinDigits.refresh();
  }

  bool get isPinComplete => pinDigits.every((d) => d.isNotEmpty);

  String _todayLabel() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  VaultAuthType get preferredAuthType => VaultAuthType.fingerprint;
}
