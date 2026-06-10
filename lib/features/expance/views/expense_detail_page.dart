import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/expense_detail_controller.dart';
import '../controllers/expenses_controller.dart';

class ExpenseDetailPage extends StatelessWidget {
  final ExpenseSummaryItem item;
  const ExpenseDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExpenseDetailController>()) {
      Get.put(ExpenseDetailController(item: item));
    } else if (Get.find<ExpenseDetailController>().item.id != item.id) {
      Get.delete<ExpenseDetailController>(force: true);
      Get.put(ExpenseDetailController(item: item));
    }
    final controller = Get.find<ExpenseDetailController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _DetailHero(item: item),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.w(16),
                  context.h(16),
                  context.w(16),
                  context.h(32),
                ),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OfflineSyncRow(),
                    SizedBox(height: context.h(12)),
                    _TotalCard(controller: controller),
                    SizedBox(height: context.h(16)),
                    _SpendSummaryCard(controller: controller),
                    SizedBox(height: context.h(16)),
                    _CategoryGrid(controller: controller),
                    SizedBox(height: context.h(16)),
                    ...controller.transactions.map((t) => _TransactionRow(
                      transaction: t,
                      icon: ExpenseDetailController.transactionIcons[t.category] ?? Icons.receipt_outlined,
                      iconColor: ExpenseDetailController.categoryColors[t.category] ?? AppColors.primary,
                    )),
                    SizedBox(height: context.h(16)),
                    _DownloadButton(),
                  ],
                )),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DetailHero extends StatelessWidget {
  final ExpenseSummaryItem item;
  const _DetailHero({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(280),
      child: Stack(
        fit: StackFit.expand,
        children: [
          item.imageUrl != null
              ? Image.network(item.imageUrl!, fit: BoxFit.cover)
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0D7377), Color(0xFF1B3E6F), Color(0xFF0A1628)],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: context.w(36),
                      height: context.w(36),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white, size: context.sp(20)),
                    ),
                  ),
                  const Spacer(),
                  AppText(
                    data: item.destination,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.h(6)),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined, size: context.sp(16), color: Colors.white.withOpacity(0.9)),
                      SizedBox(width: context.w(4)),
                      AppText(data: '72°', fontSize: 15, color: Colors.white.withOpacity(0.9)),
                    ],
                  ),
                  SizedBox(height: context.h(8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineSyncRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.sync, size: context.sp(16), color: AppColors.textSecondary),
        SizedBox(width: context.w(6)),
        AppText(data: 'Offline Sync', fontSize: 13, color: AppColors.textSecondary),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  final ExpenseDetailController controller;
  const _TotalCard({required this.controller});

  static const _legendItems = [
    ('Food',       Color(0xFF3B82F6)),
    ('Transport',  Color(0xFF22C55E)),
    ('Stay',       Color(0xFFF59E0B)),
    ('Shopping',   Color(0xFFA855F7)),
    ('Activities', Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(data: 'TOTAL SPENT', fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  SizedBox(height: context.h(4)),
                  AppText(data: '\$${controller.totalSpent.toStringAsFixed(2)}', fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(data: 'PLANNED', fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  SizedBox(height: context.h(4)),
                  AppText(data: '\$${controller.plannedTotal.toStringAsFixed(2)}', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ],
              ),
            ],
          ),
          SizedBox(height: context.h(14)),
          _SegmentedBar(
            byCategory: controller.byCategory,
            total: controller.totalSpent,
          ),
          SizedBox(height: context.h(12)),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(6),
            children: _legendItems.map((leg) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: context.w(8),
                  height: context.w(8),
                  decoration: BoxDecoration(color: leg.$2, shape: BoxShape.circle),
                ),
                SizedBox(width: context.w(4)),
                AppText(data: leg.$1, fontSize: 12, color: AppColors.textSecondary),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  final Map<String, double> byCategory;
  final double total;
  const _SegmentedBar({required this.byCategory, required this.total});

  static const _barColors = {
    'Food':       Color(0xFF3B82F6),
    'Transport':  Color(0xFF22C55E),
    'Stay':       Color(0xFFF59E0B),
    'Shopping':   Color(0xFFA855F7),
    'Activities': Color(0xFFEF4444),
  };

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return Container(
        height: context.h(8),
        decoration: BoxDecoration(
          color: AppColors.inputBorder,
          borderRadius: BorderRadius.circular(context.w(4)),
        ),
      );
    }
    final segments = _barColors.entries.where((e) => (byCategory[e.key] ?? 0) > 0).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.w(4)),
      child: Row(
        children: segments.map((e) {
          final flex = ((byCategory[e.key]! / total) * 100).round().clamp(1, 100);
          return Expanded(
            flex: flex,
            child: Container(height: context.h(8), color: e.value),
          );
        }).toList(),
      ),
    );
  }
}

