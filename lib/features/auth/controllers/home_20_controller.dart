import 'package:get/get.dart';

enum PlanType { monthly, quarterly, annual }

class Home20Controller extends GetxController {
  final Rx<PlanType> selectedPlan = PlanType.annual.obs;

  void selectPlan(PlanType plan) => selectedPlan.value = plan;

  void onNext() {}

  void onClose() {}
}