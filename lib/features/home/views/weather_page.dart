import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/weather_controller.dart';

import 'dart:math' as math;



class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WeatherController>()) {
      Get.put(WeatherController());
    }
    final controller = Get.find<WeatherController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: BuildAppBar(
          title: 'Weather Now',
          titleFontSize: 18,
          fontWeight: FontWeight.w700,
          titleColor: AppColors.textPrimary,
          iconColor: AppColors.textPrimary,
          backgroundColor: AppColors.scaffoldBg,
          showBackButton: true,
          useMinimalStyle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.w(16),
            context.h(12),
            context.w(16),
            context.h(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MainWeatherCard(controller: controller),
              SizedBox(height: context.h(16)),
              _StatsRow(controller: controller),
              SizedBox(height: context.h(20)),
              _ForecastCard(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}


class _MainWeatherCard extends StatelessWidget {
  final WeatherController controller;
  const _MainWeatherCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.w(20), context.h(20), context.w(20), context.h(0),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF3B77D4),
        borderRadius: BorderRadius.circular(context.w(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DayPill(label: controller.dayLabel.value),
          SizedBox(height: context.h(14)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data: '${controller.currentTemp.value}',
                        fontSize: 72,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: context.h(10)),
                        child: AppText(
                          data: '°',
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(4)),
                  AppText(
                    data: '${controller.condition.value} · feels like ${controller.feelsLike.value}°',
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
              const Spacer(),
              _SunIcon(),
            ],
          ),
          SizedBox(height: context.h(20)),
          Divider(color: Colors.white.withOpacity(0.25), height: 1),
          SizedBox(height: context.h(16)),
          _HourlyStrip(hourly: controller.hourly),
          SizedBox(height: context.h(16)),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  final String label;
  const _DayPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(14), vertical: context.h(6),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: AppText(
        data: label,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(90),
      height: context.w(90),
      child: CustomPaint(painter: _SunPainter()),
    );
  }
}

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center     = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.30;
    final rayStart   = bodyRadius + size.width * 0.04;
    final rayEnd     = rayStart + size.width * 0.14;

    final bodyPaint = Paint()
      ..color = const Color(0xFFFFD03A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, bodyRadius, bodyPaint);

    final rayPaint = Paint()
      ..color = const Color(0xFFFFD03A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 8; i++) {
      final angle  = i * math.pi / 4;
      final start  = Offset(center.dx + rayStart * math.cos(angle), center.dy + rayStart * math.sin(angle));
      final end    = Offset(center.dx + rayEnd   * math.cos(angle), center.dy + rayEnd   * math.sin(angle));
      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _HourlyStrip extends StatelessWidget {
  final List<WeatherHourly> hourly;
  const _HourlyStrip({required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: hourly.map((h) => _HourlyItem(item: h)).toList(),
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final WeatherHourly item;
  const _HourlyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(data: item.time, fontSize: 12, color: Colors.white.withOpacity(0.8)),
        SizedBox(height: context.h(4)),
        AppText(data: '${item.temp}', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        SizedBox(height: context.h(4)),
        Container(
          width: context.w(5),
          height: context.w(5),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ],
    );
  }
}



class _StatsRow extends StatelessWidget {
  final WeatherController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(icon: Icons.air_outlined,        label: 'WIND',     value: controller.windSpeed.value)),
        SizedBox(width: context.w(10)),
        Expanded(child: _StatCard(icon: Icons.grain_outlined,      label: 'RAIN',     value: '${controller.rainChance.value}%')),
        SizedBox(width: context.w(10)),
        Expanded(child: _StatCard(icon: Icons.water_drop_outlined, label: 'HUMIDITY', value: '${controller.humidity.value}%')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12), vertical: context.h(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: context.sp(14), color: AppColors.textSecondary),
              SizedBox(width: context.w(4)),
              AppText(
                data: label,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          AppText(data: value, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}



class _ForecastCard extends StatelessWidget {
  final WeatherController controller;
  const _ForecastCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(20)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: '5-DAY FORECAST',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.h(14)),
          ...controller.forecast.asMap().entries.map((entry) {
            final isLast = entry.key == controller.forecast.length - 1;
            return Column(
              children: [
                _ForecastRow(day: entry.value),
                if (!isLast) ...[
                  SizedBox(height: context.h(4)),
                  Divider(color: AppColors.inputBorder, height: context.h(16)),
                  SizedBox(height: context.h(4)),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final WeatherDay day;
  const _ForecastRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.w(42),
          child: AppText(
            data: day.day,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        Container(
          width: context.w(7),
          height: context.w(7),
          margin: EdgeInsets.only(right: context.w(12)),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: AppText(data: day.condition, fontSize: 14, color: AppColors.textSecondary),
        ),
        AppText(
          data: '${day.high}',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        AppText(data: '°', fontSize: 11, color: AppColors.textSecondary),
        SizedBox(width: context.w(12)),
        AppText(data: '${day.low}', fontSize: 14, color: AppColors.textSecondary),
        AppText(data: '°', fontSize: 11, color: AppColors.textSecondary),
      ],
    );
  }
}