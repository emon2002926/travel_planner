import 'package:get/get.dart';

enum RateTrend { up, down }

class CurrencyRate {
  final String id;
  final String currencyName;
  final String symbol;
  final double rate;
  final RateTrend trend;
  final double changePercent;

  const CurrencyRate({
    required this.id,
    required this.currencyName,
    required this.symbol,
    required this.rate,
    required this.trend,
    required this.changePercent,
  });
}

class CurrencyOption {
  final String code;
  final String symbol;
  final String name;
  const CurrencyOption({required this.code, required this.symbol, required this.name});
}

class CurrencyController extends GetxController {
  // ── Converter state ───────────────────────
  final RxString fromCurrency    = 'USD'.obs;
  final RxString toCurrency      = 'BDT'.obs;
  final RxDouble fromAmount      = 80.0.obs;
  final RxDouble toAmount        = 8400.0.obs;
  final RxString lastUpdated     = '2 Days ago'.obs;

  // ── Live rates section ────────────────────
  final RxString liveBaseCurrency = 'USD'.obs;
  final RxList<CurrencyRate> liveRates = <CurrencyRate>[].obs;

  // ── Available currencies ──────────────────
  static const currencies = [
    CurrencyOption(code: 'USD', symbol: '\$',  name: 'US Dollar'),
    CurrencyOption(code: 'BDT', symbol: '৳',   name: 'Bangladeshi Taka'),
    CurrencyOption(code: 'EUR', symbol: '€',   name: 'Euro'),
    CurrencyOption(code: 'GBP', symbol: '£',   name: 'British Pound'),
    CurrencyOption(code: 'JPY', symbol: '¥',   name: 'Japanese Yen'),
    CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
  ];

  // Mock rates table: base USD
  static const _rates = {
    'USD': 1.0,
    'BDT': 110.0,
    'EUR': 0.93,
    'GBP': 0.79,
    'JPY': 149.5,
    'AED': 3.67,
  };

  String get fromSymbol => _symbolFor(fromCurrency.value);
  String get toSymbol   => _symbolFor(toCurrency.value);
  String get liveSymbol => _symbolFor(liveBaseCurrency.value);

  String _symbolFor(String code) =>
      currencies.firstWhere((c) => c.code == code, orElse: () => currencies.first).symbol;

  @override
  void onInit() {
    super.onInit();
    _seedRates();
  }

  void _seedRates() {
    liveRates.assignAll([
      const CurrencyRate(id: 'r1', currencyName: 'Bangladeshi Taka', symbol: '৳', rate: 114, trend: RateTrend.up,   changePercent: 38),
      const CurrencyRate(id: 'r2', currencyName: 'Bangladeshi Taka', symbol: '৳', rate: 114, trend: RateTrend.down, changePercent: 8),
      const CurrencyRate(id: 'r3', currencyName: 'Bangladeshi Taka', symbol: '৳', rate: 114, trend: RateTrend.up,   changePercent: 38),
    ]);
  }

  void onFromAmountChanged(String raw) {
    final val = double.tryParse(raw.replaceAll(',', '')) ?? 0;
    fromAmount.value = val;
    _recalcTo(val);
  }

  void _recalcTo(double from) {
    final fromRate = _rates[fromCurrency.value] ?? 1.0;
    final toRate   = _rates[toCurrency.value]   ?? 1.0;
    toAmount.value = from / fromRate * toRate;
  }

  void swapCurrencies() {
    final tmp = fromCurrency.value;
    fromCurrency.value = toCurrency.value;
    toCurrency.value   = tmp;
    _recalcTo(fromAmount.value);
  }

  void setFromCurrency(String code) {
    fromCurrency.value = code;
    _recalcTo(fromAmount.value);
  }

  void setToCurrency(String code) {
    toCurrency.value = code;
    _recalcTo(fromAmount.value);
  }

  void setLiveBaseCurrency(String code) => liveBaseCurrency.value = code;

  String formatTo(double val) {
    if (val >= 1000) {
      return val.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }
    return val.toStringAsFixed(val == val.roundToDouble() ? 0 : 2);
  }
}
