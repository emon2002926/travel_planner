import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WelcomeController extends GetxController {
  void onContinueWithEmail() => Get.toNamed('/login');
  void onContinueWithGoogle() {}
  void onTermsTap() => Get.toNamed('/terms');
  void onPrivacyTap() => Get.toNamed('/privacy');
}
