
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/auth/views/home_20_screen.dart';
enum UserRole { owner, editor, viewer }

class AccountSelectionController extends GetxController {
  final Rx<UserRole> selectedRole = UserRole.owner.obs;

  void selectRole(UserRole role) => selectedRole.value = role;

  void onNext() { AppNavigation.push(Home20Screen());}
}