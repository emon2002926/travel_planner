import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../../auth/controllers/account_selection_controller.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';

class PeopleTab extends StatelessWidget {
  final TripDetailController controller;
  const PeopleTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.isOwner) _InviteCard(controller: controller),
        SizedBox(height: context.h(20)),
        AppText(data: 'Trip Members', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        SizedBox(height: context.h(12)),
        Container(
          decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(16)), border: Border.all(color: AppColors.inputBorder)),
          child: Column(
            children: controller.members.asMap().entries.map((entry) {
              final i = entry.key;
              final m = entry.value;
              return Column(
                children: [
                  _MemberRow(controller: controller, member: m),
                  if (i < controller.members.length - 1) Divider(height: 1, color: AppColors.inputBorder, indent: context.w(16), endIndent: context.w(16)),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: context.h(20)),
        _SafetySharingSection(controller: controller),
      ],
    ));
  }
}

class _InviteCard extends StatelessWidget {
  final TripDetailController controller;
  const _InviteCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(data: 'Traveling with others?', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
          SizedBox(height: context.h(8)),
          AppText(data: 'Invite family or friends to coordinate packing and share location.', fontSize: 14, color: Colors.white.withOpacity(0.9)),
          SizedBox(height: context.h(16)),
          GestureDetector(
            onTap: () => _showInviteSheet(context, controller),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(12)),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(context.w(30))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_outlined, color: AppColors.primary, size: context.sp(18)),
                  SizedBox(width: context.w(8)),
                  AppText(data: 'Invite Member', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final TripDetailController controller;
  final TripMember member;
  const _MemberRow({required this.controller, required this.member});

  String get _roleLabel {
    switch (member.role) {
      case UserRole.owner: return 'Owner';
      case UserRole.editor: return 'Editor';
      default: return 'Visitor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          Container(
            width: context.w(42),
            height: context.w(42),
            decoration: BoxDecoration(color: AppColors.inputBorder, shape: BoxShape.circle),
            child: Center(child: AppText(data: member.name[0], fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(data: member.name, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    if (member.role == UserRole.owner) ...[
                      SizedBox(width: context.w(8)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(2)),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.inputBorder), borderRadius: BorderRadius.circular(context.w(10))),
                        child: AppText(data: 'Owner', fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
                AppText(data: '${member.memberType} • $_roleLabel', fontSize: 13, color: AppColors.textSecondary),
              ],
            ),
          ),
          if (controller.isOwner)
            GestureDetector(
              onTap: () => controller.removeMember(member.id),
              child: Icon(Icons.delete_outline, color: AppColors.error, size: context.sp(22)),
            ),
        ],
      ),
    );
  }
}

class _SafetySharingSection extends StatelessWidget {
  final TripDetailController controller;
  const _SafetySharingSection({required this.controller});

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
              Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: context.sp(18)),
              SizedBox(width: context.w(8)),
              AppText(data: 'Safety & Sharing', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: context.h(16)),
          _ToggleRow(
            label: 'Location Sharing',
            subtitle: 'Share live location with trip members',
            value: controller.locationSharing.value,
            onChanged: controller.canEdit ? (v) => controller.locationSharing.value = v : null,
          ),
          SizedBox(height: context.h(12)),
          Divider(color: AppColors.inputBorder),
          SizedBox(height: context.h(12)),
          _ToggleRow(
            label: 'Emergency Contacts',
            subtitle: 'Notify if itinerary changes drastically',
            value: controller.emergencyContactsEnabled.value,
            onChanged: controller.canEdit ? (v) => controller.emergencyContactsEnabled.value = v : null,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final void Function(bool)? onChanged;
  const _ToggleRow({required this.label, required this.subtitle, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: label, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              AppText(data: subtitle, fontSize: 13, color: AppColors.textSecondary),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

void _showInviteSheet(BuildContext context, TripDetailController controller) {
  final emailCtrl = TextEditingController();
  final selectedRole = 'Editor'.obs;
  final expiryDate = Rxn<DateTime>();

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
            const Text('Invite Your Friend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text("Enter your friend's email and role to invite them—they can install the app and reset their password to get started.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            AppTextField(controller: emailCtrl, label: 'Email Address', hintText: 'Rhebhek@gmail.com', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
              child: DropdownButton<String>(
                value: selectedRole.value,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (v) { if (v != null) selectedRole.value = v; },
                items: ['Editor', 'Viewer'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Set Expiry', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 30)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (picked != null) expiryDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                child: Row(children: [
                  Expanded(child: Text(expiryDate.value != null ? '${expiryDate.value!.day}/${expiryDate.value!.month}/${expiryDate.value!.year % 100}' : 'DD/MM/YY', style: TextStyle(color: expiryDate.value != null ? AppColors.textPrimary : AppColors.inputHint))),
                  Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              buttonText: 'Invite Member',
              prefixIcon: Icons.person_add_outlined,
              onPressed: () {
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
