import 'package:get/get.dart';


class Home20Controller extends GetxController {
  final Rx<PlanType> selectedPlan = PlanType.family.obs;

  void selectPlan(PlanType plan) => selectedPlan.value = plan;

  void onNext() {}

  void onDismiss() {}
}

enum PlanType { free, plus, family }

class PlanFeature {
  final String text;
  final bool included;

  const PlanFeature(this.text, {required this.included});
}

class PlanData {
  final String emoji;
  final String title;
  final String? price;
  final String? badge;
  final List<PlanFeature> features;
  final PlanType plan;

  const PlanData({
    required this.emoji,
    required this.title,
    this.price,
    this.badge,
    required this.features,
    required this.plan,
  });
}

final List<PlanData> plans = [
  PlanData(
    emoji: '⭐',
    title: 'Free',
    plan: PlanType.free,
    features: [
      const PlanFeature('Up to 3 active trips', included: true),
      const PlanFeature('Basic packing lists', included: true),
      const PlanFeature('3 packing templates', included: true),
      const PlanFeature('Offline vault for 2 documents', included: true),
      const PlanFeature('AI packing suggestions', included: false),
      const PlanFeature('Unlimited templates', included: false),
      const PlanFeature('Expense export tools', included: false),
    ],
  ),
  PlanData(
    emoji: '🏆',
    title: 'Plus',
    price: '\$4.99/mo',
    plan: PlanType.plus,
    features: [
      const PlanFeature('Unlimited trips & templates', included: true),
      const PlanFeature('AI-powered packing suggestions', included: true),
      const PlanFeature('Expense export (PDF/CSV)', included: true),
      const PlanFeature('Unlimited offline travel vault', included: true),
      const PlanFeature('Shared family vault', included: false),
      const PlanFeature('Shared family templates', included: false),
    ],
  ),
  PlanData(
    emoji: '👑',
    title: 'Family',
    price: '\$9.99/mo',
    badge: 'Save \$0.99',
    plan: PlanType.family,
    features: [
      const PlanFeature('Up to 6 family members', included: true),
      const PlanFeature('Shared family packing lists', included: true),
      const PlanFeature('Shared travel vault & expenses', included: true),
      const PlanFeature('Family packing templates', included: true),
    ],
  ),
];