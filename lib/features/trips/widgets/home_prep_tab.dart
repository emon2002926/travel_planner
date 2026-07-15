import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';

class HomePrepTab extends StatelessWidget {
  final TripDetailController controller;
  const HomePrepTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: controller.homePrepCategories.map((cat) => Padding(
        padding: EdgeInsets.only(bottom: context.h(16)),
        child: _CategoryCard(controller: controller, category: cat),
      )).toList(),
    ));
  }
}

class _CategoryCard extends StatelessWidget {
  final TripDetailController controller;
  final HomePrepCategory category;
  const _CategoryCard({required this.controller, required this.category});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                width: context.w(36),
                height: context.w(36),
                decoration: BoxDecoration(color: category.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(context.w(10))),
                child: Icon(category.icon, color: category.iconColor, size: context.sp(20)),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: AppText(data: category.title, fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              AppText(data: '${category.completionPercent}%', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ],
          ),
          SizedBox(height: context.h(12)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category.completionPercent / 100,
              backgroundColor: AppColors.inputBorder,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              minHeight: context.h(5),
            ),
          ),
          SizedBox(height: context.h(12)),
          ...category.tasks.map((task) => _TaskRow(controller: controller, category: category, task: task)),
          if (controller.canEdit) ...[
            SizedBox(height: context.h(8)),
            // _AddNewButton(
            //   onTap: () => _showAddTaskSheet(context, controller, category.id),
            // ),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final TripDetailController controller;
  final HomePrepCategory category;
  final HomePrepTask task;
  const _TaskRow({required this.controller, required this.category, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.canEdit ? () => controller.toggleHomePrepTask(category.id, task.id) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.h(8)),
        child: Row(
          children: [
            Container(
              width: context.w(26),
              height: context.w(26),
              decoration: BoxDecoration(
                color: task.isDone ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: task.isDone ? AppColors.primary : AppColors.inputBorder, width: 2),
              ),
              child: task.isDone ? Icon(Icons.check, size: context.sp(14), color: Colors.white) : null,
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AppText(
                data: task.label,
                fontSize: 15,
                color: task.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                decoration: task.isDone ? TextDecoration.none : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _AddNewButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _AddNewButton({required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: context.h(12)),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(context.w(12)),
//           border: Border.all(color: AppColors.inputBorder),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add, color: AppColors.textSecondary, size: context.sp(18)),
//             SizedBox(width: context.w(6)),
//             AppText(data: 'Add New', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
//           ],
//         ),
//       ),
//     );
//   }
// }

void _showAddTaskSheet(BuildContext context, TripDetailController controller, String categoryId) {
  final labelCtrl = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            AppTextField(controller: labelCtrl, label: 'Task', hintText: 'Type Here...'),
            const SizedBox(height: 20),
            AppButton(
              buttonText: 'Save',
              onPressed: () {
                if (labelCtrl.text.isEmpty) return;
                controller.addHomePrepTask(categoryId, labelCtrl.text);
                Get.back();
              },
              borderRadius: 30,
              buttonHeight: 52,
            ),
          ],
        ),
      ),
    ),
  );
}
