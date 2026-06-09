import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/controllers/account_selection_controller.dart';
import '../../home/models/trip_model.dart';
import '../models/trip_detail_models.dart';
import '../views/trip_completed_page.dart';

class TripDetailController extends GetxController {
  final TripModel trip;
  TripDetailController({required this.trip});

  final currentTab = 0.obs;
  final packingView = 'list'.obs;
  final locationSharing = true.obs;
  final emergencyContactsEnabled = false.obs;
  final selectedTransportMode = 'Taxi'.obs;
  final showHotelForm = false.obs;
  final hasAcknowledgedGiftPrompt = false.obs;

  final tabScrollController = ScrollController();

  final RxList<PackingPerson> packingPersons = <PackingPerson>[].obs;
  final RxList<HomePrepCategory> homePrepCategories = <HomePrepCategory>[].obs;
  final RxList<TransportItem> transports = <TransportItem>[].obs;
  final RxList<TripMember> members = <TripMember>[].obs;
  final RxList<ExpenseItem> expenses = <ExpenseItem>[].obs;
  final RxList<AlertItem> alerts = <AlertItem>[].obs;
  final RxList<HotelInfo> hotels = <HotelInfo>[].obs;
  final RxList<BodyPartData> bodyParts = <BodyPartData>[].obs;
  final RxList<OverviewTimelineItem> overviewTimeline = <OverviewTimelineItem>[].obs;
  final RxList<GiftItem> gifts = <GiftItem>[].obs;

  UserRole? get role => StorageService.userRole;
  bool get isOwner => role == UserRole.owner;
  bool get isEditor => role == UserRole.editor;
  bool get isViewer => role == UserRole.viewer;
  bool get canEdit => isOwner || isEditor;

  int get criticalRemaining =>
      packingPersons.expand((p) => p.bags.expand((b) => b.items)).where((i) => i.isCritical && !i.isPacked).length;

