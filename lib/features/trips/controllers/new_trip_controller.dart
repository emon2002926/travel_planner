import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../home/models/trip_model.dart';


class NewTripController extends GetxController {
  final currentStep = 0.obs;

  final destinationController = TextEditingController();
  final otherTransportController = TextEditingController();
  final groupSizeController = TextEditingController();
  final budgetController = TextEditingController();
  final foodController = TextEditingController();
  final transportBudgetController = TextEditingController();
  final stayController = TextEditingController();
  final shoppingController = TextEditingController();
  final activitiesController = TextEditingController();

  final selectedTransport = <String>{'Flight', 'Train', 'Car', 'Ship'}.obs;
  final selectedTravelTypes = <String>{'Relaxed', 'Low Adrenaline', 'Adrenaline', 'High Adrenaline'}.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final hasInsurance = false.obs;
  final selectedCurrency = '\$'.obs;
  final selectedTripType = Rxn<String>();

  void next() {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      _submitTrip();
    }
  }

  void back() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void toggleTransport(String v) =>
      selectedTransport.contains(v) ? selectedTransport.remove(v) : selectedTransport.add(v);

  void toggleTravelType(String v) =>
      selectedTravelTypes.contains(v) ? selectedTravelTypes.remove(v) : selectedTravelTypes.add(v);

  void selectTripType(String v) => selectedTripType.value = v;

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final initial = isStart
        ? (startDate.value ?? now)
        : (endDate.value ?? startDate.value?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 1095)),
    );
    if (picked == null) return;
    if (isStart) {
      startDate.value = picked;
    } else {
      endDate.value = picked;
    }
  }

  void _submitTrip() {
    final home = Get.find<HomeController>();

    String dateRange = 'TBD';
    String duration = '0 Days';
    if (startDate.value != null && endDate.value != null) {
      dateRange = '${_fmt(startDate.value!)} - ${_fmt(endDate.value!)}';
      duration = '${endDate.value!.difference(startDate.value!).inDays} Days';
    }

    final trip = TripModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      destination: destinationController.text.isNotEmpty ? destinationController.text : 'New Trip',
      dateRange: dateRange,
      duration: duration,
      partySize: selectedTripType.value ?? 'Solo',
      readyPercent: 0,
      state: TripState.active,
    );

    home.trips.add(trip);
    home.activeTrip.value = trip;
    Get.back();
  }

  String _fmt(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  void onClose() {
    destinationController.dispose();
    otherTransportController.dispose();
    groupSizeController.dispose();
    budgetController.dispose();
    transportBudgetController.dispose();
    stayController.dispose();
    shoppingController.dispose();
    activitiesController.dispose();
    foodController.dispose();
    super.onClose();
  }
}