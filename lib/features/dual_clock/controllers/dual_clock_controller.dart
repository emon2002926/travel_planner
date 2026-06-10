import 'dart:async';
import 'package:get/get.dart';

class TimeZoneOption {
  final String city;
  final String label;
  final int gmtOffset;
  const TimeZoneOption({required this.city, required this.label, required this.gmtOffset});
}

class DualClockController extends GetxController {
  final RxBool is12Hour = true.obs;
  final RxInt homeOffset = 6.obs;
  final RxInt destOffset = 2.obs;
  final RxString homeCity = 'HOME'.obs;
  final RxString destCity = 'NEW YORK'.obs;

  final Rx<DateTime> _now = DateTime.now().toUtc().obs;
  Timer? _timer;

  static const zones = [
    TimeZoneOption(city: 'HOME',        label: 'GMT+6',  gmtOffset: 6),
    TimeZoneOption(city: 'NEW YORK',    label: 'GMT-4',  gmtOffset: -4),
    TimeZoneOption(city: 'LONDON',      label: 'GMT+1',  gmtOffset: 1),
    TimeZoneOption(city: 'DUBAI',       label: 'GMT+4',  gmtOffset: 4),
    TimeZoneOption(city: 'TOKYO',       label: 'GMT+9',  gmtOffset: 9),
    TimeZoneOption(city: 'SYDNEY',      label: 'GMT+10', gmtOffset: 10),
    TimeZoneOption(city: 'LOS ANGELES', label: 'GMT-7',  gmtOffset: -7),
    TimeZoneOption(city: 'PARIS',       label: 'GMT+2',  gmtOffset: 2),
    TimeZoneOption(city: 'SINGAPORE',   label: 'GMT+8',  gmtOffset: 8),
  ];

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _now.value = DateTime.now().toUtc());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  DateTime _localTime(int offset) => _now.value.add(Duration(hours: offset));

  DateTime get homeTime => _localTime(homeOffset.value);
  DateTime get destTime => _localTime(destOffset.value);

  String formatTime(DateTime dt) {
    if (is12Hour.value) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String amPm(DateTime dt) => dt.hour < 12 ? 'AM' : 'PM';

  String get homeCityLabel => '${homeCity.value}(GMT${homeOffset.value >= 0 ? '+' : ''}${homeOffset.value})';
  String get destCityLabel  => '${destCity.value}(GMT${destOffset.value >= 0 ? '+' : ''}${destOffset.value})';

  String get diffLabel {
    final diff = (destOffset.value - homeOffset.value).abs();
    final direction = destOffset.value < homeOffset.value ? 'BEHIND' : 'AHEAD';
    return 'DESTINATION IS $diff HOURS $direction';
  }

  void setHomeZone(TimeZoneOption z) {
    homeCity.value   = z.city;
    homeOffset.value = z.gmtOffset;
  }

  void setDestZone(TimeZoneOption z) {
    destCity.value   = z.city;
    destOffset.value = z.gmtOffset;
  }
}
