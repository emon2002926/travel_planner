import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../home/models/trip_model.dart';
import '../../home/controllers/home_controller.dart';

class TripCompletedPage extends StatelessWidget {
  final TripModel trip;
  const TripCompletedPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D1B2A), Color(0xFF0D4A2A), Color(0xFF0A1628)],
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Column(
                children: [
                  SizedBox(height: context.h(60)),
                  Container(
                    width: context.w(80),
                    height: context.w(80),
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Icon(Icons.celebration_outlined, color: Colors.white, size: context.sp(40)),
                  ),
                  SizedBox(height: context.h(24)),
                  AppText(data: 'Trip complete!', fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white),
                  SizedBox(height: context.h(8)),
                  AppText(
                    data: '${trip.destination.split(',').first} · ${trip.dateRange.replaceAll(' - ', ' → ')}',
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  SizedBox(height: context.h(32)),
                  Row(
                    children: [
                      _StatBox(value: trip.duration.split(' ').first, label: 'Days'),
                      SizedBox(width: context.w(12)),
                      _StatBox(value: '6', label: 'Cities'),
                      SizedBox(width: context.w(12)),
                      _StatBox(value: '\$${trip.spend ?? 480}', label: 'Spend'),
                    ],
                  ),
                  SizedBox(height: context.h(24)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.w(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(context.w(16)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(data: 'Trip recap', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        SizedBox(height: context.h(8)),
                        AppText(
                          data: trip.recap ?? 'You walked 87 km, tried 14 new dishes, and visited 9 landmarks. Best day: Sintra.',
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AppButton(
                    buttonText: 'Plan next adventure',
                    onPressed: () {
                      final home = Get.find<HomeController>();
                      home.showCompletedTrip();
                      Get.until((route) => route.isFirst);
                    },
                    borderRadius: 30,
                    buttonHeight: 54,
                  ),
                  SizedBox(height: context.h(12)),
                  GestureDetector(
                    onTap: () {
                      final home = Get.find<HomeController>();
                      home.showCompletedTrip();
                      Get.until((route) => route.isFirst);
                    },
                    child: Container(
                      width: double.infinity,
                      height: context.h(54),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.w(30)),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: AppText(data: 'Close', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: context.h(24)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.h(16)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(context.w(14)),
        ),
        child: Column(
          children: [
            AppText(data: value, fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
            SizedBox(height: context.h(4)),
            AppText(data: label, fontSize: 13, color: Colors.white.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}
