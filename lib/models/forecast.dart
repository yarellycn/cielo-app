import 'package:cielo_app/models/current_weather.dart';
import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/models/hourly_weather.dart';

class Forecast {
  final String? timezone;
  final String? timezoneAbbreviation;
  final int? utcOffsetSeconds;
  final CurrentWeather? currentWeatherData;
  final List<HourlyWeather> hourlyWeatherData;
  final List<DailyWeather> dailyWeatherData;

  const Forecast({
    this.timezone,
    this.timezoneAbbreviation,
    this.utcOffsetSeconds,
    this.currentWeatherData,
    required this.hourlyWeatherData,
    required this.dailyWeatherData,
  });
}
