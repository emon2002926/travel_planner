
import 'package:get/get.dart';
class AuthController extends GetxController {
  final RxBool isLoginTab = true.obs;

  void switchToLogin() => isLoginTab.value = true;
  void switchToSignUp() => isLoginTab.value = false;
}