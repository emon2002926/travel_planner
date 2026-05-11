import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/core/util/app_navigation.dart';

import '../views/welcome_screen.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  static const int totalPages = 4;

  final List<OnBoardingPageData> pages = const [
    OnBoardingPageData(
      imagePath: 'assets/images/on_boarding/on_boarding1.png',
      titleStart: 'Your ',
      titleHighlight: 'Trip',
      titleMiddle: ',\nPerfectly ',
      titleHighlight2: 'Planned',
      description:
      'Build complete itineraries with flights, stays, activities, and notes—all in one app.',
    ),
    OnBoardingPageData(
      imagePath: 'assets/images/on_boarding/on_boarding2.png',
      titleStart: 'See Your\n',
      titleHighlight: 'Journey',
      titleMiddle: ' Clearly',
      description:
      'View your plans in a clean, day-by-day timeline that\'s easy to follow.',
    ),
    OnBoardingPageData(
      imagePath: 'assets/images/on_boarding/on_boarding3.png',
      titleStart: 'Access Plans ',
      titleHighlight: 'Anytime',
      description:
      'Keep your itinerary available offline and get reminders so nothing is missed.',
    ),
    OnBoardingPageData(
      imagePath: 'assets/images/on_boarding/on_boarding4.png',
      titleStart: 'Travel Without the\n',
      titleHighlight: 'Stress',
      description:
      'Edit, update, and share your itinerary effortlessly with travel partners.',
    ),
  ];

  bool get isLastPage => currentPage.value == totalPages - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      getStarted();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  //
  void getStarted() {
    AppNavigation.push(WelcomeScreen());

  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnBoardingPageData {
  final String imagePath;
  final String titleStart;
  final String titleHighlight;
  final String? titleMiddle;
  final String? titleHighlight2;
  final String description;

  const OnBoardingPageData({
    required this.imagePath,
    required this.titleStart,
    required this.titleHighlight,
    this.titleMiddle,
    this.titleHighlight2,
    required this.description,
  });
}