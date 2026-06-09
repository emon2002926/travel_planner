import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';

class HotelTab extends StatelessWidget {
  final TripDetailController controller;
  const HotelTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hotels.isNotEmpty && !controller.showHotelForm.value) {
        return _HotelInfoView(controller: controller);
      }
      return _HotelForm(controller: controller);
    });
  }
}

class _HotelInfoView extends StatelessWidget {
  final TripDetailController controller;
  const _HotelInfoView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final hotel = controller.hotels.first;
    return Column(
      children: [
        GestureDetector(
          onTap: controller.canEdit ? () => controller.showHotelForm.value = true : null,
          child: Container(
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(context.w(14)),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(children: [
              Icon(Icons.hotel_outlined, color: AppColors.primary, size: context.sp(24)),
              SizedBox(width: context.w(12)),
              Expanded(
                child: AppText(data: hotel.displayLabel, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              if (controller.canEdit)
                Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: context.sp(18)),
            ]),
          ),
        ),
        if (hotel.address != null) ...[
          SizedBox(height: context.h(12)),
          Container(
            padding: EdgeInsets.all(context.w(14)),
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(14)), border: Border.all(color: AppColors.inputBorder)),
            child: Row(children: [
              Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: context.sp(18)),
              SizedBox(width: context.w(10)),
              Expanded(child: AppText(data: hotel.address!, fontSize: 14, color: AppColors.textPrimary)),
            ]),
          ),
        ],
      ],
    );
  }
}

class _HotelForm extends StatelessWidget {
  final TripDetailController controller;
  const _HotelForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final checkIn = Rxn<DateTime>();
    final checkOut = Rxn<DateTime>();

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: 'Hotel Name', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(8)),
        AppTextField(controller: nameCtrl, hintText: 'e.g. Marina Hotel'),
        SizedBox(height: context.h(20)),
        Row(children: [
          Expanded(child: _DatePicker(label: 'Check-In', date: checkIn.value, onTap: () async {
            final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 1095)));
            if (d != null) checkIn.value = d;
          })),
          SizedBox(width: context.w(12)),
          Expanded(child: _DatePicker(label: 'Check-Out', date: checkOut.value, onTap: () async {
            final d = await showDatePicker(context: context, initialDate: checkIn.value ?? DateTime.now().add(const Duration(days: 1)), firstDate: checkIn.value ?? DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 1095)));
            if (d != null) checkOut.value = d;
          })),
        ]),
        SizedBox(height: context.h(20)),
        AppText(data: 'Hotel Address', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(8)),
        AppTextField(controller: addressCtrl, hintText: 'e.g. Marine Drive'),
        SizedBox(height: context.h(20)),
        AppText(data: 'Room No', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(8)),
        AppTextField(controller: roomCtrl, hintText: 'e.g. 402', keyboardType: TextInputType.number),
        SizedBox(height: context.h(32)),
        AppButton(
          buttonText: 'Add Hotel',
          onPressed: () {
            if (nameCtrl.text.isEmpty) return;
            controller.addHotel(HotelInfo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: nameCtrl.text,
              roomNumber: roomCtrl.text.isNotEmpty ? roomCtrl.text : null,
              checkIn: checkIn.value,
              checkOut: checkOut.value,
              address: addressCtrl.text.isNotEmpty ? addressCtrl.text : null,
            ));
          },
          borderRadius: 30,
          buttonHeight: 54,
        ),
      ],
    ));
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DatePicker({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppText(data: label, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      SizedBox(height: context.h(8)),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(14)),
          decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(context.w(10)), border: Border.all(color: AppColors.inputBorder)),
          child: Row(children: [
            Expanded(child: AppText(data: date != null ? '${date!.day}/${date!.month}/${date!.year}' : 'Select Date', fontSize: 14, color: date != null ? AppColors.textPrimary : AppColors.inputHint)),
            Icon(Icons.calendar_month_outlined, size: context.sp(18), color: AppColors.textSecondary),
          ]),
        ),
      ),
    ]);
  }
}
