import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VaccinationRecord {
  final String id;
  final String vaccineName;
  final String doseNumber;
  final DateTime vaccinationDate;
  final DateTime? nextDoseDate;

  const VaccinationRecord({
    required this.id,
    required this.vaccineName,
    required this.doseNumber,
    required this.vaccinationDate,
    this.nextDoseDate,
  });
}

class VaccinationController extends GetxController {
  final nameController = TextEditingController();
  final doseController = TextEditingController();

  final Rx<DateTime?> vaccinationDate = Rx(null);
  final Rx<DateTime?> nextDoseDate    = Rx(null);

  final RxList<VaccinationRecord> records = <VaccinationRecord>[].obs;

  bool get isValid =>
      nameController.text.trim().isNotEmpty &&
          doseController.text.trim().isNotEmpty &&
          vaccinationDate.value != null;

  String formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<void> pickVaccinationDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vaccinationDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) vaccinationDate.value = picked;
  }

  Future<void> pickNextDoseDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: nextDoseDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) nextDoseDate.value = picked;
  }

  void save(BuildContext context) {
    if (!isValid) return;
    records.add(VaccinationRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vaccineName: nameController.text.trim(),
      doseNumber: doseController.text.trim(),
      vaccinationDate: vaccinationDate.value!,
      nextDoseDate: nextDoseDate.value,
    ));
    _reset();
    Navigator.pop(context);
  }

  void _reset() {
    nameController.clear();
    doseController.clear();
    vaccinationDate.value = null;
    nextDoseDate.value    = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    doseController.dispose();
    super.onClose();
  }
}