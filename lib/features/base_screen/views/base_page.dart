import 'package:flutter/material.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/widgets/bottom_navigation/custom_bottom_navigation.dart';
import '../../chat/views/ai_assistant.dart';
import '../../safety/views/safety_page.dart';
import '../../settings/views/settings_page.dart';
import '../../trips/views/trips_page.dart';
import '../controllers/base_controller.dart';
import '../../home/views/home_view.dart';
import 'package:get/get.dart';



class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BaseController()); // fresh each time BasePage builds

    final screens = [
      HomePage(),
      TripsPage(),
      AssistantPage(),
      SafetyPage(),
      SettingsScreen(),
    ];

    return Obx(() => Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color(0xFFF0EFE9),
      extendBody: true,

      body: WillPopScope(
        onWillPop: () {
          final key = controller.keyForIndex(controller.currentIndex.value);
          if (key.currentState?.canPop() == true) {
            key.currentState?.pop();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            Navigator(
              key: controller.homeNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[0])],
            ),
            Navigator(
              key: controller.tripsNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[1])],
            ),
            Navigator(
              key: controller.aiAssistantNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[2])],
            ),
            Navigator(
              key: controller.saftyPageNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[3])],
            ),
            Navigator(
              key: controller.settingsNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[4])],
            ),

          ],
        ),
      ),

      bottomNavigationBar: Obx(() => CustomBottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTabSelected: controller.onTabSelected,
        onSupportPressed: () {
          AppNavigation.push(AssistantPage());
         },

      )),
    ));
  }
}