import 'package:get/get.dart';

class WeatherHourly {
  final String time;
  final int temp;
  const WeatherHourly({required this.time, required this.temp});
}

class WeatherDay {
  final String day;
  final String condition;
  final int high;
  final int low;
  const WeatherDay({required this.day, required this.condition, required this.high, required this.low});
}

class WeatherController extends GetxController {
  final RxInt currentTemp        = 24.obs;
  final RxInt feelsLike          = 26.obs;
  final RxString condition       = 'Sunny'.obs;
  final RxString windSpeed       = '12 km/h'.obs;
  final RxInt rainChance         = 10.obs;
  final RxInt humidity           = 58.obs;
  final RxString dayLabel        = 'Today'.obs;

  final RxList<WeatherHourly> hourly = <WeatherHourly>[].obs;
  final RxList<WeatherDay>    forecast = <WeatherDay>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    hourly.assignAll([
      const WeatherHourly(time: '6am',  temp: 18),
      const WeatherHourly(time: '12p',  temp: 23),
      const WeatherHourly(time: '3p',   temp: 26),
      const WeatherHourly(time: '6pm',  temp: 24),
      const WeatherHourly(time: '9pm',  temp: 20),
    ]);

    forecast.assignAll([
      const WeatherDay(day: 'Mon', condition: 'Sunny',         high: 24, low: 16),
      const WeatherDay(day: 'Tue', condition: 'Partly cloudy', high: 22, low: 15),
      const WeatherDay(day: 'Wed', condition: 'Light rain',    high: 19, low: 14),
      const WeatherDay(day: 'Thu', condition: 'Cloudy',        high: 21, low: 15),
      const WeatherDay(day: 'Fri', condition: 'Cloudy',        high: 21, low: 15),
    ]);
  }
}
