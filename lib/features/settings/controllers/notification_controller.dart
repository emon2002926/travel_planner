import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem {
  final String message;
  final String time;
  final Color iconBgColor;
  final IconData icon;
  final Color iconColor;

  const NotificationItem({
    required this.message,
    required this.time,
    required this.iconBgColor,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationController extends GetxController {
  final RxBool showAll = true.obs;

  void switchTab(bool all) => showAll.value = all;

  final List<NotificationItem> notifications = const [
    NotificationItem(
      message: "You're 72% packed 6 items remaining",
      time: '1h ago',
      iconBgColor: Color(0xFFDBEAFE),
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFF1C4DB8),
    ),
    NotificationItem(
      message: 'Hotel booking confirmed at The Grand Plaza Check-in Dec 15.',
      time: '4h ago',
      iconBgColor: Color(0xFFDCFCE7),
      icon: Icons.check_circle_outline,
      iconColor: Color(0xFF22C55E),
    ),
    NotificationItem(
      message: 'Boarding in 45 min head to Gate B12',
      time: '21h ago',
      iconBgColor: Color(0xFFFEF9C3),
      icon: Icons.trending_up,
      iconColor: Color(0xFFF59E0B),
    ),
    NotificationItem(
      message:
      'Your assigned gate has been changed. Please proceed to Gate 2 for transit.',
      time: '21h ago',
      iconBgColor: Color(0xFFFEF9C3),
      icon: Icons.trending_up,
      iconColor: Color(0xFFF59E0B),
    ),
    NotificationItem(
      message: 'Your flight is 10 min late',
      time: '5 sec ago',
      iconBgColor: Color(0xFFDBEAFE),
      icon: Icons.access_time,
      iconColor: Color(0xFF1C4DB8),
    ),
  ];
}