  int get totalGifts => gifts.length;
  int get packedGifts => gifts.where((g) => g.status == 'packed' || g.status == 'delivered').length;
  int get pendingGifts => gifts.where((g) => g.status == 'unpacked').length;

  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);

  Map<String, double> get expenseByCategory {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    overviewTimeline.assignAll([
      const OverviewTimelineItem(id: 'o1', label: 'Final Pack Check', time: '04:00 PM', date: 'Sun, Jul 12'),
      const OverviewTimelineItem(id: 'o2', label: 'Leave Home', time: '04:00 PM', date: 'Sun, Jul 12', note: 'Traffic is light. 45 min drive.'),
      const OverviewTimelineItem(id: 'o3', label: 'Arrive Airport (NRT)', time: '04:00 PM', date: 'Sun, Jul 12', badge: 'Direction of Airport from you.'),
      const OverviewTimelineItem(id: 'o4', label: 'Boarding Flight JL001', time: '04:00 PM', date: 'Sun, Jul 12', badge: 'Airport/Transit Mode'),
    ]);

    packingPersons.assignAll([
      PackingPerson(
        id: 'p1', name: 'Emma', memberType: 'Baby', totalWeightKg: 90,
        bags: [
          PackingBag(
            id: 'b1', name: 'BACKPACK', weightKg: 12,
            items: [
              PackingItem(id: 'i1', name: 'Iphone', emoji: '📱', quantity: 1, isCritical: true, isPacked: false, isExpanded: true, comments: [const ItemComment(id: 'c1', authorName: 'Ovie Rahaman', message: "Don't take this. We don't need this", timeAgo: '2 min ago')]),
              PackingItem(id: 'i2', name: 'Teddy Bear', emoji: '🧸', quantity: 1, isPacked: true),
              PackingItem(id: 'i3', name: 'Teddy Bear', emoji: '🧸', quantity: 1, isPacked: true),
            ],
          ),
        ],
      ),
      PackingPerson(
        id: 'p2', name: 'Emma', memberType: 'Baby', totalWeightKg: 90,
        bags: [
          PackingBag(
            id: 'b2', name: 'BACKPACK', weightKg: 27.2,
            items: [
              PackingItem(id: 'i4', name: 'Iphone', emoji: '📱', quantity: 1, isCritical: true, isPacked: false),
              PackingItem(id: 'i5', name: 'Teddy Bear', emoji: '🧸', quantity: 1, isPacked: true),
              PackingItem(id: 'i6', name: 'Teddy Bear', emoji: '🧸', quantity: 1, isPacked: true),
            ],
          ),
        ],
      ),
    ]);

    homePrepCategories.assignAll([
      HomePrepCategory(
        id: 'hc1', title: 'Home Prep', icon: Icons.home_outlined, iconColor: const Color(0xFF3B82F6),
        tasks: [
          HomePrepTask(id: 't1', label: 'Empty fridge of perishables'),
          HomePrepTask(id: 't2', label: 'Take out trash & recycling', isDone: true),
          HomePrepTask(id: 't3', label: 'Run dishwasher'),
          HomePrepTask(id: 't4', label: 'Set thermostat to away'),
        ],
      ),
      HomePrepCategory(
        id: 'hc2', title: 'Security', icon: Icons.shield_outlined, iconColor: const Color(0xFFF59E0B),
        tasks: [
          HomePrepTask(id: 't5', label: 'Lock all back windows'),
          HomePrepTask(id: 't6', label: 'Lock garage door', isDone: true),
          HomePrepTask(id: 't7', label: 'Set security alarm'),
          HomePrepTask(id: 't8', label: 'Notify neighbor (Dave)'),
        ],
      ),
    ]);

    transports.assignAll([
      TransportItem(id: 'tr1', transportType: 'Car', bookingDateTime: DateTime(2026, 7, 12, 16, 0)),
      TransportItem(id: 'tr2', transportType: 'Flight', seatNumber: '4/A', bookingDateTime: DateTime(2026, 7, 12, 18, 0)),
      TransportItem(id: 'tr3', transportType: 'Train', bookingDateTime: DateTime(2026, 7, 13, 5, 0)),
    ]);

    members.assignAll([
      const TripMember(id: 'm1', name: 'Alex', role: UserRole.owner, memberType: 'Adult'),
      const TripMember(id: 'm2', name: 'Sarah', role: UserRole.editor, memberType: 'Adult'),
      const TripMember(id: 'm3', name: 'Emma', role: UserRole.viewer, memberType: 'Adult'),
    ]);

    final now = DateTime.now();
    expenses.assignAll([
      ExpenseItem(id: 'e1', name: 'Sushi Sora', category: 'Food', amount: 64, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e2', name: 'JR East Ticket', category: 'Transport', amount: 12, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e3', name: 'Uniqlo Ginza', category: 'Shopping', amount: 45, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e4', name: 'Park Hyatt Tokyo', category: 'Stay', amount: 205, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e5', name: 'Ramen Ichiran', category: 'Food', amount: 28, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e6', name: 'Tokyo Metro Pass', category: 'Transport', amount: 80, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e7', name: 'Shibuya Hotel', category: 'Stay', amount: 205, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e8', name: 'Zara Tokyo', category: 'Shopping', amount: 31, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e9', name: 'TeamLab', category: 'Activities', amount: 58, currency: 'USD', dateTime: now),
      ExpenseItem(id: 'e10', name: 'Sukiyabashi Jiro', category: 'Food', amount: 92, currency: 'USD', dateTime: now),
    ]);

    alerts.assignAll([
      const AlertItem(id: 'a1', title: 'Weather Advisory', description: 'Light rain expected at LHR. Pack a compact umbrella.', severity: 'info', timeAgo: '2h Ago'),
      const AlertItem(id: 'a2', title: 'No Travel Warnings', description: 'London Zone 1 — safe to travel. No advisories in effect.', severity: 'success', timeAgo: '4h Ago'),
      const AlertItem(id: 'a3', title: 'JFK Terminal 2 Busy', description: 'Heavier than usual crowds at security. Allow extra 20 mins.', severity: 'warning', timeAgo: '41m Ago'),
    ]);

    hotels.assignAll([
      const HotelInfo(id: 'h1', name: 'Memoria Lisboa', roomNumber: '412', address: 'Rua Nova do Almada 114'),
    ]);

    bodyParts.assignAll([
      const BodyPartData(key: 'head', name: 'Head', packed: 0, total: 0),
      const BodyPartData(key: 'ears', name: 'Ears', packed: 0, total: 1),
      const BodyPartData(key: 'torso', name: 'Torso', packed: 0, total: 1),
      const BodyPartData(key: 'waist', name: 'Waist', packed: 0, total: 1),
      const BodyPartData(key: 'hands', name: 'Hands', packed: 0, total: 0),
      const BodyPartData(key: 'feet', name: 'Feed', packed: 0, total: 0),
    ]);

    gifts.assignAll([
      GiftItem(id: 'g1', name: 'Silk Scarf', price: 45, forPerson: 'Sarah', location: 'Kyoto Market', direction: 'giver', status: 'packed'),
      GiftItem(id: 'g2', name: 'Silk Scarf', price: 45, forPerson: 'Sarah', location: 'Kyoto Market', direction: 'giver', status: 'packed'),
      GiftItem(id: 'g3', name: 'Silk Scarf', price: 45, forPerson: 'Sarah', location: 'Kyoto Market', direction: 'carrier', status: 'unpacked'),
    ]);
  }

  void switchTab(int index) => currentTab.value = index;

  void togglePackingItem(String personId, String bagId, String itemId) {
    final person = packingPersons.firstWhere((p) => p.id == personId);
    final bag = person.bags.firstWhere((b) => b.id == bagId);
    final item = bag.items.firstWhere((i) => i.id == itemId);
    item.isPacked = !item.isPacked;
    packingPersons.refresh();
  }

  void toggleItemExpanded(String personId, String bagId, String itemId) {
    final person = packingPersons.firstWhere((p) => p.id == personId);
    final bag = person.bags.firstWhere((b) => b.id == bagId);
    final item = bag.items.firstWhere((i) => i.id == itemId);
    item.isExpanded = !item.isExpanded;
    packingPersons.refresh();
  }

  void addItemToBag(String personId, String bagId, PackingItem item) {
    final person = packingPersons.firstWhere((p) => p.id == personId);
    final bag = person.bags.firstWhere((b) => b.id == bagId);
    bag.items.add(item);
    packingPersons.refresh();
  }

  void addBagToPerson(String personId, PackingBag bag) {
    final person = packingPersons.firstWhere((p) => p.id == personId);
    person.bags.add(bag);
    packingPersons.refresh();
  }

  void addPackingPerson(PackingPerson person) => packingPersons.add(person);

  void toggleHomePrepTask(String categoryId, String taskId) {
    final cat = homePrepCategories.firstWhere((c) => c.id == categoryId);
    final task = cat.tasks.firstWhere((t) => t.id == taskId);
    task.isDone = !task.isDone;
    homePrepCategories.refresh();
  }

  void addHomePrepTask(String categoryId, String label) {
    final cat = homePrepCategories.firstWhere((c) => c.id == categoryId);
    cat.tasks.add(HomePrepTask(id: DateTime.now().millisecondsSinceEpoch.toString(), label: label));
    homePrepCategories.refresh();
  }

  void addTransport(TransportItem item) => transports.add(item);

  void addMember(TripMember member) => members.add(member);

  void removeMember(String memberId) {
    if (!isOwner) return;
    members.removeWhere((m) => m.id == memberId);
  }

  void addExpense(ExpenseItem expense) => expenses.add(expense);

  void addHotel(HotelInfo hotel) {
    hotels.assignAll([hotel]);
    showHotelForm.value = false;
  }

  void addGift(GiftItem gift) => gifts.add(gift);

  void deleteGift(String id) => gifts.removeWhere((g) => g.id == id);

  void updateGiftStatus(String id, String status) {
    final idx = gifts.indexWhere((g) => g.id == id);
    if (idx == -1) return;
    final g = gifts[idx];
    gifts[idx] = GiftItem(id: g.id, name: g.name, price: g.price, forPerson: g.forPerson, location: g.location, direction: g.direction, status: status);
  }

  void updateGift(String id, String name, double price, String forPerson, String location, String direction, String status) {
    final idx = gifts.indexWhere((g) => g.id == id);
    if (idx == -1) return;
    gifts[idx] = GiftItem(id: id, name: name, price: price, forPerson: forPerson, location: location, direction: direction, status: status);
  }

  void endTrip() {
    if (!isOwner) return;
    AppNavigation.push(TripCompletedPage(trip: trip));
  }

  @override
  void onClose() {
    tabScrollController.dispose();
    super.onClose();
  }
}