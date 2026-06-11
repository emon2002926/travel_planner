import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/base_screen/views/base_page.dart';

import '../../../core/widgets/snakbar/custom_snackbar.dart';
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

  final selectedTransport = <String>{}.obs;
  final selectedTravelTypes = <String>{}.obs;

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final hasInsurance = false.obs;
  final selectedCurrency = '\$'.obs;
  final selectedTripType = Rxn<String>();

  void next() {
    if (!_validateStep(currentStep.value)) return;

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

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (destinationController.text.trim().isEmpty) {
          CustomSnackBar.warning('Please enter your destination');
          return false;
        }
        if (selectedTransport.isEmpty &&
            otherTransportController.text.trim().isEmpty) {
          CustomSnackBar.warning('Please select at least one transportation');
          return false;
        }
        if (startDate.value == null || endDate.value == null) {
          CustomSnackBar.warning('Please select start and end dates');
          return false;
        }
        if (endDate.value!.isBefore(startDate.value!)) {
          CustomSnackBar.error("End date can't be before start date");
          return false;
        }
        return true;

      case 1:
        final budget = budgetController.text.trim();
        if (budget.isNotEmpty && double.tryParse(budget) == null) {
          CustomSnackBar.warning('Please enter a valid budget amount');
          return false;
        }
        return true;

      case 2:
        if (selectedTripType.value == null) {
          CustomSnackBar.warning('Please select a trip type');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  void toggleTransport(String v) => selectedTransport.contains(v)
      ? selectedTransport.remove(v)
      : selectedTransport.add(v);

  void toggleTravelType(String v) => selectedTravelTypes.contains(v)
      ? selectedTravelTypes.remove(v)
      : selectedTravelTypes.add(v);

  void selectTripType(String v) => selectedTripType.value = v;

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();

    final first = isStart ? now : (startDate.value ?? now);

    DateTime initial = isStart
        ? (startDate.value ?? now)
        : (endDate.value ?? first.add(const Duration(days: 1)));
    if (initial.isBefore(first)) initial = first;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now.add(const Duration(days: 1095)),
    );
    if (picked == null) return;

    if (isStart) {
      startDate.value = picked;
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    } else {
      endDate.value = picked;
    }
  }

  void _submitTrip() {
    final home = Get.find<HomeController>();

    final start = startDate.value!;
    final end = endDate.value!;

    final startDay = DateTime(start.year, start.month, start.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final tripDays = end.difference(start).inDays + 1;
    final daysLeft = startDay.difference(today).inDays;

    final trip = TripModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      destination: destinationController.text.trim(),
      dateRange: '${_fmt(start)} - ${_fmt(end)}',
      duration: '$tripDays Days',
      partySize: selectedTripType.value ?? 'Solo',
      readyPercent: 0,
      daysLeft: daysLeft < 0 ? 0 : daysLeft,
      packedItems: 0,
      totalItems: 0,
      pendingTasks: 0,
      state: TripState.active,
    );

    // Add to list first, then decide if it becomes the hero.
    home.trips.add(trip);

    if (home.activeTrip.value == null) {
      home.activeTrip.value = trip; // first trip → hero card
    }
    // If activeTrip was already set, the trip just lands in upcomingTrips
    // via the filtered getter — no extra work needed.

    // Force the RxList to notify even if GetX batched the update.
    home.trips.refresh();

    AppNavigation.pushAndClear(BasePage());
    CustomSnackBar.success('Trip to ${trip.destination} created!');
  }


  String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
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