import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthRequirementsController extends GetxController {
  // ── Vaccination Status ────────────────────
  final RxBool isVaccinated       = true.obs;
  final doseNameController        = TextEditingController();
  final doseCompletedController   = TextEditingController();
  final Rx<DateTime?> lastDoseDate = Rx(null);

  // ── Medical Conditions ────────────────────
  final RxBool hasConditions = true.obs;

  static const conditionOptions = [
    'High Blood Pressure',
    'Diabetes',
    'Asthma',
    'Heart Disease',
    'High Blood Pressure',
    'Diabetes',
  ];

  final RxSet<String> selectedConditions = <String>{}.obs;

  // ── Allergies ─────────────────────────────
  final RxBool hasAllergies          = true.obs;
  final allergyController            = TextEditingController();

  // ── Date helpers ──────────────────────────
  String formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<void> pickLastDoseDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: lastDoseDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) lastDoseDate.value = picked;
  }

  void toggleCondition(String condition) {
    if (selectedConditions.contains(condition)) {
      selectedConditions.remove(condition);
    } else {
      selectedConditions.add(condition);
    }
  }

  void save() => Get.back();

  @override
  void onClose() {
    doseNameController.dispose();
    doseCompletedController.dispose();
    allergyController.dispose();
    super.onClose();
  }
}
