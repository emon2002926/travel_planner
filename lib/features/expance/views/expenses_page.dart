import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/expenses_controller.dart';
import 'expense_detail_page.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExpensesController>()) {
      Get.put(ExpensesController());
    }
    final controller = Get.find<ExpensesController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              _ExpensesHeader(),
              Expanded(
                child: Obx(() => ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(16),
                    vertical: context.h(16),
                  ),
                  itemCount: controller.trips.length,
                  separatorBuilder: (_, _) => SizedBox(height: context.h(12)),
                  itemBuilder: (context, i) {
                    final item = controller.trips[i];
                    return _TripExpenseCard(
                      item: item,
                      onTap: () => Get.to(() => ExpenseDetailPage(item: item)),
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ExpensesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(14),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: AppText(
              data: 'Expenses',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: context.w(44),
              height: context.w(44),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: context.sp(22)),
                  Positioned(
                    top: context.h(10),
                    right: context.w(10),
                    child: Container(
                      width: context.w(7),
                      height: context.w(7),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripExpenseCard extends StatelessWidget {
  final ExpenseSummaryItem item;
  final VoidCallback onTap;
  const _TripExpenseCard({required this.item, required this.onTap});

  String _formatAmount(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(14)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.w(10)),
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      width: context.w(58),
                      height: context.w(58),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: context.w(58),
                      height: context.w(58),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0D7377), Color(0xFF0A1628)],
                        ),
                      ),
                      child: Icon(Icons.landscape_outlined, color: Colors.white38, size: context.sp(26)),
                    ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: AppText(
                data: item.destination,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(12),
                vertical: context.h(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.w(20)),
              ),
              child: AppText(
                data: '\$${_formatAmount(item.totalSpent)}',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
