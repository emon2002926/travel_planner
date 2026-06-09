import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../controllers/trip_detail_controller.dart';

class OverviewTab extends StatelessWidget {
  final TripDetailController controller;
  const OverviewTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReadinessCard(controller: controller),
        SizedBox(height: context.h(20)),
        ...controller.overviewTimeline.map((item) => Padding(
          padding: EdgeInsets.only(bottom: context.h(16)),
          child: _TimelineItem(item: item),
        )),
      ],
    ));
  }
}

class _ReadinessCard extends StatelessWidget {
  final TripDetailController controller;
  const _ReadinessCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(data: 'Readiness', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              AppText(data: '65%', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ],
          ),
          SizedBox(height: context.h(10)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.65,
              backgroundColor: AppColors.inputBorder,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              minHeight: context.h(6),
            ),
          ),
          SizedBox(height: context.h(14)),
          Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9EE),
              borderRadius: BorderRadius.circular(context.w(12)),
              border: Border.all(color: const Color(0xFFFEF3C7)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: const Color(0xFFF59E0B), size: context.sp(18)),
                SizedBox(width: context.w(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(data: 'Critical items pending', fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B)),
                      SizedBox(height: context.h(2)),
                      AppText(data: '3 packing items and 2 home tasks need your attention before leaving.', fontSize: 13, color: const Color(0xFFF59E0B), maxLines: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final dynamic item;
  const _TimelineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: context.w(42),
              height: context.w(42),
              decoration: BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle),
              child: Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: context.sp(20)),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AppText(data: item.label, fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(data: item.time, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                AppText(data: item.date, fontSize: 12, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
        if (item.note != null) ...[
          SizedBox(height: context.h(6)),
          Padding(
            padding: EdgeInsets.only(left: context.w(54)),
            child: AppText(data: item.note!, fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
        if (item.badge != null) ...[
          SizedBox(height: context.h(8)),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.w(20)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.badge == 'Direction of Airport from you.')
                    Icon(Icons.navigation_outlined, size: context.sp(14), color: AppColors.primary),
                  SizedBox(width: context.w(4)),
                  AppText(data: item.badge!, fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: context.h(4)),
        Divider(color: AppColors.inputBorder, height: 1),
      ],
    );
  }
}
