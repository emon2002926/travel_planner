import 'package:get/get.dart';

class FaqItem {
  final String question;
  final RxBool isExpanded;

  FaqItem({required this.question}) : isExpanded = false.obs;
}

class FaqsController extends GetxController {
  final List<FaqItem> faqs = [
    FaqItem(question: 'What does this app do?'),
    FaqItem(question: 'What does this app do?'),
    FaqItem(question: 'What does this app do?'),
    FaqItem(question: 'What does this app do?'),
    FaqItem(question: 'What does this app do?'),
  ];

  void toggle(int index) {
    faqs[index].isExpanded.value = !faqs[index].isExpanded.value;
  }
}