import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/trip_detail_models.dart';

class PackingTab extends StatelessWidget {
  final TripDetailController controller;
  const PackingTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmergencyLinkCard(),
        SizedBox(height: context.h(12)),
        _ViewToggle(controller: controller),
        SizedBox(height: context.h(12)),
        if (controller.criticalRemaining > 0)
          _CriticalBanner(count: controller.criticalRemaining),
        SizedBox(height: context.h(12)),
        if (controller.packingView.value == 'list')
          _ListView(controller: controller)
        else
          _BodyMapView(controller: controller),
      ],
    ));
  }
}

class _EmergencyLinkCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: 'Emergency Packing Link', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                SizedBox(height: context.h(4)),
                AppText(data: 'Send your packing list to someone you trust', fontSize: 13, color: AppColors.textSecondary),
              ],
            ),
          ),
          Container(
            width: context.w(40),
            height: context.w(40),
            decoration: BoxDecoration(color: AppColors.iconBg, borderRadius: BorderRadius.circular(context.w(10))),
            child: Icon(Icons.link, color: AppColors.primary, size: context.sp(20)),
          ),
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final TripDetailController controller;
  const _ViewToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(4)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(12)), border: Border.all(color: AppColors.inputBorder)),
      child: Row(
        children: ['list', 'body'].map((view) {
          final isSelected = controller.packingView.value == view;
          final label = view == 'list' ? 'List View' : 'Body Map View';
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.packingView.value = view,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: context.h(10)),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(context.w(10)),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
                ),
                alignment: Alignment.center,
                child: AppText(data: label, fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: AppColors.textPrimary),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CriticalBanner extends StatelessWidget {
  final int count;
  const _CriticalBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(10)),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9EE),
        borderRadius: BorderRadius.circular(context.w(10)),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: const Color(0xFFF59E0B), size: context.sp(18)),
          SizedBox(width: context.w(8)),
          AppText(data: '$count critical items remaining', fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B)),
        ],
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final TripDetailController controller;
  const _ListView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...controller.packingPersons.map((person) => _PersonSection(controller: controller, person: person)),
        if (controller.canEdit)
          _DashedButton(label: '+ Add People', onTap: () => _showAddPeopleSheet(context, controller)),
        SizedBox(height: context.h(16)),
      ],
    );
  }
}

class _PersonSection extends StatelessWidget {
  final TripDetailController controller;
  final PackingPerson person;
  const _PersonSection({required this.controller, required this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: context.w(38),
                height: context.w(38),
                decoration: BoxDecoration(color: AppColors.inputBorder, shape: BoxShape.circle),
                child: Center(child: AppText(data: person.name[0], fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(data: person.name, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    AppText(data: person.memberType, fontSize: 12, color: AppColors.textSecondary),
                  ],
                ),
              ),
              AppText(data: '${person.totalWeightKg.toInt()} KG', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              SizedBox(width: context.w(6)),
              Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: context.h(12)),
          ...person.bags.map((bag) => _BagSection(controller: controller, person: person, bag: bag)),
          if (person.bags.any((b) => b.isOverweight)) ...[
            SizedBox(height: context.h(8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(8)),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9EE),
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: const Color(0xFFFEF3C7)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_outlined, color: const Color(0xFFF59E0B), size: context.sp(16)),
                  SizedBox(width: context.w(8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(data: 'Overweight Alert', fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B)),
                      AppText(data: 'Your checked bag is 4.2 kg over the airline limit.', fontSize: 12, color: const Color(0xFFF59E0B)),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (controller.canEdit) ...[
            SizedBox(height: context.h(10)),
            _DashedButton(label: '+ Add Bag', onTap: () => _showAddBagSheet(context, controller, person.id)),
          ],
        ],
      ),
    );
  }
}

