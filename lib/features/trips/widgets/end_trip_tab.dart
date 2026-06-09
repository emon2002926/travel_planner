import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../controllers/trip_detail_controller.dart';
import '../views/trip_completed_page.dart';


class EndTripTab extends StatelessWidget {
  final TripDetailController controller;
  const EndTripTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(context.w(16)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data: 'Delete Vault Data?',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: context.h(6)),
                    AppText(
                      data: 'Your trip is complete. We can now securely remove your stored documents and travel data.',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.w(12)),
              if (controller.isOwner)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error, width: 1.5),
                    borderRadius: BorderRadius.circular(context.w(30)),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.delete_outline, color: AppColors.error, size: context.sp(16)),
                    label: AppText(
                      data: 'Delete',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(14),
                        vertical: context.h(10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: context.h(40)),
        if (controller.isOwner)
          AppButton(
            buttonText: 'Trip Completed',
            onPressed: () => Get.to(() => TripCompletedPage(trip: controller.trip)),
            borderRadius: 30,
            buttonHeight: 54,
          )
        else
          Container(
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(context.w(14)),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.textSecondary, size: context.sp(18)),
                SizedBox(width: context.w(10)),
                Expanded(
                  child: AppText(
                    data: 'Only the trip owner can mark this trip as completed.',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}