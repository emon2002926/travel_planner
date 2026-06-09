import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../home/models/trip_model.dart';
import '../controllers/trip_detail_controller.dart';
import '../widgets/end_trip_tab.dart';
import '../widgets/expense_tab.dart';
import '../widgets/gift_tab.dart';
import '../widgets/home_prep_tab.dart';
import '../widgets/hotel_tab.dart';
import '../widgets/overview_tab.dart';
import '../widgets/packing_tab.dart';
import '../widgets/people_tab.dart';
import '../widgets/safety_tab.dart';
import '../widgets/transport_tab.dart';



class TripDetailPage extends StatelessWidget {
  final TripModel trip;
  const TripDetailPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TripDetailController>()) {
      Get.put(TripDetailController(trip: trip));
    } else if (Get.find<TripDetailController>().trip.id != trip.id) {
      Get.delete<TripDetailController>(force: true);
      Get.put(TripDetailController(trip: trip));
    }
    final controller = Get.find<TripDetailController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _HeroSection(trip: trip, controller: controller),
            _TabBar(
              controller: controller,
              scrollController: controller.tabScrollController,
            ),
            Container(height: 1, color: AppColors.inputBorder),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(controller.currentTab.value),
                padding: EdgeInsets.fromLTRB(
                  context.w(16),
                  context.h(16),
                  context.w(16),
                  context.h(120),
                ),
                child: _buildTabContent(controller),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabContent(TripDetailController controller) {
    switch (controller.currentTab.value) {
      case 0: return OverviewTab(controller: controller);
      case 1: return PackingTab(controller: controller);
      case 2: return GiftTab(controller: controller);
      case 3: return HomePrepTab(controller: controller);
      case 4: return TransportTab(controller: controller);
      case 5: return PeopleTab(controller: controller);
      case 6: return ExpenseTab(controller: controller);
      case 7: return SafetyTab(controller: controller);
      case 8: return HotelTab(controller: controller);
      case 9: return EndTripTab(controller: controller);
      default: return OverviewTab(controller: controller);
    }
  }
}

class _HeroSection extends StatelessWidget {
  final TripModel trip;
  final TripDetailController controller;
  const _HeroSection({required this.trip, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(280),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D7377), Color(0xFF1B3E6F), Color(0xFF0A1628)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.delete<TripDetailController>(force: true);
                          Get.back();
                        },
                        child: Container(
                          width: context.w(36),
                          height: context.w(36),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: context.sp(20)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: context.w(42),
                              height: context.w(42),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.sticky_note_2_outlined, color: AppColors.textPrimary, size: context.sp(20)),
                            ),
                            Positioned(
                              top: context.h(8),
                              right: context.w(8),
                              child: Container(
                                width: context.w(8),
                                height: context.w(8),
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppText(data: trip.destination, fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                  SizedBox(height: context.h(6)),
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          data: '${trip.dateRange} • ${trip.partySize}',
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Icon(Icons.wb_sunny_outlined, size: context.sp(16), color: Colors.white.withOpacity(0.9)),
                      SizedBox(width: context.w(4)),
                      AppText(
                        data: trip.weatherTemp.isNotEmpty ? '${trip.weatherTemp.split(' ').first}°' : '72°',
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final TripDetailController controller;
  final ScrollController scrollController;
  const _TabBar({required this.controller, required this.scrollController});

  static const _tabs = [
    'Overview', 'Packing', 'Gift', 'Home Prep', 'Transport',
    'People', 'Expense', 'Safety', 'Hotel', 'End Trip',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      height: context.h(50),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.w(12)),
        child: Obx(
              () => Row(
            children: List.generate(_tabs.length, (i) {
              final isSelected = controller.currentTab.value == i;
              return GestureDetector(
                onTap: () => controller.switchTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: context.w(4), vertical: context.h(8)),
                  padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(6)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.scaffoldBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(context.w(20)),
                  ),
                  child: AppText(
                    data: _tabs[i],
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}