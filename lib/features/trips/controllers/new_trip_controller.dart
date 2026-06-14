import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/base_screen/views/base_page.dart';

import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/models/trip_model.dart';


// ---------------------------------------------------------------------------
// One leg of transport (the "Add More Flight" block repeats this).
// Plain TextEditingControllers — disposed in the controller's onClose.
// ---------------------------------------------------------------------------
class TransportLeg {
  final String id;
  final carrier = TextEditingController();
  final bookingRef = TextEditingController();
  final arrivalPlace = TextEditingController();
  final departurePlace = TextEditingController();
  final gate = TextEditingController();
  final terminal = TextEditingController();
  final seat = TextEditingController();
  final Rxn<DateTime> arrivalTime = Rxn<DateTime>();
  final Rxn<DateTime> departureTime = Rxn<DateTime>();

  TransportLeg({required this.id});

  void dispose() {
    carrier.dispose();
    bookingRef.dispose();
    arrivalPlace.dispose();
    departurePlace.dispose();
    gate.dispose();
    terminal.dispose();
    seat.dispose();
  }
}

class NewTripController extends GetxController {
  final currentStep = 0.obs;
  static const int lastStep = 3; // 4 steps: 0..3

  // Step 1
  final destinationController = TextEditingController();
  final otherTransportController = TextEditingController();
  final groupSizeController = TextEditingController();

  // Step 2
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

  // Step 3 — Transport details
  final transportMode = 'Flight'.obs; // Flight / Train / Bus / Car
  final transportLegs = <TransportLeg>[].obs;

  @override
  void onInit() {
    super.onInit();
    transportLegs.add(TransportLeg(id: _newLegId()));
  }

  // -------------------------------------------------------------------------
  // Navigation
  // -------------------------------------------------------------------------

  void next() {
    if (!_validateStep(currentStep.value)) return;

    if (currentStep.value < lastStep) {
      currentStep.value++;
    } else {
      _submitTrip();
    }
  }

  /// Skip advances past the current step without validating it.
  /// On the final step it still creates the trip (Skip + Create both finish).
  void skip() {
    if (currentStep.value < lastStep) {
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

  bool get isLastStep => currentStep.value == lastStep;
  String get primaryButtonText => isLastStep ? 'Create' : 'Next';

  // -------------------------------------------------------------------------
  // Validation — only the steps the design treats as required.
  // Step 1: destination + transport + valid dates.
  // Step 2 (budget) and Step 3 (transport details) are skippable/optional.
  // Step 4: trip type.
  // -------------------------------------------------------------------------

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
        return true; // transport details fully optional

      case 3:
        if (selectedTripType.value == null) {
          CustomSnackBar.warning('Please select a trip type');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  // -------------------------------------------------------------------------
  // Selections
  // -------------------------------------------------------------------------

  void toggleTransport(String v) => selectedTransport.contains(v)
      ? selectedTransport.remove(v)
      : selectedTransport.add(v);

  void toggleTravelType(String v) => selectedTravelTypes.contains(v)
      ? selectedTravelTypes.remove(v)
      : selectedTravelTypes.add(v);

  void selectTripType(String v) => selectedTripType.value = v;

  void setTransportMode(String v) => transportMode.value = v;

  void addTransportLeg() =>
      transportLegs.add(TransportLeg(id: _newLegId()));

  void removeTransportLeg(TransportLeg leg) {
    if (transportLegs.length <= 1) return; // keep at least one
    leg.dispose();
    transportLegs.remove(leg);
  }

  // -------------------------------------------------------------------------
  // Dates
  // -------------------------------------------------------------------------

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

  /// Date + time picker for a transport leg's arrival / departure.
  Future<void> pickLegDateTime(
      BuildContext context, TransportLeg leg, bool isArrival) async {
    final now = DateTime.now();
    final current =
    isArrival ? leg.arrivalTime.value : leg.departureTime.value;

    final date = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 1095)),
    );
    if (date == null) return;

    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? now),
    );

    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );

    if (isArrival) {
      leg.arrivalTime.value = dt;
    } else {
      leg.departureTime.value = dt;
    }
  }

  // -------------------------------------------------------------------------
  // Submit
  // -------------------------------------------------------------------------

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

    home.trips.add(trip);
    if (home.activeTrip.value == null) {
      home.activeTrip.value = trip;
    }
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

  int _legCounter = 0;
  String _newLegId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${_legCounter++}';

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
    for (final leg in transportLegs) {
      leg.dispose();
    }
    super.onClose();
  }
}