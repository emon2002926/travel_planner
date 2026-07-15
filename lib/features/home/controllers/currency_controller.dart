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
  final RxString fromCurrency    = 'USD'.obs;
  final RxString toCurrency      = 'BDT'.obs;
  final RxDouble fromAmount      = 80.0.obs;
  final RxDouble toAmount        = 8400.0.obs;
  final RxString lastUpdated     = '2 Days ago'.obs;

  final RxString liveBaseCurrency = 'USD'.obs;
  final RxList<CurrencyRate> liveRates = <CurrencyRate>[].obs;


  static const currencies = [
    CurrencyOption(code: 'USD', symbol: '\$',  name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: '€',   name: 'Euro'),
    CurrencyOption(code: 'GBP', symbol: '£',   name: 'British Pound'),
    CurrencyOption(code: 'JPY', symbol: '¥',   name: 'Japanese Yen'),
    CurrencyOption(code: 'CNY', symbol: '¥',   name: 'Chinese Yuan'),
    CurrencyOption(code: 'INR', symbol: '₹',   name: 'Indian Rupee'),
    CurrencyOption(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    CurrencyOption(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    CurrencyOption(code: 'CHF', symbol: 'Fr',  name: 'Swiss Franc'),
    CurrencyOption(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar'),
    CurrencyOption(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    CurrencyOption(code: 'KRW', symbol: '₩',   name: 'South Korean Won'),
    CurrencyOption(code: 'BDT', symbol: '৳',   name: 'Bangladeshi Taka'),
    CurrencyOption(code: 'PKR', symbol: '₨',   name: 'Pakistani Rupee'),
    CurrencyOption(code: 'SAR', symbol: '﷼',  name: 'Saudi Riyal'),
    CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    CurrencyOption(code: 'THB', symbol: '฿',   name: 'Thai Baht'),
    CurrencyOption(code: 'MYR', symbol: 'RM',  name: 'Malaysian Ringgit'),
    CurrencyOption(code: 'IDR', symbol: 'Rp',  name: 'Indonesian Rupiah'),
    CurrencyOption(code: 'PHP', symbol: '₱',   name: 'Philippine Peso'),
    CurrencyOption(code: 'VND', symbol: '₫',   name: 'Vietnamese Dong'),
    CurrencyOption(code: 'ZAR', symbol: 'R',   name: 'South African Rand'),
    CurrencyOption(code: 'RUB', symbol: '₽',   name: 'Russian Ruble'),
    CurrencyOption(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    CurrencyOption(code: 'MXN', symbol: '\$',  name: 'Mexican Peso'),
    CurrencyOption(code: 'TRY', symbol: '₺',   name: 'Turkish Lira'),
    CurrencyOption(code: 'PLN', symbol: 'zł',  name: 'Polish Zloty'),
    CurrencyOption(code: 'SEK', symbol: 'kr',  name: 'Swedish Krona'),
    CurrencyOption(code: 'NOK', symbol: 'kr',  name: 'Norwegian Krone'),
    CurrencyOption(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar'),
  ];

  static const _rates = {
    'USD': 1.0,
    'EUR': 0.93,
    'GBP': 0.79,
    'JPY': 149.5,
    'CNY': 7.24,
    'INR': 83.5,
    'AUD': 1.53,
    'CAD': 1.36,
    'CHF': 0.88,
    'HKD': 7.82,
    'SGD': 1.34,
    'KRW': 1320.0,
    'BDT': 110.0,
    'PKR': 278.0,
    'SAR': 3.75,
    'AED': 3.67,
    'THB': 35.5,
    'MYR': 4.72,
    'IDR': 15600.0,
    'PHP': 56.0,
    'VND': 24300.0,
    'ZAR': 18.5,
    'RUB': 92.5,
    'BRL': 4.97,
    'MXN': 17.1,
    'TRY': 32.0,
    'PLN': 3.95,
    'SEK': 10.6,
    'NOK': 10.8,
    'NZD': 1.64,
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
    liveRates.assignAll(currencies.map((c) {
      final rate = _rates[c.code] ?? 1.0;
      final trend = rate > 1.0 ? RateTrend.up : RateTrend.down;
      final changePercent = (rate * 0.5).clamp(0.1, 50.0);
      return CurrencyRate(
        id: c.code,
        currencyName: c.name,
        symbol: c.symbol,
        rate: rate,
        trend: trend,
        changePercent: changePercent,
      );
    }).toList());
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
