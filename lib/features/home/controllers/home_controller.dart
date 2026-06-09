import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import '../../auth/controllers/account_selection_controller.dart';
import '../../trips/views/trip_detail_page.dart';
import '../models/trip_model.dart';


class HomeController extends GetxController {
  final RxList<TripModel> trips = <TripModel>[].obs;
  final Rxn<TripModel> activeTrip = Rxn<TripModel>();

  final RxString userName = 'Derik'.obs;
  final RxInt offlineDocsCount = 2.obs;
  final RxBool hasNotification = true.obs;

  final Rx<UserRole> role = UserRole.viewer.obs;

  bool get isOwner => role.value == UserRole.owner;
  bool get isEditor => role.value == UserRole.editor;
  bool get isViewer => role.value == UserRole.viewer;

  bool get canCreate => isOwner;
  bool get canEdit => isOwner || isEditor;

  TripState get tripState => activeTrip.value?.state ?? TripState.none;

  bool get hasActiveTrip => tripState == TripState.active;
  bool get isTripCompleted => tripState == TripState.completed;
  bool get hasNoTrip => tripState == TripState.none;

  String get headline {
    if (hasActiveTrip) return 'Calm trip ahead.';
    return 'Explore With Ease';
  }

  List<TripModel> get upcomingTrips =>
      trips.where((t) => t.state == TripState.active).toList();

  List<TripActionItem> get ownerActionList => const [
    TripActionItem(label: 'New Trip', icon: Icons.flight_takeoff),
    TripActionItem(label: 'Expenses', icon: Icons.monetization_on_outlined),
    TripActionItem(label: 'Vault', icon: Icons.work_outline),
    TripActionItem(label: 'Converter', icon: Icons.attach_money),
    TripActionItem(label: 'Vaccine', icon: Icons.vaccines_outlined),
    TripActionItem(label: 'Visa Check', icon: Icons.location_on_outlined),
    TripActionItem(label: 'Health', icon: Icons.favorite_border),
    TripActionItem(label: 'Dual Clock', icon: Icons.schedule),
    TripActionItem(label: 'Policy', icon: Icons.shield_outlined),
    TripActionItem(label: 'Templates', icon: Icons.cases_outlined),
  ];

  List<TripActionItem> get otherRoleAction => const [
    TripActionItem(label: 'Converter', icon: Icons.attach_money),
    TripActionItem(label: 'Group Chats', icon: Icons.chat_bubble_outline),
    TripActionItem(label: 'Offline Vault', icon: Icons.work_outline),
  ];

  @override
  void onInit() {
    super.onInit();
    _seedDemoData();
  }

  void _seedDemoData() {
    activeTrip.value = TripModel(
      id: 't1',
      destination: 'Tokyo, Japan',
      dateRange: 'April 24 - May 3',
      duration: '9 Days',
      readyPercent: 72,
      daysLeft: 3,
      packedItems: 36,
      totalItems: 42,
      pendingTasks: 2,
      weatherTemp: '24° C',
      weatherCondition: 'SUNNY',
      state: TripState.active,
    );

    trips.assignAll([
      TripModel(
        id: 'u1',
        destination: 'New Trip 1',
        dateRange: 'Aug 1 - Aug 3',
        duration: '3 Days',
        partySize: 'Solo',
        readyPercent: 10,
        state: TripState.active,
      ),
      TripModel(
        id: 'u2',
        destination: 'New Trip 2',
        dateRange: 'Aug 1 - Aug 3',
        duration: '3 Days',
        partySize: 'Solo',
        readyPercent: 10,
        state: TripState.active,
      ),
    ]);
  }

  void showNoTrip() => activeTrip.value = null;
  void showActiveTrip() => _seedDemoData();

  void showCompletedTrip() {
    activeTrip.value = TripModel(
      id: 't1',
      destination: 'Tokyo, Ladhak',
      dateRange: 'April 24 - May 3',
      duration: '9 Days',
      state: TripState.completed,
      spend: 480,
      recap:
      'You walked 87 km, tried 14 new dishes, and visited landmarks. Best day: Sintra.',
    );
  }

  void createTrip() {}
  void startPacking() {}
  void onActionTap(String label) {}
  void onTripTap(TripModel trip) {
    AppNavigation.push(TripDetailPage(trip: trip));
  }
  void editTrip(TripModel trip) {}
  void openNotifications() {}
}