class _SpendSummaryCard extends StatelessWidget {
  final ExpenseDetailController controller;
  const _SpendSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final totalSpent   = controller.totalSpent;
    final plannedTotal = controller.plannedTotal;
    final maxY         = (plannedTotal > totalSpent ? plannedTotal : totalSpent) * 1.3;
    const barHeight    = 160.0;

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: 'SPEND SUMMARY', fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _YAxis(maxY: maxY, barHeight: barHeight),
              SizedBox(width: context.w(8)),
              Expanded(
                child: SizedBox(
                  height: barHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Bar(label: 'Actual',  heightFraction: totalSpent / maxY,   maxH: barHeight, color: const Color(0xFF1B3E6F)),
                      _Bar(label: 'Planned', heightFraction: plannedTotal / maxY, maxH: barHeight, color: const Color(0xFFF59E0B)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YAxis extends StatelessWidget {
  final double maxY;
  final double barHeight;
  const _YAxis({required this.maxY, required this.barHeight});

  @override
  Widget build(BuildContext context) {
    final step = (maxY / 2).ceilToDouble();
    return SizedBox(
      height: barHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(data: step.toInt().toString(),       fontSize: 11, color: AppColors.textSecondary),
          AppText(data: (step / 2).toInt().toString(), fontSize: 11, color: AppColors.textSecondary),
          AppText(data: '0',                           fontSize: 11, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double heightFraction;
  final double maxH;
  final Color color;
  const _Bar({required this.label, required this.heightFraction, required this.maxH, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: context.w(72),
          height: (heightFraction * maxH).clamp(4.0, maxH),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(6))),
          ),
        ),
        SizedBox(height: context.h(6)),
        AppText(data: label, fontSize: 12, color: AppColors.textSecondary),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final ExpenseDetailController controller;
  const _CategoryGrid({required this.controller});

  static const _cats = ['Food', 'Transport', 'Stay', 'Shopping', 'Activities'];

  @override
  Widget build(BuildContext context) {
    final byCategory = controller.byCategory;
    final rows = <Widget>[];
    for (var i = 0; i < _cats.length; i += 2) {
      final left  = _cats[i];
      final right = i + 1 < _cats.length ? _cats[i + 1] : null;
      rows.add(Row(
        children: [
          Expanded(child: _CategoryChip(label: left,  amount: byCategory[left]  ?? 0)),
          SizedBox(width: context.w(12)),
          Expanded(child: right != null
              ? _CategoryChip(label: right, amount: byCategory[right] ?? 0)
              : const SizedBox()),
        ],
      ));
      if (i + 2 < _cats.length) rows.add(SizedBox(height: context.h(12)));
    }
    return Column(children: rows);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final double amount;
  const _CategoryChip({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    final color = ExpenseDetailController.categoryColors[label] ?? AppColors.primary;
    final icon  = ExpenseDetailController.categoryIcons[label]  ?? Icons.category_outlined;
    return Container(
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(38),
            height: context.w(38),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: context.sp(18)),
          ),
          SizedBox(width: context.w(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: label, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              SizedBox(height: context.h(2)),
              AppText(data: '\$${amount.toInt()}', fontSize: 13, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final ExpenseTransaction transaction;
  final IconData icon;
  final Color iconColor;
  const _TransactionRow({required this.transaction, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(1)),
      padding: EdgeInsets.symmetric(horizontal: context.w(4), vertical: context.h(14)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.inputBorder, width: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(40),
            height: context.w(40),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: context.sp(18)),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: transaction.name, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                SizedBox(height: context.h(3)),
                AppText(data: '৳ 7,200 · Today 12:40', fontSize: 12, color: AppColors.textSecondary),
              ],
            ),
          ),
          AppText(data: '\$${transaction.amount.toInt()}', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.h(16)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(context.w(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download_outlined, color: Colors.white, size: context.sp(20)),
              SizedBox(width: context.w(8)),
              AppText(data: 'Download', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
