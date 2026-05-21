import 'dart:convert';

import 'package:cielo_app/models/city.dart';
import 'package:http/http.dart' as http;

class GeocodingApi {
  Future<List<City>> fetchCitiesData({required String cityNameOrCode}) async {
    final params = {
      'name': cityNameOrCode.toString(),
      'count': '10',
      'language': 'fr',
      // 'countryCode': 'FR',
    };

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', params);
    final response = await http.get(uri);

    /// Check if the request was successful
    if (response.statusCode != 200) {
      throw Exception(
        'Open-Meteo request failed with status ${response.statusCode}',
      );
    }

    /// Parse the JSON response
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final cityResults = json['results'] as List<dynamic>?;
    // log('City data: $cityResults');

    if (cityResults == null) {
      return [];
    }

    return cityResults
        .map((city) => City.fromJson(city as Map<String, dynamic>))
        .toList();
  }
}
