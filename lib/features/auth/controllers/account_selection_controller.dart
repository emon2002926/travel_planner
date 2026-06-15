
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/auth/views/home_20_screen.dart';

import '../../../core/util/storage_service.dart';
enum UserRole { owner, editor, viewer }

class AccountSelectionController extends GetxController {
  late final Rx<UserRole> selectedRole =
      (StorageService.userRole ?? UserRole.owner).obs;

  void selectRole(UserRole role) => selectedRole.value = role;

  Future<void> onNext() async {
    await StorageService.saveUserRole(selectedRole.value);
    AppNavigation.push(Home20Screen());
  }
}