import 'package:get/get.dart';

enum VisaCheckState { idle, loading, result }
enum VisaStatus { ok, expired, invalid }

class VisaCheckerController extends GetxController {
  final Rx<VisaCheckState> state     = VisaCheckState.idle.obs;
  final Rx<VisaStatus>     status    = VisaStatus.ok.obs;
  final RxString           fileName  = ''.obs;
  final RxString           visaEndDate = ''.obs;

  bool get hasFile => fileName.value.isNotEmpty;

  void pickFile() {
    // Wire real file picker here later
    fileName.value = 'visa_document.pdf';
  }

  void clearFile() {
    fileName.value = '';
    state.value = VisaCheckState.idle;
  }

  Future<void> checkVisa() async {
    if (!hasFile) return;
    state.value = VisaCheckState.loading;
    // Simulate API call — replace with real call later
    await Future.delayed(const Duration(milliseconds: 1200));
    status.value    = VisaStatus.ok;
    visaEndDate.value = '18 June 2026';
    state.value     = VisaCheckState.result;
  }

  void checkAgain() {
    fileName.value    = '';
    visaEndDate.value = '';
    state.value       = VisaCheckState.idle;
  }

  String get statusLabel {
    switch (status.value) {
      case VisaStatus.ok:      return 'OK';
      case VisaStatus.expired: return 'Expired';
      case VisaStatus.invalid: return 'Invalid';
    }
  }
}
