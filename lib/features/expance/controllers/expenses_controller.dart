import 'package:get/get.dart';

class ExpenseSummaryItem {
  final String id;
  final String destination;
  final double totalSpent;
  final String currency;
  final String? imageUrl;

  const ExpenseSummaryItem({
    required this.id,
    required this.destination,
    required this.totalSpent,
    required this.currency,
    this.imageUrl,
  });
}

class ExpensesController extends GetxController {
  final RxList<ExpenseSummaryItem> trips = <ExpenseSummaryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    trips.assignAll([
      const ExpenseSummaryItem(id: 'es1', destination: 'Tokyo, Japan', totalSpent: 67000, currency: 'USD'),
      const ExpenseSummaryItem(id: 'es2', destination: 'Tokyo, Japan', totalSpent: 67000, currency: 'USD'),
      const ExpenseSummaryItem(id: 'es3', destination: 'Tokyo, Japan', totalSpent: 67000, currency: 'USD'),
      const ExpenseSummaryItem(id: 'es4', destination: 'Tokyo, Japan', totalSpent: 67000, currency: 'USD'),
      const ExpenseSummaryItem(id: 'es5', destination: 'Tokyo, Japan', totalSpent: 67000, currency: 'USD'),
    ]);
  }
}
