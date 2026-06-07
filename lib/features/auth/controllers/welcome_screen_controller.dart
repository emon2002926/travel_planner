import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';

import '../views/auth_screen.dart';
import '../views/sign_in_screen.dart';


class WelcomeController extends GetxController {
  void onContinueWithEmail() {AppNavigation.push(AuthScreen());}
  void onContinueWithGoogle() {}
  void onTermsTap() => {};
  void onPrivacyTap() => {};
}
