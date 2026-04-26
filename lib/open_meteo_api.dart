import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

/// Open-Meteo API wrapper
class OpenMeteoApi {
  static const double defaultLatitude = 43.6083;
  static const double defaultLongitude = 3.8855;
  static const String url = 'api.open-meteo.com';

  /// Fetches the current weather data for the specified latitude and longitude.
  Future<Map> fetchForecastData({
    double latitude = defaultLatitude,
    double longitude = defaultLongitude,
  }) async {
    final Map<String, dynamic> params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation,cloud_cover,weather_code',
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
    final Map<String, dynamic>? json = jsonDecode(response.body);
    final Map<String, dynamic>? current = json?['current'];
    log('Current weather data: $current');

    if (current == null) {
      throw Exception('Temperature not found in Open-Meteo response');
    }
    return current;
  }
}
