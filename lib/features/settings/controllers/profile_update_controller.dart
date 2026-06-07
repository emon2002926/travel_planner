import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdateController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString selectedCurrency = 'Dollar'.obs;

  final List<String> currencies = [
    'Dollar',
    'Euro',
    'Pound',
    'Yen',
    'Taka',
  ];

  // Future<void> onPickImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) selectedImage.value = File(picked.path);
  // }

  void onCurrencyChanged(String? value) {
    if (value != null) selectedCurrency.value = value;
  }

  void onSave() {}

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    super.onClose();
  }
}