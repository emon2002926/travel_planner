import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../controllers/trip_detail_controller.dart';

class SafetyTab extends StatelessWidget {
  final TripDetailController controller;
  const SafetyTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MapPlaceholder(),
        SizedBox(height: context.h(16)),
        _LocationSharingCard(controller: controller),
        SizedBox(height: context.h(20)),
        AppText(data: 'Active Alerts', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        SizedBox(height: context.h(12)),
        ...controller.alerts.map((a) => Padding(
          padding: EdgeInsets.only(bottom: context.h(12)),
          child: _AlertCard(alert: a),
        )),
        SizedBox(height: context.h(8)),
        _EmergencyContactsCard(),
      ],
    ));
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(200),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.w(16)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D4A3E), Color(0xFF1A3A2A), Color(0xFF3D6B4F)],
        ),
      ),
      child: Stack(
        children: [
          Center(child: Icon(Icons.map_outlined, color: Colors.white.withOpacity(0.2), size: context.sp(80))),
          Positioned(
            top: context.h(12),
            right: context.w(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(5)),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(context.w(20))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: context.w(8), height: context.w(8), decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                SizedBox(width: context.w(4)),
                AppText(data: 'LIVE', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
              ]),
            ),
          ),
          Positioned(
            top: context.h(40),
            left: context.w(40),
            child: _AvatarPin(initial: 'A'),
          ),
          Positioned(
            top: context.h(90),
            left: context.w(110),
            child: _AvatarPin(initial: 'S'),
          ),
          Positioned(
            top: context.h(60),
            right: context.w(60),
            child: _AvatarPin(initial: 'E'),
          ),
        ],
      ),
    );
  }
}

class _AvatarPin extends StatelessWidget {
  final String initial;
  const _AvatarPin({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.w(34),
          height: context.w(34),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
          child: Center(child: AppText(data: initial, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
        Container(width: 2, height: context.h(8), color: Colors.white.withOpacity(0.7)),
        Container(width: context.w(6), height: context.w(6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), shape: BoxShape.circle)),
      ],
    );
  }
}

class _LocationSharingCard extends StatelessWidget {
  final TripDetailController controller;
  const _LocationSharingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(16)), border: Border.all(color: AppColors.inputBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: context.w(36), height: context.w(36), decoration: BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle), child: Icon(Icons.location_on_outlined, color: AppColors.primary, size: context.sp(18))),
            SizedBox(width: context.w(12)),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText(data: 'Location Sharing', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              AppText(data: 'Active', fontSize: 12, color: AppColors.textSecondary),
            ])),
            Switch(value: controller.locationSharing.value, onChanged: controller.canEdit ? (v) => controller.locationSharing.value = v : null, activeThumbColor: AppColors.primary),
          ]),
          SizedBox(height: context.h(12)),
          Divider(color: AppColors.inputBorder),
          SizedBox(height: context.h(8)),
          AppText(data: 'Sharing with:', fontSize: 13, color: AppColors.textSecondary),
          SizedBox(height: context.h(8)),
          _SharingRow(name: 'Alex', status: 'Viewing', statusColor: AppColors.textSecondary),
          SizedBox(height: context.h(6)),
          _SharingRow(name: 'Sarah', status: 'Active', statusColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _SharingRow extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  const _SharingRow({required this.name, required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.person_outline, size: context.sp(18), color: AppColors.textSecondary),
      SizedBox(width: context.w(8)),
      Expanded(child: AppText(data: name, fontSize: 14, color: AppColors.textPrimary)),
      AppText(data: status, fontSize: 14, fontWeight: FontWeight.w600, color: statusColor),
    ]);
  }
}

class _AlertCard extends StatelessWidget {
  final dynamic alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(14)), border: Border.all(color: AppColors.inputBorder)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(36),
            height: context.w(36),
            decoration: BoxDecoration(color: alert.titleColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(alert.icon, color: alert.titleColor, size: context.sp(18)),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText(data: alert.title, fontSize: 14, fontWeight: FontWeight.w700, color: alert.titleColor),
              SizedBox(height: context.h(4)),
              AppText(data: alert.description, fontSize: 13, color: AppColors.textPrimary, maxLines: 3),
              SizedBox(height: context.h(4)),
              AppText(data: alert.timeAgo, fontSize: 11, color: AppColors.textSecondary),
            ]),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(16)), border: Border.all(color: AppColors.inputBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.phone_outlined, color: AppColors.primary, size: context.sp(20)),
            SizedBox(width: context.w(10)),
            AppText(data: 'Emergency Contacts', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ]),
          SizedBox(height: context.h(16)),
          _ContactRow(name: 'Local Emergency', number: '110'),
          SizedBox(height: context.h(8)),
          Divider(color: AppColors.inputBorder),
          SizedBox(height: context.h(8)),
          _ContactRow(name: 'Embassy', number: '+81-3-3224-5000'),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String name;
  final String number;
  const _ContactRow({required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppText(data: name, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        AppText(data: number, fontSize: 13, color: AppColors.textSecondary),
      ])),
      SizedBox(
        width: context.w(70),
        height: context.h(36),
        child: AppButton(
          buttonText: 'Call',
          onPressed: () {},
          buttonHeight: 36,
          borderRadius: 20,
          fontSize: 13,
        ),
      ),
    ]);
  }
}
