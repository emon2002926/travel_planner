import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expenses_controller.dart';

class ExpenseTransaction {
  final String id;
  final String name;
  final String category;
  final double amount;
  final String currency;
  final DateTime dateTime;

  const ExpenseTransaction({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.currency,
    required this.dateTime,
  });
}

class ExpenseDetailController extends GetxController {
  final ExpenseSummaryItem item;
  ExpenseDetailController({required this.item});

  final double plannedTotal = 240.0;

  final RxList<ExpenseTransaction> transactions = <ExpenseTransaction>[].obs;

  static const categoryColors = {
    'Food':       Color(0xFF3B82F6),
    'Transport':  Color(0xFF22C55E),
    'Stay':       Color(0xFFF59E0B),
    'Shopping':   Color(0xFFA855F7),
    'Activities': Color(0xFFEF4444),
  };

  static const categoryIcons = {
    'Food':       Icons.restaurant_outlined,
    'Transport':  Icons.directions_bus_outlined,
    'Stay':       Icons.hotel_outlined,
    'Shopping':   Icons.shopping_bag_outlined,
    'Activities': Icons.local_activity_outlined,
  };

  static const transactionIcons = {
    'Food':       Icons.set_meal_outlined,
    'Transport':  Icons.train_outlined,
    'Stay':       Icons.apartment_outlined,
    'Shopping':   Icons.checkroom_outlined,
    'Activities': Icons.confirmation_number_outlined,
  };

  double get totalSpent => transactions.fold(0, (sum, t) => sum + t.amount);

  Map<String, double> get byCategory {
    final map = <String, double>{};
    for (final t in transactions) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    transactions.assignAll([
      ExpenseTransaction(id: 'et1', name: 'Sushi Sora',         category: 'Food',       amount: 64,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et2', name: 'JR East Ticket',     category: 'Transport',  amount: 12,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et3', name: 'Uniqlo Ginza',       category: 'Shopping',   amount: 45,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et4', name: 'Park Hyatt Tokyo',   category: 'Stay',       amount: 205, currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et5', name: 'Ramen Ichiran',      category: 'Food',       amount: 28,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et6', name: 'Tokyo Metro Pass',   category: 'Transport',  amount: 80,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et7', name: 'Shibuya Hotel',      category: 'Stay',       amount: 205, currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et8', name: 'Zara Tokyo',         category: 'Shopping',   amount: 31,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et9', name: 'TeamLab',            category: 'Activities', amount: 58,  currency: 'USD', dateTime: now),
      ExpenseTransaction(id: 'et10', name: 'Sukiyabashi Jiro',  category: 'Food',       amount: 92,  currency: 'USD', dateTime: now),
    ]);
  }

  void addTransaction(ExpenseTransaction t) => transactions.add(t);
}
