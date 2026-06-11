import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/new_trip_controller.dart';

// Changed StatelessWidget → StatefulWidget so the controller is created ONCE
// in initState and deleted ONCE in dispose. This prevents the keyboard /
// rebuild cycle from wiping the controller (and all form input) on every frame.
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
    // Always start with a fresh controller — but only once per page open.
    Get.delete<NewTripController>(force: true);
    controller = Get.put(NewTripController());
  }

  @override
  void dispose() {
    // Clean up when the page is actually removed from the stack.
    Get.delete<NewTripController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.currentStep.value; // track step for button label + progress bar

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
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(20),
                  0,
                  context.w(20),
                  context.h(20),
                ),
                child: AppButton(
                  buttonText:
                  controller.currentStep.value == 2 ? 'Create Trip' : 'Next',
                  onPressed: controller.next,
                  borderRadius: 30,
                  buttonHeight: 56,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
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
                child: Icon(
                  Icons.notifications_outlined,
                  size: context.sp(20),
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          child: Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Container(
                  height: context.h(4),
                  margin: EdgeInsets.only(right: i < 2 ? context.w(8) : 0),
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
      default:
        return _Step3(controller: controller);
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
          data: 'Transportation',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(12)),
        Obx(() => _checkGrid(
          context,
          ['Flight', 'Train', 'Car', 'Ship'],
          controller.selectedTransport,
          controller.toggleTransport,
        )),
        SizedBox(height: context.h(12)),
        AppTextField(
          controller: controller.otherTransportController,
          hintText: 'other',
        ),
        SizedBox(height: context.h(24)),
        AppText(
          data: 'Travel Type',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(12)),
        Obx(() => _checkGrid(
          context,
          ['Relaxed', 'Low Adrenaline', 'Adrenaline', 'High Adrenaline'],
          controller.selectedTravelTypes,
          controller.toggleTravelType,
        )),
        SizedBox(height: context.h(24)),
        Row(
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
          hintText: 'e.g. \$240',
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

class _Step3 extends StatelessWidget {
  final NewTripController controller;
  const _Step3({required this.controller});

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
        SizedBox(height: context.h(24)),
        // Read-only budget summary from Step 2
        AppTextField(
          controller: controller.budgetController,
          hintText: 'e.g. \$240',
          enabled: false,
        ),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

Widget _checkGrid(
    BuildContext context,
    List<String> items,
    RxSet<String> selected,
    void Function(String) onToggle,
    ) {
  final rows = <Widget>[];
  for (int i = 0; i < items.length; i += 2) {
    rows.add(
      Row(
        children: [
          Expanded(
              child: _checkItem(
                  context, items[i], selected.contains(items[i]), onToggle)),
          if (i + 1 < items.length)
            Expanded(
                child: _checkItem(context, items[i + 1],
                    selected.contains(items[i + 1]), onToggle)),
        ],
      ),
    );
    if (i + 2 < items.length) rows.add(SizedBox(height: context.h(10)));
  }
  return Column(children: rows);
}

Widget _checkItem(
    BuildContext context,
    String label,
    bool isChecked,
    void Function(String) onToggle,
    ) {
  return GestureDetector(
    onTap: () => onToggle(label),
    behavior: HitTestBehavior.opaque,
    child: Row(
      children: [
        Container(
          width: context.w(20),
          height: context.w(20),
          decoration: BoxDecoration(
            color: isChecked ? const Color(0xFF3D4A5A) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color:
              isChecked ? const Color(0xFF3D4A5A) : AppColors.inputBorder,
            ),
          ),
          child: isChecked
              ? Icon(Icons.check, size: context.sp(13), color: Colors.white)
              : null,
        ),
        SizedBox(width: context.w(8)),
        AppText(data: label, fontSize: 14, color: AppColors.textPrimary),
      ],
    ),
  );
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
                    data: d != null ? _fmt(d) : 'Select',
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

  const _BudgetCategoryCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.inputController,
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
                    hintText: '0',
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