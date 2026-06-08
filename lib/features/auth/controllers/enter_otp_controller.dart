
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/auth/views/account_selection.dart';
import '../views/reset_password_screen.dart';
class EnterOtpController extends GetxController {
  final List<TextEditingController> otpControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  void onChanged(String value, int index) {
    if (value.length == 1 && index < 4) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void onSubmit(bool isFromSignUp) {
    if (isFromSignUp) {
      AppNavigation.push(AccountSelectionScreen());
    } else {
      AppNavigation.push(ResetPasswordScreen());
    }
  }


  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}