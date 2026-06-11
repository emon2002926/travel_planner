import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import 'package:travel_planner/features/vault/views/vault_page.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/controllers/account_selection_controller.dart';
import '../../dual_clock/views/dual_clock_page.dart';
import '../../expance/views/expenses_page.dart';
import '../../packing_temp/views/packing_templates_page.dart';
import '../../trips/views/add_new_trip_page.dart';
import '../../trips/views/trip_detail_page.dart';
import '../models/trip_model.dart';
import '../views/currency_page.dart';
import '../views/health_requirements_page.dart';
import '../views/policy_storage_page.dart';
import '../views/vaccination_page.dart';
import '../views/visa_checker_page.dart';


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

  List<TripActionItem>  ownerActionList (BuildContext context) => [
    TripActionItem(label: 'New Trip', icon: Icons.flight_takeoff,
        onTap: (){
      AppNavigation.push(AddNewTripPage());
        }
    ),
     TripActionItem(label: 'Expenses', icon: Icons.monetization_on_outlined,onTap: (){
      AppNavigation.push(ExpensesPage());
    }),
     TripActionItem(label: 'Vault', icon: Icons.work_outline,onTap: (){AppNavigation.push(VaultPage(),context: context);}),
     TripActionItem(label: 'Converter', icon: Icons.attach_money,onTap: (){AppNavigation.push(CurrencyPage(),context: context);}),
     TripActionItem(label: 'Vaccine', icon: Icons.vaccines_outlined,onTap: (){AppNavigation.push(VaccinationPage(),context: context);}),
     TripActionItem(label: 'Visa Check', icon: Icons.location_on_outlined,onTap: (){AppNavigation.push(VisaCheckerPage(),context: context);}),
     TripActionItem(label: 'Health', icon: Icons.favorite_border,onTap: (){AppNavigation.push(HealthRequirementsPage(),context: context);}),
     TripActionItem(label: 'Dual Clock', icon: Icons.schedule,onTap: (){AppNavigation.push(DualClockPage(),context: context);}),
     TripActionItem(label: 'Policy', icon: Icons.shield_outlined,onTap: (){AppNavigation.push(PolicyStoragePage(),context: context);}),
     TripActionItem(label: 'Templates', icon: Icons.cases_outlined,onTap: (){AppNavigation.push(PackingTemplatesPage(),context: context);}),
  ];

  List<TripActionItem> get otherRoleAction => const [
    TripActionItem(label: 'Converter', icon: Icons.attach_money),
    TripActionItem(label: 'Group Chats', icon: Icons.chat_bubble_outline),
    TripActionItem(label: 'Offline Vault', icon: Icons.work_outline),
  ];



  @override
  void onInit() {
    super.onInit();
    role.value = StorageService.userRole ?? UserRole.viewer;

    // _seedDemoData();
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

  void createTrip() {
    AppNavigation.push(AddNewTripPage());
  }
  void startPacking() {}
  void onActionTap(String label) {}
  void onTripTap(TripModel trip) {
    AppNavigation.push(TripDetailPage(trip: trip));
  }
  void editTrip(TripModel trip) {}
  void openNotifications() {}
}