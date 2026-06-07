
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/auth/views/enter_otp_screen.dart';
class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void onSendOtp( ) {
    AppNavigation.push(EnterOtpScreen(isFromSignUp: false,));
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}