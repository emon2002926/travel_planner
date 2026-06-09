import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';


class GiftTab extends StatelessWidget {
  final TripDetailController controller;
  const GiftTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.gifts.isEmpty && !controller.hasAcknowledgedGiftPrompt.value) {
        return _GiftPrompt(controller: controller);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.gifts.isNotEmpty) ...[
            _StatsRow(controller: controller),
            SizedBox(height: context.h(16)),
          ],
          ...controller.gifts.map((g) => Padding(
            padding: EdgeInsets.only(bottom: context.h(12)),
            child: _GiftCard(controller: controller, gift: g),
          )),
          if (controller.canEdit) ...[
            SizedBox(height: context.h(8)),
            AppButton(
              buttonText: '+ Add Gift',
              onPressed: () => _showAddGiftSheet(context, controller),
              borderRadius: 30,
              buttonHeight: 54,
            ),
          ],
        ],
      );
    });
  }
}

class _GiftPrompt extends StatelessWidget {
  final TripDetailController controller;
  const _GiftPrompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Are you taking any gifts or items for someone?',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            maxLines: 3,
          ),
          SizedBox(height: context.h(10)),
          AppText(
            data: 'Track gifts, deliveries, and special items so nothing gets forgotten during your trip.',
            fontSize: 14,
            color: AppColors.textSecondary,
            maxLines: 3,
          ),
          SizedBox(height: context.h(20)),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonText: 'No',
                  onPressed: () => controller.hasAcknowledgedGiftPrompt.value = true,
                  fillColor: AppColors.error,
                  borderRadius: 30,
                  buttonHeight: 48,
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: AppButton(
                  buttonText: 'Yes, Add Gifts',
                  onPressed: () {
                    controller.hasAcknowledgedGiftPrompt.value = true;
                    _showAddGiftSheet(context, controller);
                  },
                  borderRadius: 30,
                  buttonHeight: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final TripDetailController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(value: '${controller.totalGifts}', label: 'Gifts'),
        SizedBox(width: context.w(10)),
        _StatCard(value: '${controller.packedGifts}', label: 'Packed'),
        SizedBox(width: context.w(10)),
        _StatCard(value: '${controller.pendingGifts}', label: 'Pending'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(14)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(12)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: value, fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            SizedBox(height: context.h(2)),
            AppText(data: label, fontSize: 13, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _GiftCard extends StatelessWidget {
  final TripDetailController controller;
  final GiftItem gift;
  const _GiftCard({required this.controller, required this.gift});

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
            children: [
              Expanded(
                child: AppText(
                  data: gift.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (gift.price > 0)
                AppText(
                  data: '\$${gift.price.toInt()}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
            ],
          ),
          SizedBox(height: context.h(6)),
          if (gift.forPerson.isNotEmpty)
            Row(children: [
              Icon(Icons.person_outline, size: context.sp(14), color: AppColors.textSecondary),
              SizedBox(width: context.w(4)),
              AppText(data: 'For ${gift.forPerson}', fontSize: 13, color: AppColors.textSecondary),
            ]),
          if (gift.location.isNotEmpty) ...[
            SizedBox(height: context.h(3)),
            Row(children: [
              Icon(Icons.location_on_outlined, size: context.sp(14), color: AppColors.error),
              SizedBox(width: context.w(4)),
              AppText(data: gift.location, fontSize: 13, color: AppColors.textSecondary),
            ]),
          ],
          SizedBox(height: context.h(14)),
          if (controller.canEdit)
            Row(
              children: [
                Expanded(child: _ActionBtn(label: 'Edit', icon: Icons.edit_outlined, style: _BtnStyle.outline, onTap: () => _showAddGiftSheet(context, controller, editGift: gift))),
                SizedBox(width: context.w(8)),
                Expanded(child: _ActionBtn(label: 'Status', icon: Icons.track_changes_outlined, style: _BtnStyle.dark, onTap: () => _showSetStatusSheet(context, controller, gift))),
                SizedBox(width: context.w(8)),
                Expanded(child: _ActionBtn(label: 'Delete', icon: Icons.delete_outline, style: _BtnStyle.danger, onTap: () => controller.deleteGift(gift.id))),
              ],
            ),
        ],
      ),
    );
  }
}

enum _BtnStyle { outline, dark, danger }

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final _BtnStyle style;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Color border;

    switch (style) {
      case _BtnStyle.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = AppColors.inputBorder;
        break;
      case _BtnStyle.dark:
        bg = const Color(0xFF3D4A5A);
        fg = Colors.white;
        border = const Color(0xFF3D4A5A);
        break;
      case _BtnStyle.danger:
        bg = AppColors.error.withOpacity(0.08);
        fg = AppColors.error;
        border = AppColors.error.withOpacity(0.3);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.h(10)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(context.w(24)),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.sp(14), color: fg),
            SizedBox(width: context.w(4)),
            AppText(data: label, fontSize: 13, fontWeight: FontWeight.w500, color: fg),
          ],
        ),
      ),
    );
  }
}

