import 'package:get/get.dart';

class SafetyContact {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isActiveNow;
  final String? lastActiveLabel;
  bool isSelected;

  SafetyContact({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isActiveNow = false,
    this.lastActiveLabel,
    this.isSelected = false,
  });
}

class EmergencyNumber {
  final String id;
  final String number;
  final String label;
  const EmergencyNumber({required this.id, required this.number, required this.label});
}

class SafetyController extends GetxController {
  final RxBool emergencyModeActive  = true.obs;
  final RxBool locationSharing      = true.obs;
  final RxString country            = 'Japan'.obs;

  final RxList<SafetyContact>   contacts        = <SafetyContact>[].obs;
  final RxList<EmergencyNumber> emergencyNumbers = <EmergencyNumber>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    contacts.assignAll([
      SafetyContact(id: 'sc1', name: 'Alex',  isActiveNow: false, lastActiveLabel: '2 min ago active', isSelected: false),
      SafetyContact(id: 'sc2', name: 'Sarah', isActiveNow: true,  isSelected: true),
    ]);

    emergencyNumbers.assignAll([
      const EmergencyNumber(id: 'en1', number: '119', label: 'Ambulance / Fire'),
      const EmergencyNumber(id: 'en2', number: '110', label: 'Police'),
    ]);
  }

  void toggleContact(String id) {
    final idx = contacts.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    contacts[idx].isSelected = !contacts[idx].isSelected;
    contacts.refresh();
  }

  void toggleLocationSharing(bool val) => locationSharing.value = val;

  void toggleEmergencyMode() => emergencyModeActive.value = !emergencyModeActive.value;

  void sendLocation() {}

  void callNumber(String number) {}
}