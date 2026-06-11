import 'package:get/get.dart';

class CoverageItem {
  final String label;
  final bool isCovered;
  const CoverageItem({required this.label, required this.isCovered});
}

class InsurancePolicy {
  final String id;
  final String provider;
  final String policyNo;
  final String validTill;
  final String coverage;
  final String status;
  final List<CoverageItem> checklist;
  final String emergencyNumber;
  final String availability;

  const InsurancePolicy({
    required this.id,
    required this.provider,
    required this.policyNo,
    required this.validTill,
    required this.coverage,
    required this.status,
    required this.checklist,
    required this.emergencyNumber,
    required this.availability,
  });
}

class PolicyStorageController extends GetxController {
  final RxList<InsurancePolicy> policies = <InsurancePolicy>[].obs;
  final RxString uploadedFileName = ''.obs;

  InsurancePolicy? get current => policies.isNotEmpty ? policies.first : null;

  bool get hasFile => uploadedFileName.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    policies.assignAll([
      const InsurancePolicy(
        id: 'ip1',
        provider: 'Allianz Travel',
        policyNo: '#TRV-123456',
        validTill: '25 Aug 2026',
        coverage: 'Medical, Trip Delay',
        status: 'Active',
        emergencyNumber: '+1 800 123 4567',
        availability: '24/7 Support',
        checklist: [
          CoverageItem(label: 'Medical Emergency', isCovered: true),
          CoverageItem(label: 'Trip Cancellation', isCovered: true),
          CoverageItem(label: 'Trip Delay',        isCovered: true),
          CoverageItem(label: 'Lost Baggage',      isCovered: false),
          CoverageItem(label: 'Personal Liability',isCovered: false),
        ],
      ),
    ]);
  }

  void pickFile() {
    uploadedFileName.value = 'policy_document.png';

  }

  void clearFile() => uploadedFileName.value = '';

  void addNewInsurance() {}
}
