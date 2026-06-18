import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_planner/core/util/app_navigation.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../chat/views/chat_page.dart';
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



class TripDetailPage extends StatefulWidget {
  final TripModel trip;
  const TripDetailPage({super.key, required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage>
    with SingleTickerProviderStateMixin {
  late TripDetailController controller;
  late TabController _tabController;

  static const _tabs = [
    'Overview', 'Packing', 'Gift', 'Home Prep', 'Transport',
    'People', 'Expense', 'Safety', 'Hotel', 'End Trip',
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<TripDetailController>()) {
      Get.put(TripDetailController(trip: widget.trip));
    } else if (Get.find<TripDetailController>().trip.id != widget.trip.id) {
      Get.delete<TripDetailController>(force: true);
      Get.put(TripDetailController(trip: widget.trip));
    }
    controller = Get.find<TripDetailController>();

    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: controller.currentTab.value);
    _tabController.addListener(() {
      controller.currentTab.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: AppColors.scaffoldBg,
                  expandedHeight: context.h(250),
                  collapsedHeight: kToolbarHeight,
                  pinned: false,
                  floating: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _HeroSection(trip: widget.trip),
                    collapseMode: CollapseMode.parallax,
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabController: _tabController,
                  tabs: _tabs,
                  controller: controller,
                  height: context.h(51),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (index) {
                return Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<int>(index),
                      slivers: [
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            context.w(16), context.h(16),
                            context.w(16), context.h(120),
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _buildTabContent(index, controller),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent(int index, TripDetailController controller) {
    switch (index) {
      case 0:  return OverviewTab(controller: controller);
      case 1:  return PackingTab(controller: controller);
      case 2:  return GiftTab(controller: controller);
      case 3:  return HomePrepTab(controller: controller);
      case 4:  return TransportTab(controller: controller);
      case 5:  return PeopleTab(controller: controller);
      case 6:  return ExpenseTab(controller: controller);
      case 7:  return SafetyTab(controller: controller);
      case 8:  return HotelTab(controller: controller);
      case 9:  return EndTripTab(controller: controller);
      default: return OverviewTab(controller: controller);
    }
  }
}


class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> tabs;
  final TripDetailController controller;
  final double height;

  _TabBarDelegate({
    required this.tabController,
    required this.tabs,
    required this.controller,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      height: height,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height - 1,
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: context.w(8)),
              labelPadding: EdgeInsets.symmetric(horizontal: context.w(4)),
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: List.generate(tabs.length, (i) {
                return Obx(() {
                  final isSelected = controller.currentTab.value == i;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: context.h(8)),
                    padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(6)),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.scaffoldBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(context.w(20)),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      data: tabs[i],
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  );
                });
              }),
            ),
          ),
          Container(height: 1, color: AppColors.inputBorder),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}



class _HeroSection extends StatelessWidget {
  final TripModel trip;
  const _HeroSection({required this.trip});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(280),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/tokyo.png', fit: BoxFit.cover),
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
                        onTap: () => AppNavigation.push(ChatPage(), context: context),
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
                              child: Icon(Icons.message_outlined, color: AppColors.textPrimary, size: context.sp(20)),
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x4D151515),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.wb_sunny_outlined, size: context.sp(16), color: Colors.white.withOpacity(0.9)),
                              SizedBox(width: context.w(4)),
                              AppText(
                                data: trip.weatherTemp.isNotEmpty ? '${trip.weatherTemp.split(' ').first}°' : '72°',
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ],
                          ),
                        ),
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