import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';

class ExpenseTab extends StatelessWidget {
  final TripDetailController controller;
  const ExpenseTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final byCategory = controller.expenseByCategory;
      final total = controller.totalExpenses;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TotalCard(total: total, byCategory: byCategory),
          SizedBox(height: context.h(16)),
          _CategoryGrid(byCategory: byCategory),
          SizedBox(height: context.h(20)),
          AppText(data: 'Transactions', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          SizedBox(height: context.h(12)),
          ...controller.expenses.map((e) => Padding(
            padding: EdgeInsets.only(bottom: context.h(4)),
            child: _TransactionRow(expense: e),
          )),
          SizedBox(height: context.h(16)),
          Row(
            children: [
              Expanded(child: _DownloadButton(label: 'Download CSV', icon: Icons.download_outlined)),
              SizedBox(width: context.w(12)),
              Expanded(child: _DownloadButton(label: 'Download PDF', icon: Icons.download_outlined)),
            ],
          ),
          SizedBox(height: context.h(16)),
          if (controller.canEdit)
            AppButton(
              buttonText: 'Add Expense',
              onPressed: () => _showAddExpenseSheet(context, controller),
              borderRadius: 30,
              buttonHeight: 54,
            ),
        ],
      );
    });
  }
}

class _TotalCard extends StatelessWidget {
  final double total;
  final Map<String, double> byCategory;
  const _TotalCard({required this.total, required this.byCategory});

  @override
  Widget build(BuildContext context) {
    const colors = {
      'Food': Color(0xFF3B82F6), 'Transport': Color(0xFF22C55E),
      'Stay': Color(0xFFF59E0B), 'Shopping': Color(0xFF8B5CF6), 'Activities': Color(0xFFEF4444),
    };
    const cats = ['Food', 'Transport', 'Stay', 'Shopping', 'Activities'];

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: 'TOTAL SPENT', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          SizedBox(height: context.h(4)),
          AppText(data: '\$${total.toStringAsFixed(2)}', fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(12)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: cats.map((cat) {
                final pct = total == 0 ? 0.0 : (byCategory[cat] ?? 0) / total;
                return Expanded(
                  flex: (pct * 100).round().clamp(1, 100),
                  child: Container(height: context.h(8), color: colors[cat]),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: context.h(10)),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(6),
            children: cats.map((cat) => Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: context.w(10), height: context.w(10), decoration: BoxDecoration(color: colors[cat], shape: BoxShape.circle)),
              SizedBox(width: context.w(4)),
              AppText(data: cat, fontSize: 12, color: AppColors.textSecondary),
            ])).toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final Map<String, double> byCategory;
  const _CategoryGrid({required this.byCategory});

  @override
  Widget build(BuildContext context) {
    const cats = ['Food', 'Transport', 'Stay', 'Shopping', 'Activities'];
    const colors = {'Food': Color(0xFF3B82F6), 'Transport': Color(0xFF22C55E), 'Stay': Color(0xFFF59E0B), 'Shopping': Color(0xFF8B5CF6), 'Activities': Color(0xFFEF4444)};
    const icons = {'Food': Icons.restaurant_outlined, 'Transport': Icons.directions_bus_outlined, 'Stay': Icons.hotel_outlined, 'Shopping': Icons.shopping_bag_outlined, 'Activities': Icons.local_activity_outlined};
    const bgs = {'Food': Color(0xFFEFF6FF), 'Transport': Color(0xFFD1FAE5), 'Stay': Color(0xFFFEF3C7), 'Shopping': Color(0xFFEDE9FE), 'Activities': Color(0xFFFEE2E2)};

    return Column(children: [
      Row(children: cats.sublist(0, 2).map((cat) => Expanded(child: Padding(
        padding: EdgeInsets.only(right: cat == cats[0] ? context.w(10) : 0),
        child: _CatCard(cat: cat, amount: byCategory[cat] ?? 0, color: colors[cat]!, bg: bgs[cat]!, icon: icons[cat]!),
      ))).toList()),
      SizedBox(height: context.h(10)),
      Row(children: cats.sublist(2, 4).map((cat) => Expanded(child: Padding(
        padding: EdgeInsets.only(right: cat == cats[2] ? context.w(10) : 0),
        child: _CatCard(cat: cat, amount: byCategory[cat] ?? 0, color: colors[cat]!, bg: bgs[cat]!, icon: icons[cat]!),
      ))).toList()),
      SizedBox(height: context.h(10)),
      Row(children: [
        Expanded(child: _CatCard(cat: cats[4], amount: byCategory[cats[4]] ?? 0, color: colors[cats[4]]!, bg: bgs[cats[4]]!, icon: icons[cats[4]]!)),
        const Spacer(),
      ]),
    ]);
  }
}

class _CatCard extends StatelessWidget {
  final String cat;
  final double amount;
  final Color color;
  final Color bg;
  final IconData icon;
  const _CatCard({required this.cat, required this.amount, required this.color, required this.bg, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(children: [
        Container(width: context.w(38), height: context.w(38), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: color, size: context.sp(20))),
        SizedBox(width: context.w(8)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppText(data: cat, fontSize: 12, color: AppColors.textSecondary),
          AppText(data: '\$${amount.toInt()}', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ]),
      ]),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final ExpenseItem expense;
  const _TransactionRow({required this.expense});

  static const _icons = {'Food': Icons.restaurant_outlined, 'Transport': Icons.directions_bus_outlined, 'Stay': Icons.hotel_outlined, 'Shopping': Icons.shopping_bag_outlined, 'Activities': Icons.local_activity_outlined};
  static const _colors = {'Food': Color(0xFF3B82F6), 'Transport': Color(0xFF22C55E), 'Stay': Color(0xFFF59E0B), 'Shopping': Color(0xFF8B5CF6), 'Activities': Color(0xFFEF4444)};
  static const _bgs = {'Food': Color(0xFFEFF6FF), 'Transport': Color(0xFFD1FAE5), 'Stay': Color(0xFFFEF3C7), 'Shopping': Color(0xFFEDE9FE), 'Activities': Color(0xFFFEE2E2)};

  @override
  Widget build(BuildContext context) {
    final color = _colors[expense.category] ?? AppColors.primary;
    final bg = _bgs[expense.category] ?? AppColors.iconBg;
    final icon = _icons[expense.category] ?? Icons.receipt_outlined;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(10)),
      child: Row(children: [
        Container(width: context.w(42), height: context.w(42), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: color, size: context.sp(20))),
        SizedBox(width: context.w(12)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppText(data: expense.name, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          AppText(data: '${expense.currency} · Today ${expense.dateTime.hour}:${expense.dateTime.minute.toString().padLeft(2, '0')}', fontSize: 12, color: AppColors.textSecondary),
        ])),
        AppText(data: '\$${expense.amount.toInt()}', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ]),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _DownloadButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.h(12)),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(context.w(30)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: context.sp(16), color: AppColors.textSecondary),
          SizedBox(width: context.w(6)),
          AppText(data: label, fontSize: 13, color: AppColors.textSecondary),
        ]),
      ),
    );
  }
}

