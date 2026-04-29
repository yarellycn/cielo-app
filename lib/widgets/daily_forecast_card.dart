import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/models/weather_code.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyWeather dailyWeatherData;

  const DailyForecastCard({super.key, required this.dailyWeatherData});

  @override
  Widget build(BuildContext context) {
    final dayOftheWeek = DateFormat(
      'EEEE',
      'fr_FR',
    ).format(dailyWeatherData.date);
    final dateMonth = DateFormat(
      'd MMMM',
      'fr_FR',
    ).format(dailyWeatherData.date);

    return Container(
      padding: const EdgeInsets.all(15.00),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(
          spacing: 14.00,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Column(
                  spacing: 2.00,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      '${dayOftheWeek[0].toUpperCase()}${dayOftheWeek.substring(1)}',
                      style: const TextStyle(fontWeight: .bold),
                    ),
                    Text(dateMonth),
                  ],
                ),
                Row(),
              ],
            ),
            Text(
              WeatherCode.fromCode(dailyWeatherData.weatherCode)?.description ??
                  'Unknown weather',
            ),
            Column(
              spacing: 7.50,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Température'),
                    Text(
                      '${dailyWeatherData.minTemperature}° / ${dailyWeatherData.maxTemperature}°',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Ressenti'),
                    Text(
                      '${dailyWeatherData.minApparentTemperature}° / ${dailyWeatherData.maxApparentTemperature}°',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Humidité'),
                    Text('${dailyWeatherData.meanRelativeHumidity} %'),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Vent max'),
                    Text('${dailyWeatherData.maxWindSpeed} km/h'),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Précipitations'),
                    Text('${dailyWeatherData.precipitationSum} mm'),
                  ],
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Nuages'),
                    Text('${dailyWeatherData.meanCloudCover} %'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
