import '../../auth/controllers/account_selection_controller.dart';

import 'package:flutter/material.dart';

enum TripState { none, active, completed }

class TripModel {
  final String id;
  final String destination;
  final String dateRange;
  final String duration;
  final String? imageUrl;
  final String partySize;
  final int readyPercent;
  final int daysLeft;
  final int packedItems;
  final int totalItems;
  final int pendingTasks;
  final String weatherTemp;
  final String weatherCondition;
  final TripState state;
  final int? spend;
  final String? recap;

  TripModel({
    required this.id,
    required this.destination,
    required this.dateRange,
    required this.duration,
    this.imageUrl,
    this.partySize = 'Solo',
    this.readyPercent = 0,
    this.daysLeft = 0,
    this.packedItems = 0,
    this.totalItems = 0,
    this.pendingTasks = 0,
    this.weatherTemp = '',
    this.weatherCondition = '',
    this.state = TripState.active,
    this.spend,
    this.recap,
  });
}

class TripActionItem {
  final String label;
  final IconData icon;
  final UserRole minRole;
  final VoidCallback? onTap;

  const TripActionItem({
    required this.label,
    required this.icon,
    this.minRole = UserRole.viewer,  this.onTap,
  });
}