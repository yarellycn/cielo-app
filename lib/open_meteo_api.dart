import 'dart:convert';
import 'dart:developer';
import 'package:cielo_app/models/current_weather.dart';
import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/models/forecast_data.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:http/http.dart' as http;

/// Open-Meteo API wrapper
class OpenMeteoApi {
  static const double defaultLatitude = 43.6083;
  static const double defaultLongitude = 3.8855;
  static const String url = 'api.open-meteo.com';

  /// Fetches the current weather data for the specified latitude and longitude.
  Future<ForecastData> fetchForecastData({
    double latitude = defaultLatitude,
    double longitude = defaultLongitude,
  }) async {
    final Map<String, String> params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation,cloud_cover,weather_code',
      'hourly':
          'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation,cloud_cover,weather_code',
      'daily':
          'temperature_2m_min,temperature_2m_max,apparent_temperature_min,apparent_temperature_max,relative_humidity_2m_mean,wind_speed_10m_max,precipitation_sum,cloud_cover_mean,weather_code',
      'past_days': '3',
      'forecast_days': '3',
      'timezone': 'Europe/Paris',
    };

    /// Build the URI for the API request
    final uri = Uri.https(url, '/v1/forecast', params);
    final response = await http.get(uri);

    /// Check if the request was successful
    if (response.statusCode != 200) {
      throw Exception(
        'Open-Meteo request failed with status ${response.statusCode}',
      );
    }

    /// Parse the JSON response
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final currentWeatherData = json['current'] as Map<String, dynamic>?;
    final hourlyWeatherData = json['hourly'] as Map<String, dynamic>?;
    final dailyWeatherData = json['daily'] as Map<String, dynamic>?;
    log('Current weather data: $currentWeatherData');
    log('Hourly weather data: $hourlyWeatherData');
    log('Daily weather data: $dailyWeatherData');

    if (currentWeatherData == null) {
      throw Exception('Current weather not found in Open-Meteo response.');
    }
    if (hourlyWeatherData == null) {
      throw Exception('Hourly weather not found in Open-Meteo response.');
    }
    if (dailyWeatherData == null) {
      throw Exception('Daily weather not found in Open-Meteo response.');
    }

    return ForecastData(
      currentWeatherData: CurrentWeather.fromJson(currentWeatherData),
      hourlyWeatherData: _parseHourlyWeather(hourlyWeatherData),
      dailyWeatherData: _parseDailyWeather(dailyWeatherData),
    );
  }

  List<HourlyWeather> _parseHourlyWeather(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;

    return List.generate(times.length, (index) {
      return HourlyWeather.fromJson({
        'time': times[index],
        'temperature_2m': (json['temperature_2m'] as List<dynamic>)[index],
        'apparent_temperature':
            (json['apparent_temperature'] as List<dynamic>)[index],
        'relative_humidity_2m':
            (json['relative_humidity_2m'] as List<dynamic>)[index],
        'wind_speed_10m': (json['wind_speed_10m'] as List<dynamic>)[index],
        'precipitation': (json['precipitation'] as List<dynamic>)[index],
        'cloud_cover': (json['cloud_cover'] as List<dynamic>)[index],
        'weather_code': (json['weather_code'] as List<dynamic>)[index],
      });
    });
  }

  List<DailyWeather> _parseDailyWeather(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;

    return List.generate(times.length, (index) {
      return DailyWeather.fromJson({
        'time': times[index],
        'temperature_2m_min':
            (json['temperature_2m_min'] as List<dynamic>)[index],
        'temperature_2m_max':
            (json['temperature_2m_max'] as List<dynamic>)[index],
        'apparent_temperature_min':
            (json['apparent_temperature_min'] as List<dynamic>)[index],
        'apparent_temperature_max':
            (json['apparent_temperature_max'] as List<dynamic>)[index],
        'relative_humidity_2m_mean':
            (json['relative_humidity_2m_mean'] as List<dynamic>)[index],
        'wind_speed_10m_max':
            (json['wind_speed_10m_max'] as List<dynamic>)[index],
        'precipitation_sum':
            (json['precipitation_sum'] as List<dynamic>)[index],
        'cloud_cover_mean': (json['cloud_cover_mean'] as List<dynamic>)[index],
        'weather_code': (json['weather_code'] as List<dynamic>)[index],
      });
    });
  }
}
