import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotificationType { packing, hotel, boarding, gate, flight }
enum NotificationFilter { all, unread }

class AppNotification {
  final String id;
  final String message;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id, message: message, timeAgo: timeAgo, type: type,
    isRead: isRead ?? this.isRead,
  );
}

class NotificationController extends GetxController {
  final Rx<NotificationFilter> activeFilter = NotificationFilter.all.obs;
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  List<AppNotification> get filtered {
    if (activeFilter.value == NotificationFilter.all) return notifications;
    return notifications.where((n) => !n.isRead).toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  static IconData iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.packing:  return Icons.inventory_2_outlined;
      case NotificationType.hotel:    return Icons.check_circle_outline;
      case NotificationType.boarding: return Icons.trending_up_outlined;
      case NotificationType.gate:     return Icons.trending_up_outlined;
      case NotificationType.flight:   return Icons.access_time_outlined;
    }
  }

  static Color bgColorFor(NotificationType type) {
    switch (type) {
      case NotificationType.packing:  return const Color(0xFFDBEAFE);
      case NotificationType.hotel:    return const Color(0xFFD1FAE5);
      case NotificationType.boarding: return const Color(0xFFFEF9C3);
      case NotificationType.gate:     return const Color(0xFFFEF9C3);
      case NotificationType.flight:   return const Color(0xFFDBEAFE);
    }
  }

  static Color iconColorFor(NotificationType type) {
    switch (type) {
      case NotificationType.packing:  return const Color(0xFF1D4ED8);
      case NotificationType.hotel:    return const Color(0xFF16A34A);
      case NotificationType.boarding: return const Color(0xFFD97706);
      case NotificationType.gate:     return const Color(0xFFD97706);
      case NotificationType.flight:   return const Color(0xFF2563EB);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    notifications.assignAll([
      const AppNotification(id: 'n1', message: 'You\'re 72% packed 6 items remaining',                              timeAgo: '1h ago',    type: NotificationType.packing,  isRead: true),
      const AppNotification(id: 'n2', message: 'Hotel booking confirmed at The Grand Plaza Check-in Dec 15.',        timeAgo: '4h ago',    type: NotificationType.hotel,    isRead: true),
      const AppNotification(id: 'n3', message: 'Boarding in 45 min head to Gate B12',                               timeAgo: '21h ago',   type: NotificationType.boarding, isRead: true),
      const AppNotification(id: 'n4', message: 'Your assigned gate has been changed. Please proceed to Gate 2 for transit.', timeAgo: '21h ago', type: NotificationType.gate,  isRead: true),
      const AppNotification(id: 'n5', message: 'Your flight is 10 min late',                                        timeAgo: '5 sec ago', type: NotificationType.flight,   isRead: false),
    ]);
  }

  void setFilter(NotificationFilter filter) => activeFilter.value = filter;

  void markRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    notifications[idx] = notifications[idx].copyWith(isRead: true);
    notifications.refresh();
  }

  void markAllRead() {
    notifications.assignAll(notifications.map((n) => n.copyWith(isRead: true)).toList());
  }
}