class _BagSection extends StatelessWidget {
  final TripDetailController controller;
  final PackingPerson person;
  final PackingBag bag;
  const _BagSection({required this.controller, required this.person, required this.bag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(8)),
          child: Row(
            children: [
              AppText(data: bag.name, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              const Spacer(),
              AppText(data: '${bag.packed}/${bag.total}', fontSize: 13, color: AppColors.textSecondary),
            ],
          ),
        ),
        ...bag.items.map((item) => _PackingItemRow(controller: controller, person: person, bag: bag, item: item)),
        if (controller.canEdit)
          Padding(
            padding: EdgeInsets.only(top: context.h(6)),
            child: GestureDetector(
              onTap: () => _showAddItemSheet(context, controller, person.id, bag.id),
              child: AppText(data: '+ Add Item', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class _PackingItemRow extends StatelessWidget {
  final TripDetailController controller;
  final PackingPerson person;
  final PackingBag bag;
  final PackingItem item;
  const _PackingItemRow({required this.controller, required this.person, required this.bag, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(6)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => controller.togglePackingItem(person.id, bag.id, item.id),
                child: Container(
                  width: context.w(26),
                  height: context.w(26),
                  decoration: BoxDecoration(
                    color: item.isPacked ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: item.isPacked ? AppColors.primary : AppColors.inputBorder, width: 2),
                  ),
                  child: item.isPacked ? Icon(Icons.check, size: context.sp(14), color: Colors.white) : null,
                ),
              ),
              SizedBox(width: context.w(10)),
              Text(item.emoji, style: TextStyle(fontSize: context.sp(16))),
              SizedBox(width: context.w(6)),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleItemExpanded(person.id, bag.id, item.id),
                  child: Row(
                    children: [
                      AppText(data: item.name, fontSize: 14, color: AppColors.textPrimary, fontWeight: item.isPacked ? FontWeight.w400 : FontWeight.w500),
                      SizedBox(width: context.w(4)),
                      Icon(item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: context.sp(16), color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              if (item.isCritical) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: context.sp(8), color: AppColors.error),
                    SizedBox(width: context.w(4)),
                    AppText(data: 'Critical', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                  ],
                ),
              ],
              if (controller.canEdit) ...[
                SizedBox(width: context.w(8)),
                Icon(Icons.edit_outlined, size: context.sp(16), color: AppColors.textSecondary),
              ],
            ],
          ),
        ),
        if (item.isExpanded && item.comments.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: context.w(36), bottom: context.h(6)),
            padding: EdgeInsets.all(context.w(10)),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(context.w(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...item.comments.map((c) => Padding(
                  padding: EdgeInsets.only(bottom: context.h(6)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: context.w(26),
                        height: context.w(26),
                        decoration: BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle),
                        child: Icon(Icons.person_outline, size: context.sp(14), color: AppColors.primary),
                      ),
                      SizedBox(width: context.w(8)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText(data: c.authorName, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                SizedBox(width: context.w(6)),
                                AppText(data: c.timeAgo, fontSize: 11, color: AppColors.textSecondary),
                              ],
                            ),
                            AppText(data: c.message, fontSize: 13, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                if (controller.canEdit)
                  Row(
                    children: [
                      Container(
                        width: context.w(26),
                        height: context.w(26),
                        decoration: BoxDecoration(color: AppColors.iconBg, shape: BoxShape.circle),
                        child: Icon(Icons.person_outline, size: context.sp(14), color: AppColors.primary),
                      ),
                      SizedBox(width: context.w(8)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: context.w(10)),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(context.w(8)),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type here',
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: context.sp(13), color: AppColors.inputHint),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Icon(Icons.send_outlined, size: context.sp(18), color: AppColors.primary),
                    ],
                  ),
              ],
            ),
          ),
        Divider(color: AppColors.inputBorder, height: 1),
      ],
    );
  }
}

