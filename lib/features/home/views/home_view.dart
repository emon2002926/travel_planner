
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/storage_service.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/home_controller.dart';
import '../models/trip_model.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    print("gshlkjkj: ${StorageService.userRole}");
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.w(20),
              context.h(12),
              context.w(20),
              context.h(120),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(controller: controller),
                SizedBox(height: context.h(20)),
                _HeroCard(controller: controller),
                SizedBox(height: context.h(28)),
                AppText(
                  data: 'Actions',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: context.h(16)),
                _ActionsGrid(controller: controller),
                SizedBox(height: context.h(24)),
                _BottomSection(controller: controller),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  final HomeController controller;
  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data: 'Good Morning, ${controller.userName.value}!',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: context.h(4)),
              AppText(
                data: controller.headline,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        SizedBox(width: context.w(12)),
        GestureDetector(
          onTap: controller.openNotifications,
          child: Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: context.sp(24),
                  color: AppColors.textPrimary,
                ),
                if (controller.hasNotification.value)
                  Positioned(
                    top: context.h(13),
                    right: context.w(15),
                    child: Container(
                      width: context.w(8),
                      height: context.w(8),
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
    );
  }
}

class _HeroCard extends StatelessWidget {
  final HomeController controller;
  const _HeroCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.hasActiveTrip) {
      return _ActiveTripCard(controller: controller);
    }
    if (controller.isTripCompleted) {
      return _CompletedTripCard(controller: controller);
    }
    return _CreateTripCard(controller: controller);
  }
}

