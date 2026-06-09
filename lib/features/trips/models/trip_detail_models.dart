import 'package:flutter/material.dart';
import '../../auth/controllers/account_selection_controller.dart';

class TripMember {
  final String id;
  final String name;
  final UserRole role;
  final String memberType;
  const TripMember({required this.id, required this.name, required this.role, required this.memberType});
}

class ItemComment {
  final String id;
  final String authorName;
  final String message;
  final String timeAgo;
  const ItemComment({required this.id, required this.authorName, required this.message, required this.timeAgo});
}

class PackingItem {
  final String id;
  final String name;
  final String emoji;
  final int quantity;
  final bool isCritical;
  bool isPacked;
  bool isExpanded;
  final List<ItemComment> comments;
  PackingItem({required this.id, required this.name, required this.emoji, required this.quantity, this.isCritical = false, this.isPacked = false, this.isExpanded = false, this.comments = const []});
}

class PackingBag {
  final String id;
  final String name;
  final double weightKg;
  final List<PackingItem> items;
  PackingBag({required this.id, required this.name, required this.weightKg, required this.items});
  int get packed => items.where((i) => i.isPacked).length;
  int get total => items.length;
  bool get isOverweight => weightKg > 23.0;
}

class PackingPerson {
  final String id;
  final String name;
  final String memberType;
  final double totalWeightKg;
  final List<PackingBag> bags;
  PackingPerson({required this.id, required this.name, required this.memberType, required this.totalWeightKg, required this.bags});
}

class HomePrepTask {
  final String id;
  final String label;
  bool isDone;
  HomePrepTask({required this.id, required this.label, this.isDone = false});
}

class HomePrepCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<HomePrepTask> tasks;
  HomePrepCategory({required this.id, required this.title, required this.icon, required this.iconColor, required this.tasks});
  int get completionPercent => tasks.isEmpty ? 0 : (tasks.where((t) => t.isDone).length * 100 ~/ tasks.length);
}

class TransportItem {
  final String id;
  final String transportType;
  final String? seatNumber;
  final DateTime bookingDateTime;
  const TransportItem({required this.id, required this.transportType, this.seatNumber, required this.bookingDateTime});
  String get displayTime {
    final h = bookingDateTime.hour;
    final m = bookingDateTime.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hr = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hr:$m $period';
  }
  String get displayDate {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[bookingDateTime.weekday - 1]}, ${months[bookingDateTime.month - 1]} ${bookingDateTime.day}';
  }
  String get displayLabel => seatNumber != null ? '$transportType (Seat : $seatNumber)' : transportType;
}

class ExpenseItem {
  final String id;
  final String name;
  final String category;
  final double amount;
  final String currency;
  final DateTime dateTime;
  const ExpenseItem({required this.id, required this.name, required this.category, required this.amount, required this.currency, required this.dateTime});
}

class AlertItem {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String timeAgo;
  const AlertItem({required this.id, required this.title, required this.description, required this.severity, required this.timeAgo});
  Color get titleColor {
    switch (severity) {
      case 'success': return const Color(0xFF22C55E);
      case 'warning': return const Color(0xFFF59E0B);
      default: return const Color(0xFF22C55E);
    }
  }
  IconData get icon {
    switch (severity) {
      case 'success': return Icons.check_circle_outline;
      case 'warning': return Icons.warning_amber_outlined;
      default: return Icons.wb_cloudy_outlined;
    }
  }
}

class HotelInfo {
  final String id;
  final String name;
  final String? roomNumber;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? address;
  const HotelInfo({required this.id, required this.name, this.roomNumber, this.checkIn, this.checkOut, this.address});
  String get displayLabel => roomNumber != null ? '$name · Room $roomNumber' : name;
}

class BodyPartData {
  final String key;
  final String name;
  final int packed;
  final int total;
  const BodyPartData({required this.key, required this.name, required this.packed, required this.total});
  String get status => total == 0 ? 'empty' : (packed == total ? 'complete' : 'partial');
  Color get statusColor {
    switch (status) {
      case 'complete': return const Color(0xFF22C55E);
      case 'partial': return const Color(0xFFF59E0B);
      default: return const Color(0xFF9CA3AF);
    }
  }
  String get displayCount => total == 0 ? 'No Items' : '$packed/$total packed';
}

class OverviewTimelineItem {
  final String id;
  final String label;
  final String time;
  final String date;
  final String? note;
  final String? badge;
  const OverviewTimelineItem({required this.id, required this.label, required this.time, required this.date, this.note, this.badge});
}

class GiftItem {
  final String id;
  final String name;
  final double price;
  final String forPerson;
  final String location;
  final String direction;
  String status;

  GiftItem({
    required this.id,
    required this.name,
    this.price = 0,
    required this.forPerson,
    this.location = '',
    required this.direction,
    this.status = 'unpacked',
  });
}