class _BodyMapView extends StatelessWidget {
  final TripDetailController controller;
  const _BodyMapView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(context.w(16)), border: Border.all(color: AppColors.inputBorder)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: const Color(0xFF22C55E), label: 'Complete'),
              SizedBox(width: context.w(16)),
              _LegendDot(color: const Color(0xFFF59E0B), label: 'Partial'),
              SizedBox(width: context.w(16)),
              _LegendDot(color: const Color(0xFF9CA3AF), label: 'Empty'),
            ],
          ),
          SizedBox(height: context.h(16)),
          LayoutBuilder(builder: (_, constraints) {
            final w = constraints.maxWidth;
            final h = w * 1.6;
            return SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  CustomPaint(size: Size(w, h), painter: _BodyPainter(AppColors.primary.withOpacity(0.3))),
                  _Bubble(x: w * 0.60, y: h * 0.02, data: controller.bodyParts.firstWhere((b) => b.key == 'ears'), onTap: () => _showBodyPartSheet(context, controller, 'ears')),
                  _Bubble(x: w * 0.30, y: h * 0.22, data: controller.bodyParts.firstWhere((b) => b.key == 'torso'), onTap: () => _showBodyPartSheet(context, controller, 'torso')),
                  _Bubble(x: w * 0.08, y: h * 0.28, data: controller.bodyParts.firstWhere((b) => b.key == 'hands'), onTap: () => _showBodyPartSheet(context, controller, 'hands'), small: true),
                  _Bubble(x: w * 0.30, y: h * 0.42, data: controller.bodyParts.firstWhere((b) => b.key == 'waist'), onTap: () => _showBodyPartSheet(context, controller, 'waist')),
                  _Bubble(x: w * 0.62, y: h * 0.28, data: controller.bodyParts.firstWhere((b) => b.key == 'head'), onTap: () => _showBodyPartSheet(context, controller, 'head'), small: true),
                  _Bubble(x: w * 0.22, y: h * 0.62, data: controller.bodyParts.firstWhere((b) => b.key == 'feet'), onTap: () => _showBodyPartSheet(context, controller, 'feet'), small: true),
                  _Bubble(x: w * 0.54, y: h * 0.62, data: controller.bodyParts.firstWhere((b) => b.key == 'feet'), onTap: () => _showBodyPartSheet(context, controller, 'feet'), small: true),
                ],
              ),
            );
          }),
          SizedBox(height: context.h(16)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: controller.bodyParts.map((bp) => _BodyPartCard(bp: bp)).toList(),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: context.w(10), height: context.w(10), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: context.w(4)),
        AppText(data: label, fontSize: 12, color: AppColors.textSecondary),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final double x;
  final double y;
  final BodyPartData data;
  final VoidCallback onTap;
  final bool small;
  const _Bubble({required this.x, required this.y, required this.data, required this.onTap, this.small = false});

  @override
  Widget build(BuildContext context) {
    final size = small ? context.w(40) : context.w(56);
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: data.statusColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: AppText(
            data: data.total == 0 ? '0' : '${data.packed}/${data.total}',
            fontSize: small ? 10 : 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BodyPartCard extends StatelessWidget {
  final BodyPartData bp;
  const _BodyPartCard({required this.bp});

  @override
  Widget build(BuildContext context) {
    final cardW = (MediaQuery.of(context).size.width - context.w(64)) / 3;
    return SizedBox(
      width: cardW,
      child: Container(
        padding: EdgeInsets.all(context.w(8)),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(context.w(10)), border: Border.all(color: AppColors.inputBorder)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: context.w(8), height: context.w(8), decoration: BoxDecoration(color: bp.statusColor, shape: BoxShape.circle)),
              SizedBox(width: context.w(4)),
              Expanded(child: AppText(data: bp.name, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ]),
            SizedBox(height: context.h(2)),
            AppText(data: bp.displayCount, fontSize: 11, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final Color color;
  _BodyPainter(this.color);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = color..strokeWidth = 2.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width * 0.5, s.height * 0.08), width: s.width * 0.16, height: s.height * 0.12), p);
    canvas.drawLine(Offset(s.width * 0.47, s.height * 0.14), Offset(s.width * 0.47, s.height * 0.19), p);
    canvas.drawLine(Offset(s.width * 0.53, s.height * 0.14), Offset(s.width * 0.53, s.height * 0.19), p);
    canvas.drawLine(Offset(s.width * 0.22, s.height * 0.21), Offset(s.width * 0.78, s.height * 0.21), p);
    canvas.drawLine(Offset(s.width * 0.22, s.height * 0.21), Offset(s.width * 0.13, s.height * 0.46), p);
    canvas.drawLine(Offset(s.width * 0.78, s.height * 0.21), Offset(s.width * 0.87, s.height * 0.46), p);
    canvas.drawLine(Offset(s.width * 0.28, s.height * 0.21), Offset(s.width * 0.26, s.height * 0.50), p);
    canvas.drawLine(Offset(s.width * 0.72, s.height * 0.21), Offset(s.width * 0.74, s.height * 0.50), p);
    canvas.drawLine(Offset(s.width * 0.26, s.height * 0.50), Offset(s.width * 0.74, s.height * 0.50), p);
    canvas.drawLine(Offset(s.width * 0.38, s.height * 0.50), Offset(s.width * 0.34, s.height * 0.78), p);
    canvas.drawLine(Offset(s.width * 0.34, s.height * 0.78), Offset(s.width * 0.32, s.height * 0.96), p);
    canvas.drawLine(Offset(s.width * 0.62, s.height * 0.50), Offset(s.width * 0.66, s.height * 0.78), p);
    canvas.drawLine(Offset(s.width * 0.66, s.height * 0.78), Offset(s.width * 0.68, s.height * 0.96), p);
  }

  @override
  bool shouldRepaint(_BodyPainter old) => old.color != color;
}

class _DashedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DashedButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.h(14)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border.all(color: AppColors.inputBorder, style: BorderStyle.solid, width: 1.5),
        ),
        alignment: Alignment.center,
        child: AppText(data: label, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }
}

