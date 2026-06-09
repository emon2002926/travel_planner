import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';


class TransportTab extends StatelessWidget {
  final TripDetailController controller;
  const TransportTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CurrentModeCard(controller: controller),
        SizedBox(height: context.h(24)),
        ...controller.transports.map((t) => Padding(
          padding: EdgeInsets.only(bottom: context.h(20)),
          child: _TransportRow(item: t),
        )),
        SizedBox(height: context.h(8)),
        if (controller.canEdit)
          AppButton(
            buttonText: 'Add New Transport',
            onPressed: () => _showAddTransportSheet(context, controller),
            borderRadius: 30,
            buttonHeight: 54,
          ),
      ],
    ));
  }
}

class _CurrentModeCard extends StatelessWidget {
  final TripDetailController controller;
  const _CurrentModeCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car_outlined, color: AppColors.primary, size: context.sp(24)),
          SizedBox(width: context.w(12)),
          AppText(data: controller.selectedTransportMode.value, fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _TransportRow extends StatelessWidget {
  final TransportItem item;
  const _TransportRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.w(42),
          height: context.w(42),
          decoration: BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle),
          child: Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: context.sp(20)),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: AppText(data: item.displayLabel, fontSize: 15, color: AppColors.textPrimary),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(data: item.displayTime, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            AppText(data: item.displayDate, fontSize: 12, color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }
}

void _showAddTransportSheet(BuildContext context, TripDetailController controller) {
  final seatCtrl = TextEditingController();
  final selectedType = 'Flight'.obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trip Creation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            const Text('Transport Type Selection', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
              child: DropdownButton<String>(
                value: selectedType.value,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (v) { if (v != null) selectedType.value = v; },
                items: ['Flight', 'Car', 'Train', 'Ship', 'Taxi'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(controller: seatCtrl, label: 'Seat Number (Optional)', hintText: 'e.g. 4A'),
            const SizedBox(height: 12),
            const Text('Booking Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 1095)));
                if (picked != null) selectedDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                child: Row(children: [
                  Expanded(child: Text(selectedDate.value != null ? '${selectedDate.value!.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][selectedDate.value!.month - 1]} ${selectedDate.value!.year}' : '16 December 2025', style: TextStyle(color: selectedDate.value != null ? AppColors.textPrimary : AppColors.inputHint))),
                  Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (picked != null) selectedTime.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                child: Row(children: [
                  Expanded(child: Text(selectedTime.value != null ? '${selectedTime.value!.hour.toString().padLeft(2,'0')}:${selectedTime.value!.minute.toString().padLeft(2,'0')}' : '18:36', style: TextStyle(color: selectedTime.value != null ? AppColors.textPrimary : AppColors.inputHint))),
                  Icon(Icons.access_time_outlined, color: AppColors.textSecondary, size: 18),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              buttonText: 'Save Transport',
              onPressed: () {
                final date = selectedDate.value ?? DateTime.now();
                final time = selectedTime.value ?? TimeOfDay.now();
                controller.addTransport(TransportItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  transportType: selectedType.value,
                  seatNumber: seatCtrl.text.isNotEmpty ? seatCtrl.text : null,
                  bookingDateTime: DateTime(date.year, date.month, date.day, time.hour, time.minute),
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