void _showSetStatusSheet(BuildContext context, TripDetailController controller, GiftItem gift) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Set status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          ...['Unpacked', 'Packed', 'Delivered'].map((s) => GestureDetector(
            onTap: () {
              controller.updateGiftStatus(gift.id, s.toLowerCase());
              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: Text(s, style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
            ),
          )),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}

void _showAddGiftSheet(BuildContext context, TripDetailController controller, {GiftItem? editGift}) {
  final step = 1.obs;
  final direction = (editGift?.direction ?? 'giver').obs;
  final nameCtrl = TextEditingController(text: editGift?.name ?? '');
  final priceCtrl = TextEditingController(text: editGift != null && editGift.price > 0 ? '${editGift.price.toInt()}' : '');
  final locationCtrl = TextEditingController(text: editGift?.location ?? '');
  final selectedPerson = (editGift?.forPerson ?? (controller.members.isNotEmpty ? controller.members.first.name : '')).obs;
  final selectedStatus = (editGift?.status ?? 'unpacked').obs;

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
        child: Obx(() => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DIRECTION SELECTION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              const Text('Add Gifts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Step ${step.value}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 16),
              if (step.value == 1) ...[
                _DirectionCard(
                  title: 'I am buying or taking a gift',
                  subtitle: 'You are the gift giver',
                  isSelected: direction.value == 'giver',
                  onTap: () => direction.value = 'giver',
                ),
                const SizedBox(height: 12),
                _DirectionCard(
                  title: 'Someone asked me to deliver',
                  subtitle: 'You are the carrier',
                  isSelected: direction.value == 'carrier',
                  onTap: () => direction.value = 'carrier',
                ),
              ] else ...[
                AppTextField(controller: nameCtrl, label: 'Gift Name', hintText: 'Enter name'),
                const SizedBox(height: 12),
                const Text('Gift For', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: DropdownButton<String>(
                    value: selectedPerson.value.isNotEmpty ? selectedPerson.value : null,
                    hint: const Text('Select people', style: TextStyle(color: Colors.grey)),
                    isExpanded: true,
                    underline: const SizedBox(),
                    onChanged: (v) { if (v != null) selectedPerson.value = v; },
                    items: controller.members.map((m) => DropdownMenuItem(value: m.name, child: Text(m.name))).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                AppTextField(controller: priceCtrl, label: 'Price (Optional)', hintText: 'e.g. 45', keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                AppTextField(controller: locationCtrl, label: 'Purchase Location', hintText: 'e.g. Kyoto Market'),
                const SizedBox(height: 12),
                const Text('Set status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  children: ['Unpacked', 'Packed', 'Delivered'].asMap().entries.map((e) {
                    final s = e.value;
                    final isLast = e.key == 2;
                    final isSelected = selectedStatus.value == s.toLowerCase();
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => selectedStatus.value = s.toLowerCase(),
                        child: Container(
                          margin: EdgeInsets.only(right: isLast ? 0 : 8),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? AppColors.primary : Colors.grey.shade600,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              AppButton(
                buttonText: step.value == 1 ? 'Next - Gift Details' : (editGift != null ? 'Update Gift' : 'Save Gift'),
                onPressed: () {
                  if (step.value == 1) {
                    step.value = 2;
                  } else {
                    if (nameCtrl.text.isEmpty) return;
                    if (editGift != null) {
                      controller.updateGift(editGift.id, nameCtrl.text, double.tryParse(priceCtrl.text) ?? 0, selectedPerson.value, locationCtrl.text, direction.value, selectedStatus.value);
                    } else {
                      controller.addGift(GiftItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        forPerson: selectedPerson.value,
                        location: locationCtrl.text,
                        direction: direction.value,
                        status: selectedStatus.value,
                      ));
                    }
                    Get.back();
                  }
                },
                borderRadius: 30,
                buttonHeight: 52,
              ),
            ],
          ),
        )),
      ),
    ),
  );
}

class _DirectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _DirectionCard({required this.title, required this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              data: title,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            SizedBox(height: context.h(4)),
            AppText(data: subtitle, fontSize: 13, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}