void _showAddExpenseSheet(BuildContext context, TripDetailController controller) {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final selectedCategory = Rxn<String>();
  final selectedCurrency = '฿'.obs;
  final selectedMember = (controller.members.isNotEmpty
      ? controller.members.first.name
      : '').obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
              'Enter details to track your expense',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.sync_disabled_outlined, color: Colors.grey.shade400, size: 15),
                  const SizedBox(width: 4),
                  Text('Rates cached offline', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ]),
                GestureDetector(
                  onTap: () {},
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.refresh, color: Colors.grey.shade500, size: 15),
                    const SizedBox(width: 4),
                    Text('Update rates', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Trip', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            _SheetDropdown<String>(
              value: controller.trip.destination,
              items: [controller.trip.destination],
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            AppTextField(controller: nameCtrl, label: 'Expense Name', hintText: 'e.g. Sushi Sora'),
            const SizedBox(height: 12),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            _SheetDropdown<String?>(
              value: selectedCategory.value,
              hint: 'Select Category',
              items: ['Food', 'Transport', 'Stay', 'Shopping', 'Activities'],
              onChanged: (v) => selectedCategory.value = v,
            ),
            const SizedBox(height: 12),
            const Text('Expense By', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            _SheetDropdown<String>(
              value: selectedMember.value.isNotEmpty ? selectedMember.value : null,
              items: controller.members.map((m) => m.name).toList(),
              onChanged: (v) { if (v != null) selectedMember.value = v; },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: amountCtrl,
              label: 'Amount',
              hintText: 'e.g. 80',
              keyboardType: TextInputType.number,
              suffixWidget: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: DropdownButton<String>(
                  value: selectedCurrency.value,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  onChanged: (v) { if (v != null) selectedCurrency.value = v; },
                  items: ['฿', '\$', '€', '£', '¥']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14))))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              buttonText: 'Save',
              onPressed: () {
                if (nameCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;
                if (selectedCategory.value == null) return;
                controller.addExpense(ExpenseItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text,
                  category: selectedCategory.value!,
                  amount: double.tryParse(amountCtrl.text) ?? 0,
                  currency: selectedCurrency.value,
                  dateTime: DateTime.now(),
                ));
                Get.back();
              },
              borderRadius: 30,
              buttonHeight: 52,
            ),
          ],
        )),
      ),
    ),
  );
}

class _SheetDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<T> items;
  final void Function(T?) onChanged;
  const _SheetDropdown({this.value, this.hint, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: hint != null ? Text(hint!, style: const TextStyle(color: Colors.grey)) : null,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        )).toList(),
      ),
    );
  }
}