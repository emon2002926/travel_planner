import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/widgets/buttons/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/app_navigation.dart';
import '../../settings/views/notification_screen.dart';
import '../controllers/safety_controller.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SafetyController>()) {
      Get.put(SafetyController());
    }
    final controller = Get.find<SafetyController>();

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
              _SafetyHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.w(16), context.h(12),
                    context.w(16), context.h(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EmergencyModeBanner(controller: controller),
                      SizedBox(height: context.h(16)),
                      _LocationSharingCard(controller: controller),
                      SizedBox(height: context.h(20)),
                      _LocalEmergencySection(controller: controller),
                    ],
                  ),
                ),
              ),
              _DeactivateButton(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}



class _SafetyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [


          SizedBox(width: context.w(32)),
          Expanded(
            child: AppText(data: 'Safety', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: GestureDetector(
              onTap: (){AppNavigation.push(NotificationScreen(), context: context);},

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
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
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



class _EmergencyModeBanner extends StatelessWidget {
  final SafetyController controller;
  const _EmergencyModeBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: controller.emergencyModeActive.value
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(
          color: controller.emergencyModeActive.value
              ? const Color(0xFFFCA5A5)
              : const Color(0xFF86EFAC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: controller.emergencyModeActive.value
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_outlined,
              color: Colors.white,
              size: context.sp(22),
            ),
          ),
          SizedBox(width: context.w(14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data: controller.emergencyModeActive.value ? 'Emergency Mode' : 'Safe Mode',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: controller.emergencyModeActive.value
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF16A34A),
              ),
              SizedBox(height: context.h(3)),
              AppText(
                data: controller.emergencyModeActive.value
                    ? 'Share live location & alert contacts'
                    : 'No active emergencies',
                fontSize: 13,
                color: controller.emergencyModeActive.value
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF16A34A),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}



class _LocationSharingCard extends StatelessWidget {
  final SafetyController controller;
  const _LocationSharingCard({required this.controller});

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
              Container(
                width: context.w(44),
                height: context.w(44),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_outlined, color: AppColors.primary, size: context.sp(22)),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(data: 'Location Sharing', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    SizedBox(height: context.h(2)),
                    Obx(() => AppText(
                      data: controller.locationSharing.value ? 'Active' : 'Inactive',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    )),
                  ],
                ),
              ),
              Obx(() => Switch(
                value: controller.locationSharing.value,
                onChanged: controller.toggleLocationSharing,
                activeThumbColor: AppColors.primary,
              )),
            ],
          ),
          SizedBox(height: context.h(14)),
          Divider(color: AppColors.inputBorder, height: 1),
          SizedBox(height: context.h(14)),
          AppText(data: 'Sharing with:', fontSize: 13, color: AppColors.textSecondary),
          SizedBox(height: context.h(12)),
          Obx(() => Column(
            children: controller.contacts.map((c) => Padding(
              padding: EdgeInsets.only(bottom: context.h(12)),
              child: _ContactRow(contact: c, controller: controller),
            )).toList(),
          )),
          SizedBox(height: context.h(4)),
          AppButton(buttonText: "Send",borderRadius: 25, onPressed: (){
            controller.sendLocation();
          }),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final SafetyContact contact;
  final SafetyController controller;
  const _ContactRow({required this.contact, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.toggleContact(contact.id),
          child: Container(
            width: context.w(24),
            height: context.w(24),
            decoration: BoxDecoration(
              color: contact.isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: contact.isSelected ? AppColors.primary : AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            child: contact.isSelected
                ? Icon(Icons.check, color: Colors.white, size: context.sp(14))
                : null,
          ),
        ),
        SizedBox(width: context.w(10)),
        ClipOval(
          child: contact.avatarUrl != null
              ? Image.network(contact.avatarUrl!, width: context.w(34), height: context.w(34), fit: BoxFit.cover)
              : Container(
            width: context.w(34),
            height: context.w(34),
            color: AppColors.inputBorder,
            child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: context.sp(18)),
          ),
        ),
        SizedBox(width: context.w(10)),
        Expanded(
          child: AppText(data: contact.name, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        if (contact.isActiveNow)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.w(8),
                height: context.w(8),
                decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
              ),
              SizedBox(width: context.w(5)),
              AppText(data: 'Active Now', fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF16A34A)),
            ],
          )
        else if (contact.lastActiveLabel != null)
          AppText(data: contact.lastActiveLabel!, fontSize: 12, color: const Color(0xFFF59E0B)),
      ],
    );
  }
}


class _LocalEmergencySection extends StatelessWidget {
  final SafetyController controller;
  const _LocalEmergencySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => AppText(
          data: 'Local Emergency Info (${controller.country.value})',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        )),
        SizedBox(height: context.h(14)),
        Obx(() => Row(
          children: controller.emergencyNumbers.asMap().entries.map((entry) {
            final isLast = entry.key == controller.emergencyNumbers.length - 1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : context.w(12)),
                child: _EmergencyCard(number: entry.value, controller: controller),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final EmergencyNumber number;
  final SafetyController controller;
  const _EmergencyCard({required this.number, required this.controller});

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
        children: [
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.phone_outlined, color: const Color(0xFFEF4444), size: context.sp(22)),
          ),
          SizedBox(height: context.h(10)),
          AppText(data: number.number, fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          SizedBox(height: context.h(4)),
          AppText(data: number.label, fontSize: 13, color: AppColors.textSecondary, textAlign: TextAlign.center),
          SizedBox(height: context.h(14)),
          GestureDetector(
            onTap: () => controller.callNumber(number.number),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: context.h(12)),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(context.w(50)),
              ),
              alignment: Alignment.center,
              child: AppText(data: 'Call', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}



class _DeactivateButton extends StatelessWidget {
  final SafetyController controller;
  const _DeactivateButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: controller.toggleEmergencyMode,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(17)),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(context.w(50)),
            border: Border.all(
              color: controller.emergencyModeActive.value
                  ? const Color(0xFFEF4444)
                  : AppColors.primary,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: AppText(
            data: controller.emergencyModeActive.value
                ? 'Deactivate Emergency Mode'
                : 'Activate Emergency Mode',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: controller.emergencyModeActive.value
                ? const Color(0xFFEF4444)
                : AppColors.primary,
          ),
        ),
      ),
    ));
  }
}