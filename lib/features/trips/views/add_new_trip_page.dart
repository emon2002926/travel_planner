import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_planner/core/util/app_navigation.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../../settings/views/notification_screen.dart';
import '../controllers/new_trip_controller.dart';

class AddNewTripPage extends StatefulWidget {
  const AddNewTripPage({super.key});

  @override
  State<AddNewTripPage> createState() => _AddNewTripPageState();
}

class _AddNewTripPageState extends State<AddNewTripPage> {
  late final NewTripController controller;

  @override
  void initState() {
    super.initState();
    Get.delete<NewTripController>(force: true);
    controller = Get.put(NewTripController());
  }

  @override
  void dispose() {
    Get.delete<NewTripController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.currentStep.value;

      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: _buildTopBar(context, controller),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.w(20),
                  context.h(20),
                  context.w(20),
                  context.h(20),
                ),
                child: _buildStepContent(context, controller),
              ),
            ),
            SafeArea(
              top: false,
              child: _buildBottomBar(context, controller),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomBar(BuildContext context, NewTripController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(8),
        context.w(20),
        context.h(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              buttonText: 'Skip',
              onPressed: controller.skip,
              fillColor: Colors.transparent,
              textColor: AppColors.primary,
              borderColor: AppColors.primary,
              borderRadius: 30,
              buttonHeight: 56,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: AppButton(
              buttonText: controller.primaryButtonText,
              onPressed: controller.next,
              borderRadius: 30,
              buttonHeight: 56,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, NewTripController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.w(20),
            context.h(12),
            context.w(20),
            context.h(10),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: controller.back,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: context.sp(24),
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: AppText(
                  data: 'Add New Trip',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                width: context.w(42),
                height: context.w(42),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    AppNavigation.push(NotificationScreen(), context: context);
                  },
                  child: Icon(
                    Icons.notifications_outlined,
                    size: context.sp(20),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          child: Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  height: context.h(4),
                  margin: EdgeInsets.only(right: i < 3 ? context.w(8) : 0),
                  decoration: BoxDecoration(
                    color: i <= controller.currentStep.value
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: context.h(4)),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context, NewTripController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return _Step1(controller: controller);
      case 1:
        return _Step2(controller: controller);
      case 2:
        return _Step3Transport(controller: controller);
      default:
        return _Step4Type(controller: controller);
    }
  }
}

class _Step1 extends StatelessWidget {
  final NewTripController controller;
  const _Step1({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'Where are you going?',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(14)),
        AppTextField(
          controller: controller.destinationController,
          hintText: 'e.g. Kyoto, Japan',
          prefixIcon: Icons.location_on_outlined,
        ),
        SizedBox(height: context.h(24)),
        AppText(
          data: 'Travel Type',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(12)),
        _TravelTypeGrid(controller: controller),
        SizedBox(height: context.h(24)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DateSection(
                label: 'Start Date',
                date: controller.startDate,
                onTap: () => controller.pickDate(context, true),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: _DateSection(
                label: 'End Date',
                date: controller.endDate,
                onTap: () => controller.pickDate(context, false),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(6)),
         _TripDurationRow(controller: controller),
        SizedBox(height: context.h(24)),
        AppText(
          data: 'Total traveler',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(8)),
        AppTextField(
          controller: controller.groupSizeController,
          hintText: 'Enter group size',
          prefixIcon: Icons.group_outlined,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: context.h(16)),
        Obx(() => _InsuranceRow(
          value: controller.hasInsurance.value,
          onTap: () => controller.hasInsurance.toggle(),
        )),
        SizedBox(height: context.h(16)),
        const _AiCompanionCard(),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

class _TravelTypeGrid extends StatelessWidget {
  final NewTripController controller;
  const _TravelTypeGrid({required this.controller});

  static const _types = [
    ('Low Adrenaline', 'Calm & Steady'),
    ('Relaxed', 'Smooth Journey'),
    ('High Adrenaline', 'Thrilling Drive'),
    ('Adrenaline', 'Ultimate Rush'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisSpacing: context.w(12),
      mainAxisSpacing: context.h(12),
      childAspectRatio: 2.6,
      children: _types
          .map((type) => Obx(() {
        final isSelected =
            controller.selectedTravelType.value == type.$1;
        return GestureDetector(
          onTap: () => controller.selectTravelType(type.$1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.borderColor,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surface,
            ),
            padding: EdgeInsets.symmetric(horizontal: context.w(12)),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                      : null,
                ),
                SizedBox(width: context.w(8)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data: type.$1,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    AppText(
                      data: type.$2,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }))
          .toList(),
    );
  }
}

class _TripDurationRow extends StatelessWidget {
  final NewTripController controller;
  const _TripDurationRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final start = controller.startDate.value;
      final end = controller.endDate.value;

      if (start == null || end == null) return const SizedBox.shrink();

      final now = DateTime.now();
      final duration = end.difference(start).inDays + 1;
      final daysAway = start.difference(now).inDays;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            data: '$duration Days Trip.',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          AppText(
            data: daysAway > 0 ? '$daysAway days away this trip' : 'Trip starts today',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ],
      );
    });
  }
}
class _Step2 extends StatelessWidget {
  final NewTripController controller;
  const _Step2({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'Estimated Budget',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(14)),
        AppTextField(
          controller: controller.budgetController,
          hintText: '\$2400',
          keyboardType: TextInputType.number,
          suffixWidget: Obx(() => _CurrencyDropdown(
            value: controller.selectedCurrency.value,
            onChanged: (v) {
              if (v != null) controller.selectedCurrency.value = v;
            },
          )),
        ),
        SizedBox(height: context.h(24)),
        Row(
          children: [
            Expanded(
              child: _BudgetCategoryCard(
                label: 'Food',
                icon: Icons.restaurant_outlined,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFFEFF6FF),
                inputController: controller.foodController,
                hintText: '\$600',
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: _BudgetCategoryCard(
                label: 'Transport',
                icon: Icons.directions_bus_outlined,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFD1FAE5),
                inputController: controller.transportBudgetController,
                hintText: '\$300',
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(12)),
        Row(
          children: [
            Expanded(
              child: _BudgetCategoryCard(
                label: 'Stay',
                icon: Icons.hotel_outlined,
                iconColor: const Color(0xFFF59E0B),
                iconBg: const Color(0xFFFEF3C7),
                inputController: controller.stayController,
                hintText: '\$600',
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: _BudgetCategoryCard(
                label: 'Shopping',
                icon: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFF8B5CF6),
                iconBg: const Color(0xFFEDE9FE),
                inputController: controller.shoppingController,
                hintText: '\$500',
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(12)),
        Row(
          children: [
            Expanded(
              child: _BudgetCategoryCard(
                label: 'Activities',
                icon: Icons.local_activity_outlined,
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFEE2E2),
                inputController: controller.activitiesController,
                hintText: '\$240',
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

class _Step3Transport extends StatelessWidget {
  final NewTripController controller;
  const _Step3Transport({required this.controller});

  @override
  Widget build(BuildContext context) {
    const modes = ['Flight', 'Train', 'Bus', 'Car'];
    const emojis = {
      'Flight': '✈️',
      'Train': '🚆',
      'Bus': '🚌',
      'Car': '🚗',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'Transport details',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(6)),
        AppText(
          data: 'Add your travel and booking information',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: context.h(16)),
        Container(
          padding: EdgeInsets.all(context.w(6)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.w(14)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Obx(() => Row(
            children: modes.map((m) {
              final selected = controller.transportMode.value == m;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.setTransportMode(m),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: context.h(10)),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.scaffoldBg
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(context.w(10)),
                      border: selected
                          ? Border.all(color: AppColors.inputBorder)
                          : null,
                      boxShadow: selected
                          ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          emojis[m]!,
                          style: TextStyle(fontSize: context.sp(22)),
                        ),
                        SizedBox(height: context.h(4)),
                        AppText(
                          data: m,
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ),
        SizedBox(height: context.h(20)),
        Obx(() => Column(
          children: controller.transportLegs
              .map((leg) => _TransportLegBlock(
            controller: controller,
            leg: leg,
            canRemove: controller.transportLegs.length > 1,
          ))
              .toList(),
        )),
        SizedBox(height: context.h(4)),
        Obx(() => GestureDetector(
          onTap: controller.addTransportLeg,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: context.h(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.w(12)),
              border: Border.all(
                color: AppColors.primary,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: context.sp(18), color: AppColors.primary),
                SizedBox(width: context.w(8)),
                AppText(
                  data: 'Add More ${controller.transportMode.value}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        )),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

class _TransportLegBlock extends StatelessWidget {
  final NewTripController controller;
  final TransportLeg leg;
  final bool canRemove;
  const _TransportLegBlock({
    required this.controller,
    required this.leg,
    required this.canRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canRemove)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => controller.removeTransportLeg(leg),
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.h(4)),
                  child: Icon(
                    Icons.close,
                    size: context.sp(18),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          _Label('Carrier / Airline'),
          SizedBox(height: context.h(8)),
          AppTextField(
            controller: leg.carrier,
            hintText: 'e.g. Emirates, ANA',
          ),
          SizedBox(height: context.h(16)),
          _Label('Booking Reference'),
          SizedBox(height: context.h(8)),
          AppTextField(
            controller: leg.bookingRef,
            hintText: 'e.g. ABC123',
          ),
          SizedBox(height: context.h(16)),
          _Label('Arrival'),
          SizedBox(height: context.h(8)),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: leg.arrivalPlace,
                  hintText: 'Enter arrival airport',
                ),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: _DateTimeField(
                  value: leg.arrivalTime,
                  onTap: () => controller.pickLegDateTime(context, leg, true),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          _Label('Departure'),
          SizedBox(height: context.h(8)),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: leg.departurePlace,
                  hintText: 'Enter departure airport',
                ),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: _DateTimeField(
                  value: leg.departureTime,
                  onTap: () => controller.pickLegDateTime(context, leg, false),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          _Label('Gate Number'),
          SizedBox(height: context.h(8)),
          AppTextField(
            controller: leg.gate,
            hintText: 'Enter gate number',
          ),
          SizedBox(height: context.h(16)),
          _Label('Terminal'),
          SizedBox(height: context.h(8)),
          AppTextField(
            controller: leg.terminal,
            hintText: 'Enter terminal',
          ),
          SizedBox(height: context.h(16)),
          _Label('Seat Number'),
          SizedBox(height: context.h(8)),
          AppTextField(
            controller: leg.seat,
            hintText: 'Enter seat number',
          ),
          SizedBox(height: context.h(8)),
        ],
      ),
    );
  }
}



class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return AppText(
      data: text,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final Rxn<DateTime> value;
  final VoidCallback onTap;
  const _DateTimeField({required this.value, required this.onTap});

  String _fmt(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour < 12 ? 'AM' : 'PM';
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${m[d.month - 1]} • $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final d = value.value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(12),
            vertical: context.h(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(context.w(10)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: context.sp(16), color: AppColors.textSecondary),
              SizedBox(width: context.w(8)),
              Expanded(
                child: AppText(
                  data: d != null ? _fmt(d) : '20 May • 08:45 AM',
                  fontSize: 12,
                  maxLines: 1,
                  color: d != null
                      ? AppColors.textPrimary
                      : AppColors.inputHint,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


class _Step4Type extends StatelessWidget {
  final NewTripController controller;
  const _Step4Type({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'What kind of trip?',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(6)),
        AppText(
          data: "We'll tailor your packing lists and timeline.",
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: context.h(20)),
        Obx(() {
          final selected = controller.selectedTripType.value;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TripTypeCard(
                      type: 'Solo',
                      subtitle: 'Just me',
                      icon: Icons.person_outline,
                      isSelected: selected == 'Solo',
                      onTap: () => controller.selectTripType('Solo'),
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: _TripTypeCard(
                      type: 'Family',
                      subtitle: 'With kids/dependents',
                      icon: Icons.family_restroom,
                      isSelected: selected == 'Family',
                      onTap: () => controller.selectTripType('Family'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(12)),
              Row(
                children: [
                  Expanded(
                    child: _TripTypeCard(
                      type: 'Group',
                      subtitle: 'Friends or colleagues',
                      icon: Icons.group_outlined,
                      isSelected: selected == 'Group',
                      onTap: () => controller.selectTripType('Group'),
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: _TripTypeCard(
                      type: 'Business',
                      subtitle: 'Work trip',
                      icon: Icons.work_outline,
                      isSelected: selected == 'Business',
                      onTap: () => controller.selectTripType('Business'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(12)),
              Row(
                children: [
                  Expanded(
                    child: _TripTypeCard(
                      type: 'Emergency',
                      subtitle: 'Last minute',
                      icon: Icons.favorite_border,
                      isSelected: selected == 'Emergency',
                      onTap: () => controller.selectTripType('Emergency'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          );
        }),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

class _DateSection extends StatelessWidget {
  final String label;
  final Rxn<DateTime> date;
  final VoidCallback onTap;
  const _DateSection(
      {required this.label, required this.date, required this.onTap});

  String _fmt(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${m[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: label,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(8)),
        Obx(() {
          final d = date.value;
          return GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(14),
              ),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: context.sp(18),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: context.w(10)),
                  AppText(
                    data: d != null ? _fmt(d) : 'Oct 12',
                    fontSize: 14,
                    color: d != null
                        ? AppColors.textPrimary
                        : AppColors.inputHint,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _InsuranceRow extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const _InsuranceRow({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: context.w(22),
            height: context.w(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? AppColors.primary : AppColors.inputBorder,
                width: 1.5,
              ),
              color: value
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: value
                ? Icon(Icons.check,
                size: context.sp(14), color: AppColors.primary)
                : null,
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: AppText(
              data: 'Do you have travel insurance for this trip?',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiCompanionCard extends StatelessWidget {
  const _AiCompanionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration:
            BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle),
            child: Icon(Icons.auto_awesome,
                color: AppColors.primary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'AI Trip Companion',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                SizedBox(height: context.h(4)),
                AppText(
                  data:
                  "AI is ready to suggest a packing list based on your destination's weather.",
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;
  const _CurrencyDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      underline: const SizedBox(),
      dropdownColor: AppColors.surface,
      icon: Icon(Icons.arrow_drop_down,
          color: AppColors.textSecondary, size: context.sp(20)),
      onChanged: onChanged,
      items: ['\$', '€', '£', '¥']
          .map((c) => DropdownMenuItem(
        value: c,
        child: AppText(
            data: c, fontSize: 14, color: AppColors.textPrimary),
      ))
          .toList(),
    );
  }
}

class _BudgetCategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final TextEditingController inputController;
  final String hintText;

  const _BudgetCategoryCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.inputController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(42),
            height: context.w(42),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  data: label,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                TextField(
                  controller: inputController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: context.sp(14),
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.inputHint,
                      fontSize: context.sp(14),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 6, bottom: 2),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.inputBorder)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.inputBorder)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripTypeCard extends StatelessWidget {
  final String type;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TripTypeCard({
    required this.type,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: context.sp(28)),
            SizedBox(height: context.h(8)),
            AppText(
              data: type,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: context.h(4)),
            AppText(
                data: subtitle, fontSize: 13, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}