import 'dart:convert';
import 'dart:developer';
import 'package:cielo_app/models/current_weather.dart';
import 'package:http/http.dart' as http;

/// Open-Meteo API wrapper
class OpenMeteoApi {
  static const double defaultLatitude = 43.6083;
  static const double defaultLongitude = 3.8855;
  static const String url = 'api.open-meteo.com';

  /// Fetches the current weather data for the specified latitude and longitude.
  Future<CurrentWeather> fetchForecastData({
    double latitude = defaultLatitude,
    double longitude = defaultLongitude,
  }) async {
    final Map<String, dynamic> params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation,cloud_cover,weather_code',
      // 'hourly':
      //     'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation,cloud_cover,weather_code',
      // 'daily':
      //     'temperature_2m_min,temperature_2m_max,apparent_temperature_min,apparent_temperature_max,relative_humidity_2m_mean,wind_speed_10m_max,precipitation_sum,cloud_cover_mean,weather_code',
      // 'past_days': 3,
      // 'forecast_days': 3,
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
    final current = json['current'] as Map<String, dynamic>?;
    log('Current weather data: $current');

    if (current == null) {
      throw Exception('Current weather not found in Open-Meteo response');
    }
    return CurrentWeather.fromJson(current);
  }
}
