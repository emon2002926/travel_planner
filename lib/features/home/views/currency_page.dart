import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/currency_controller.dart';

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CurrencyController>()) {
      Get.put(CurrencyController());
    }
    final controller = Get.find<CurrencyController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              _CurrencyHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.w(20), context.h(20),
                    context.w(20), context.h(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ConverterRow(controller: controller),
                      SizedBox(height: context.h(14)),
                      _OfflineSyncRow(controller: controller),
                      SizedBox(height: context.h(24)),
                      _LiveRatesSection(controller: controller),
                    ],
                  ),
                ),
              ),
              _RateAlertButton(),
            ],
          ),
        ),
      );
    });
  }
}



class _CurrencyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: AppText(
              data: 'Currency Converter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            width: context.w(44),
            height: context.w(44),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: context.sp(22)),
                Positioned(
                  top: context.h(10),
                  right: context.w(10),
                  child: Container(
                    width: context.w(7),
                    height: context.w(7),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
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


class _ConverterRow extends StatelessWidget {
  final CurrencyController controller;
  const _ConverterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: 'From', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              SizedBox(height: context.h(8)),
              _AmountField(
                initialValue: controller.fromAmount.value.toInt().toString(),
                symbol: controller.fromSymbol,
                currencyCode: controller.fromCurrency.value,
                onChanged: controller.onFromAmountChanged,
                onCurrencyTap: () => _showPicker(context, controller, isFrom: true),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: context.h(30)),
          child: GestureDetector(
            onTap: controller.swapCurrencies,
            child: Container(
              width: context.w(36),
              height: context.w(36),
              margin: EdgeInsets.symmetric(horizontal: context.w(8)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(8)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Icon(Icons.swap_horiz_outlined, color: AppColors.textSecondary, size: context.sp(20)),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: 'To', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              SizedBox(height: context.h(8)),
              Obx(() => _AmountField(
                initialValue: controller.formatTo(controller.toAmount.value),
                symbol: controller.toSymbol,
                currencyCode: controller.toCurrency.value,
                readOnly: true,
                onCurrencyTap: () => _showPicker(context, controller, isFrom: false),
              )),
            ],
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context, CurrencyController controller, {required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _CurrencyPickerSheet(
        controller: controller,
        isFrom: isFrom,
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String initialValue;
  final String symbol;
  final String currencyCode;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCurrencyTap;

  const _AmountField({
    required this.initialValue,
    required this.symbol,
    required this.currencyCode,
    this.readOnly = false,
    this.onChanged,
    this.onCurrencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              readOnly: readOnly,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'))],
              style: TextStyle(fontSize: context.sp(16), color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(14)),
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
              onChanged: onChanged,
            ),
          ),
          GestureDetector(
            onTap: onCurrencyTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(14)),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.inputBorder)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(data: symbol, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  SizedBox(width: context.w(4)),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: context.sp(18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _OfflineSyncRow extends StatelessWidget {
  final CurrencyController controller;
  const _OfflineSyncRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sync, size: context.sp(15), color: AppColors.textSecondary),
                SizedBox(width: context.w(5)),
                AppText(data: 'Offline Sync', fontSize: 13, color: AppColors.textSecondary),
              ],
            ),
            SizedBox(height: context.h(4)),
            Row(
              children: [
                AppText(data: 'Last Updated : ', fontSize: 13, color: AppColors.textSecondary),
                AppText(data: controller.lastUpdated.value, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ],
            ),
          ],
        ),
        SizedBox(width: context.w(16)),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: context.h(14)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(12)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              alignment: Alignment.center,
              child: AppText(
                data: '+ Add More',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _LiveRatesSection extends StatelessWidget {
  final CurrencyController controller;
  const _LiveRatesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                data: 'Live Dollar(\$) Rate',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => _showLivePicker(context, controller),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(10)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(context.w(10)),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => AppText(
                      data: controller.liveSymbol,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                    SizedBox(width: context.w(4)),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: context.sp(18)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(14)),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.w(16)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            children: controller.liveRates.asMap().entries.map((entry) {
              final isLast = entry.key == controller.liveRates.length - 1;
              return Column(
                children: [
                  _RateRow(rate: entry.value),
                  if (!isLast) Divider(color: AppColors.inputBorder, height: 1, indent: context.w(16), endIndent: context.w(16)),
                ],
              );
            }).toList(),
          ),
        )),
      ],
    );
  }

  void _showLivePicker(BuildContext context, CurrencyController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _CurrencyPickerSheet(
        controller: controller,
        isLiveBase: true,
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final CurrencyRate rate;
  const _RateRow({required this.rate});

  @override
  Widget build(BuildContext context) {
    final isUp    = rate.trend == RateTrend.up;
    final trendColor = isUp ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final trendIcon  = isUp ? Icons.arrow_upward   : Icons.arrow_downward;
    final trendLabel = isUp
        ? 'Rate increase ${rate.changePercent.toInt()}% from last day'
        : 'Rate decrease ${rate.changePercent.toInt()}% from last day';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: rate.currencyName, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                SizedBox(height: context.h(4)),
                Row(
                  children: [
                    Icon(trendIcon, size: context.sp(14), color: trendColor),
                    SizedBox(width: context.w(4)),
                    AppText(data: trendLabel, fontSize: 12, color: trendColor),
                  ],
                ),
              ],
            ),
          ),
          AppText(
            data: '${rate.symbol} ${rate.rate.toInt()}',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}



class _CurrencyPickerSheet extends StatelessWidget {
  final CurrencyController controller;
  final bool isFrom;
  final bool isLiveBase;

  const _CurrencyPickerSheet({
    required this.controller,
    this.isFrom = false,
    this.isLiveBase = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.w(20), context.h(24), context.w(20), context.h(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: 'Select Currency', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            SizedBox(height: context.h(16)),
            ...CurrencyController.currencies.map((c) => GestureDetector(
              onTap: () {
                if (isLiveBase) {
                  controller.setLiveBaseCurrency(c.code);
                } else if (isFrom) {
                  controller.setFromCurrency(c.code);
                } else {
                  controller.setToCurrency(c.code);
                }
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: context.h(10)),
                padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(context.w(12)),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    AppText(data: c.symbol, fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                    SizedBox(width: context.w(14)),
                    Expanded(child: AppText(data: c.name, fontSize: 15, color: AppColors.textPrimary)),
                    AppText(data: c.code, fontSize: 13, color: AppColors.textSecondary),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}


class _RateAlertButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(8), context.w(16), context.h(24)),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.h(18)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(context.w(50)),
          ),
          alignment: Alignment.center,
          child: AppText(data: 'Rate Alert', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