class _CreateTripCard extends StatelessWidget {
  final HomeController controller;
  const _CreateTripCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(24)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Start your next trip.',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnPrimary,
          ),
          SizedBox(height: context.h(16)),
          if (controller.canCreate)
            AppButton(
              buttonText: 'Create',
              onPressed: controller.createTrip,
              fillColor: Colors.white,
              textColor: AppColors.primary,
              fontWeight: FontWeight.w700,
              borderRadius: 30,
              buttonHeight: 52,
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: context.h(14)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(context.w(30)),
              ),
              child: AppText(
                data: controller.isViewer
                    ? 'View only access'
                    : 'No trip yet',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveTripCard extends StatelessWidget {
  final HomeController controller;
  const _ActiveTripCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final trip = controller.activeTrip.value!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(context.w(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_outlined,
                      size: context.sp(16),
                      color: AppColors.textOnPrimary,
                    ),
                    SizedBox(width: context.w(6)),
                    AppText(
                      data: '${trip.weatherTemp}, ${trip.weatherCondition}',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOnPrimary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (controller.canEdit)
                _EditDot(onTap: () => controller.editTrip(trip)),
            ],
          ),
          SizedBox(height: context.h(20)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data: trip.destination,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textOnPrimary,
                    ),
                    SizedBox(height: context.h(8)),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: context.sp(14),
                          color: AppColors.textOnPrimary.withOpacity(0.85),
                        ),
                        SizedBox(width: context.w(6)),
                        AppText(
                          data: '${trip.dateRange}  |  ${trip.duration}',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnPrimary.withOpacity(0.85),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ReadyRing(percent: trip.readyPercent),
            ],
          ),
          SizedBox(height: context.h(20)),
          Container(
            padding: EdgeInsets.symmetric(vertical: context.h(16)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(context.w(14)),
            ),
            child: Row(
              children: [
                _StatItem(value: '${trip.daysLeft}', label: 'DAYS LEFT'),
                _StatDivider(),
                _StatItem(
                  value: '${trip.packedItems}/${trip.totalItems}',
                  label: 'PACKED',
                ),
                _StatDivider(),
                _StatItem(value: '${trip.pendingTasks}', label: 'TASKS'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedTripCard extends StatelessWidget {
  final HomeController controller;
  const _CompletedTripCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final trip = controller.activeTrip.value!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(14),
              vertical: context.h(6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(context.w(20)),
            ),
            child: AppText(
              data: trip.destination.toUpperCase(),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnPrimary,
            ),
          ),
          SizedBox(height: context.h(16)),
          AppText(
            data: 'Trip complete!',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnPrimary,
          ),
          SizedBox(height: context.h(8)),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: context.sp(14),
                color: AppColors.textOnPrimary.withOpacity(0.85),
              ),
              SizedBox(width: context.w(6)),
              Expanded(
                child: AppText(
                  data:
                  '${trip.dateRange}  |  ${trip.duration}  |  \$${trip.spend ?? 0}',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textOnPrimary.withOpacity(0.85),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.w(14)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(context.w(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Trip recap',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary,
                ),
                SizedBox(height: context.h(6)),
                AppText(
                  data: trip.recap ?? '',
                  fontSize: 13,
                  maxLines: 4,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textOnPrimary.withOpacity(0.85),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDot extends StatelessWidget {
  final VoidCallback onTap;
  const _EditDot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.w(34),
        height: context.w(34),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.edit_note,
          size: context.sp(18),
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _ReadyRing extends StatelessWidget {
  final int percent;
  const _ReadyRing({required this.percent});

  @override
  Widget build(BuildContext context) {
    final size = context.w(96);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percent / 100,
              strokeWidth: context.w(7),
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                data: '$percent%',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textOnPrimary,
              ),
              AppText(
                data: 'READY',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary.withOpacity(0.85),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(
            data: value,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnPrimary,
          ),
          SizedBox(height: context.h(4)),
          AppText(
            data: label,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textOnPrimary.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: context.h(34),
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class _ActionsGrid extends StatelessWidget {
  final HomeController controller;
  const _ActionsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = controller.visibleActions;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => controller.onActionTap(item.label),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.w(56),
                height: context.w(56),
                decoration: BoxDecoration(
                  color: AppColors.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon as IconData,
                  size: context.sp(24),
                  color: AppColors.iconColor,
                ),
              ),
              SizedBox(height: context.h(8)),
              AppText(
                data: item.label,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomSection extends StatelessWidget {
  final HomeController controller;
  const _BottomSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.hasNoTrip) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OfflineVaultRow(controller: controller),
          SizedBox(height: context.h(16)),
          _PackingPrompt(controller: controller),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'Upcoming',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(16)),
        ...controller.upcomingTrips.map(
              (t) => Padding(
            padding: EdgeInsets.only(bottom: context.h(12)),
            child: _UpcomingTripCard(controller: controller, trip: t),
          ),
        ),
        _OfflineVaultRow(controller: controller),
      ],
    );
  }
}

class _PackingPrompt extends StatelessWidget {
  final HomeController controller;
  const _PackingPrompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              data: 'Start your packing today.',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (controller.canEdit)
            SizedBox(
              width: context.w(110),
              child: AppButton(
                buttonText: 'Start',
                onPressed: controller.startPacking,
                borderRadius: 24,
                buttonHeight: 44,
                fontSize: 14,
              ),
            )
          else
            AppText(
              data: 'Read only',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

class _UpcomingTripCard extends StatelessWidget {
  final HomeController controller;
  final TripModel trip;
  const _UpcomingTripCard({required this.controller, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onTripTap(trip),
      child: Container(
        padding: EdgeInsets.all(context.w(12)),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(52),
              height: context.w(52),
              decoration: BoxDecoration(
                color: AppColors.iconBg,
                borderRadius: BorderRadius.circular(context.w(12)),
              ),
              child: Icon(
                Icons.landscape_outlined,
                color: AppColors.iconColor,
                size: context.sp(26),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: trip.destination,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: context.h(2)),
                  AppText(
                    data: '${trip.dateRange} • ${trip.partySize}',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(10),
                vertical: context.h(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(context.w(20)),
              ),
              child: AppText(
                data: '${trip.readyPercent}% ready',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
            if (controller.canEdit) ...[
              SizedBox(width: context.w(8)),
              _EditDot(onTap: () => controller.editTrip(trip)),
            ],
          ],
        ),
      ),
    );
  }
}

class _OfflineVaultRow extends StatelessWidget {
  final HomeController controller;
  const _OfflineVaultRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final count = controller.offlineDocsCount.value;
    return Container(
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(context.w(12)),
            ),
            child: Icon(
              Icons.description_outlined,
              color: const Color(0xFF7C3AED),
              size: context.sp(22),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Offline Vault',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: context.h(2)),
                AppText(
                  data: count > 0
                      ? '$count documents available offline'
                      : 'No documents available offline',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(10),
              vertical: context.h(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(context.w(20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: context.sp(14),
                  color: AppColors.success,
                ),
                SizedBox(width: context.w(4)),
                AppText(
                  data: 'Secured',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}