void _showAddItemSheet(BuildContext context, TripDetailController controller, String personId, String bagId) {
  final nameCtrl = TextEditingController();
  final emojiCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final isCritical = false.obs;
  final quantity = '1'.obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(
      title: 'Add Item',
      subtitle: 'You can add your item by filling this filled.',
      buttonLabel: 'Save',
      onSave: () {
        if (nameCtrl.text.isEmpty) return;
        controller.addItemToBag(personId, bagId, PackingItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameCtrl.text,
          emoji: emojiCtrl.text.isNotEmpty ? emojiCtrl.text : '📦',
          quantity: int.tryParse(quantity.value) ?? 1,
          isCritical: isCritical.value,
        ));
        Get.back();
      },
      child: Obx(() => Column(children: [
        AppTextField(controller: nameCtrl, label: 'Item Name', hintText: 'Type Here...'),
        SizedBox(height: 12),
        Row(children: [
          Expanded(child: AppTextField(controller: emojiCtrl, label: 'Emoji', hintText: 'Add Emoji')),
          SizedBox(width: 12),
          Expanded(child: _DropdownField(label: 'Quantity', value: quantity.value, options: ['1','2','3','4','5','10'], onChanged: (v) => quantity.value = v)),
        ]),
        SizedBox(height: 12),
        AppTextField(controller: weightCtrl, label: 'Item Weight (Per item)', hintText: 'Type Here...', keyboardType: TextInputType.number),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () => isCritical.value = !isCritical.value,
          child: Row(children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: isCritical.value ? AppColors.primary : AppColors.inputBorder), color: isCritical.value ? AppColors.primary.withOpacity(0.1) : Colors.transparent),
              child: isCritical.value ? Icon(Icons.check, size: 14, color: AppColors.primary) : null,
            ),
            SizedBox(width: 10),
            const Text('Mark as Critical'),
          ]),
        ),
      ])),
    ),
  );
}

void _showAddBagSheet(BuildContext context, TripDetailController controller, String personId) {
  final nameCtrl = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(
      title: 'Add Bag',
      subtitle: 'You can add your bag by filling this filled.',
      buttonLabel: 'Save',
      onSave: () {
        if (nameCtrl.text.isEmpty) return;
        controller.addBagToPerson(personId, PackingBag(id: DateTime.now().millisecondsSinceEpoch.toString(), name: nameCtrl.text, weightKg: 0, items: []));
        Get.back();
      },
      child: AppTextField(controller: nameCtrl, label: 'Bag Name', hintText: 'Type Here...'),
    ),
  );
}

void _showAddPeopleSheet(BuildContext context, TripDetailController controller) {
  final selected = <String>{}.obs;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(
      title: 'Add People',
      subtitle: 'You can add your family member or friends by filling this filled.',
      buttonLabel: 'Save',
      onSave: () {
        Get.back();
      },
      child: Obx(() => Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
          child: Row(children: [
            const Expanded(child: Text('Select', style: TextStyle(color: Colors.grey))),
            Icon(Icons.unfold_more, color: AppColors.textSecondary),
          ]),
        ),
        SizedBox(height: 12),
        ...controller.members.map((m) => GestureDetector(
          onTap: () => selected.contains(m.id) ? selected.remove(m.id) : selected.add(m.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.inputBorder, shape: BoxShape.circle), child: Center(child: Text(m.name[0], style: const TextStyle(fontWeight: FontWeight.w700)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(m.memberType, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ])),
              if (selected.contains(m.id))
                Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.check, size: 16, color: Colors.white)),
            ]),
          ),
        )),
      ])),
    ),
  );
}

void _showBodyPartSheet(BuildContext context, TripDetailController controller, String partKey) {
  final bp = controller.bodyParts.firstWhere((b) => b.key == partKey);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${bp.name} items', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('You can add your item by filling this filled.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ...controller.packingPersons.expand((p) => p.bags.expand((b) => b.items)).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: item.isPacked ? AppColors.primary : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: item.isPacked ? AppColors.primary : Colors.grey.shade300, width: 2)),
                child: item.isPacked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              Text(item.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Expanded(child: Text(item.name, style: const TextStyle(fontSize: 15))),
              if (item.isCritical) Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 8, color: AppColors.error),
                const SizedBox(width: 4),
                Text('Critical', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ]),
          )),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

class _Sheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onSave;
  final Widget child;
  const _Sheet({required this.title, required this.subtitle, required this.buttonLabel, required this.onSave, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 20),
            AppButton(buttonText: buttonLabel, onPressed: onSave, borderRadius: 30, buttonHeight: 52),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final void Function(String) onChanged;
  const _DropdownField({required this.label, required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(data: label, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        SizedBox(height: context.h(8)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: context.w(12)),
          decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(context.w(10)), border: Border.all(color: AppColors.inputBorder)),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (v) { if (v != null) onChanged(v); },
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          ),
        ),
      ],
    );
  }
}
