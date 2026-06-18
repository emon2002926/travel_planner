import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../chat/views/chat_page.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/models/trip_model.dart';
import '../../settings/views/notification_screen.dart';
import 'add_new_trip_page.dart';


class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the same HomeController instance — trips live there.
    final controller = Get.put(HomeController());

    return Obx(() {
      // Track the list so the page reacts to add / duplicate / delete.
      controller.trips.length;
      controller.activeTrip.value;
      controller.role.value;

      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      final allTrips = controller.allTrips;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(controller: controller),
              SizedBox(height: context.h(8)),
              Expanded(
                child: allTrips.isEmpty
                    ? _EmptyTrips(controller: controller)
                    : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    context.w(20),
                    context.h(8),
                    context.w(20),
                    context.h(120),
                  ),
                  itemCount: allTrips.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: context.h(14)),
                  itemBuilder: (_, i) => _TripListCard(
                    controller: controller,
                    trip: allTrips[i],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _TopBar extends StatelessWidget {
  final HomeController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(12),
        context.w(20),
        context.h(10),
      ),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Get.back(),
          //   child: Icon(
          //     Icons.arrow_back_ios_new,
          //     color: AppColors.textPrimary,
          //     size: context.sp(22),
          //   ),
          // ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: AppText(
              data: 'Trips',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
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
              child: GestureDetector(
                onTap: (){AppNavigation.push(NotificationScreen(), context: context);},

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
          ),
        ],
      ),
    );
  }
}

class _TripListCard extends StatelessWidget {
  final HomeController controller;
  final TripModel trip;
  const _TripListCard({required this.controller, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onTripTap(trip),
      child: Container(
        padding: EdgeInsets.all(context.w(10)),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(context.w(18)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            // Thumbnail — swap for Image.asset / network once TripModel
            // carries an image.

            Image.asset(
              "assets/images/trip_thumbnail.png",
              width: context.w(66),
              height: context.w(66),
              fit: BoxFit.cover,
            ),
            // Container(
            //   width: context.w(56),
            //   height: context.w(56),
            //   decoration: BoxDecoration(
            //     color: AppColors.iconBg,
            //     borderRadius: BorderRadius.circular(context.w(12)),
            //   ),
            //   child: Icon(
            //     Icons.landscape_outlined,
            //     color: AppColors.iconColor,
            //     size: context.sp(28),
            //   ),
            // ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AppText(
                          data: trip.destination,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(10),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius:
                          BorderRadius.circular(context.w(20)),
                        ),
                        child: AppText(
                          data: '${trip.readyPercent}% ready',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(4)),
                  AppText(
                    data: '${trip.dateRange} • ${trip.partySize}',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            if (controller.canEdit) ...[
              SizedBox(width: context.w(8)),
              _DuplicateButton(
                onTap: () => controller.duplicateTrip(trip),
              ),

            ],
            SizedBox(width: context.w(8)),
            _EditDot(onTap: () => controller.editTrip(trip)),
          ],
        ),
      ),
    );
  }
}

class _DuplicateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DuplicateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(14),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(24)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_outlined,
              size: context.sp(16),
              color: AppColors.textPrimary,
            ),
            SizedBox(width: context.w(6)),
            AppText(
              data: 'Duplicate',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ],
        ),
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
      onTap: (){AppNavigation.push(ChatPage());},
      child: Container(
        width: context.w(38),
        height: context.w(38),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Icon(
          Icons.message,
          size: context.sp(20),
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _EmptyTrips extends StatelessWidget {
  final HomeController controller;
  const _EmptyTrips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.w(88),
              height: context.w(88),
              decoration: BoxDecoration(
                color: AppColors.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.luggage_outlined,
                size: context.sp(40),
                color: AppColors.iconColor,
              ),
            ),
            SizedBox(height: context.h(20)),
            AppText(
              data: 'No trips yet',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: context.h(8)),
            AppText(
              data: controller.canCreate
                  ? 'Create your first trip and it will show up here.'
                  : 'Trips shared with you will show up here.',
              fontSize: 14,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
            if (controller.canCreate) ...[
              SizedBox(height: context.h(24)),
              SizedBox(
                width: context.w(180),
                child: AppButton(
                  buttonText: 'Create Trip',
                  onPressed: () {
                    AppNavigation.push(AddNewTripPage());
                  },
                  borderRadius: 30,
                  buttonHeight: 52,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: context.h(60)), // visually centers above bottom nav
          ],
        ),
      ),
    );
  }
}