import 'package:cielo_app/models/current_weather.dart';
import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/models/hourly_weather.dart';

class ForecastData {
  final CurrentWeather? currentWeatherData;
  final List<HourlyWeather> hourlyWeatherData;
  final List<DailyWeather> dailyWeatherData;

  const ForecastData({
    this.currentWeatherData,
    required this.hourlyWeatherData,
    required this.dailyWeatherData,
  });
}
