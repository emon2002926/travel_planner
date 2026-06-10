import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TemplateFilter { all, mine, aiGenerated, system }

class PackingTemplateTag {
  final String label;
  final bool isHighlighted;
  const PackingTemplateTag({required this.label, this.isHighlighted = false});
}

class PackingTemplate {
  final String id;
  final String title;
  final int days;
  final int itemCount;
  final int avgDays;
  final TemplateFilter type;
  final List<PackingTemplateTag> tags;

  const PackingTemplate({
    required this.id,
    required this.title,
    required this.days,
    required this.itemCount,
    required this.avgDays,
    required this.type,
    required this.tags,
  });
}

class PackingTemplatesController extends GetxController {
  final Rx<TemplateFilter> activeFilter = TemplateFilter.all.obs;
  final RxList<PackingTemplate> templates = <PackingTemplate>[].obs;

  final nameController   = TextEditingController();
  final emojiController  = TextEditingController();
  final weightController = TextEditingController();
  final RxInt  quantity   = 1.obs;
  final RxBool isCritical = false.obs;

  List<PackingTemplate> get filtered {
    if (activeFilter.value == TemplateFilter.all) return templates;
    return templates.where((t) => t.type == activeFilter.value).toList();
  }

  bool get isItemValid => nameController.text.trim().isNotEmpty && quantity.value > 0;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emojiController.dispose();
    weightController.dispose();
    super.onClose();
  }

  void _seedData() {
    templates.assignAll([
      const PackingTemplate(
        id: 'pt1', title: 'Tokyo Food Tour', days: 5, itemCount: 24, avgDays: 3,
        type: TemplateFilter.system,
        tags: [
          PackingTemplateTag(label: 'System', isHighlighted: true),
          PackingTemplateTag(label: 'Laptop'),
          PackingTemplateTag(label: 'Formal'),
        ],
      ),
      const PackingTemplate(
        id: 'pt2', title: 'Tokyo Food Tour', days: 5, itemCount: 24, avgDays: 3,
        type: TemplateFilter.system,
        tags: [
          PackingTemplateTag(label: 'System', isHighlighted: true),
          PackingTemplateTag(label: 'Laptop'),
          PackingTemplateTag(label: 'Formal'),
        ],
      ),
    ]);
  }

  void setFilter(TemplateFilter filter) => activeFilter.value = filter;

  void useTemplate(String id) {}

  void incrementQty() => quantity.value++;
  void decrementQty() { if (quantity.value > 1) quantity.value--; }

  void resetAddItem() {
    nameController.clear();
    emojiController.clear();
    weightController.clear();
    quantity.value   = 1;
    isCritical.value = false;
  }
}
