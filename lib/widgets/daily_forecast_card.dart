import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/models/weather_code.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyWeather dailyWeatherData;

  const DailyForecastCard({super.key, required this.dailyWeatherData});

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final dayOftheWeek = DateFormat(
      'EEEE',
      'fr_FR',
    ).format(dailyWeatherData.date);
    final dateMonth = DateFormat(
      'd MMMM',
      'fr_FR',
    ).format(dailyWeatherData.date);

    final isItToday = dailyWeatherData.date == today;

    final textTheme = Theme.of(context).textTheme.bodySmall;
    final double parametersRowSpacing = 10;

    final labelStyle = textTheme?.copyWith(
      color: AppColors.forecastButtonText,
      fontSize: 11.6,
    );
    final valueStyle = labelStyle?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: isItToday
          ? AppColors.highlightedItemBackground
          : Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isItToday
              ? AppColors.highlightedItemBorder
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: DefaultTextStyle(
        style: textTheme!.copyWith(
          color: AppColors.forecastButtonText,
          fontSize: 11.6,
        ),
        child: IconTheme(
          data: const IconThemeData(size: 14),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              spacing: 13.00,
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          isItToday
                              ? "Aujourd'hui"
                              : '${dayOftheWeek[0].toUpperCase()}${dayOftheWeek.substring(1)}',
                          style: TextStyle(
                            color: isItToday
                                ? AppColors.highlightedItemText
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(dateMonth),
                      ],
                    ),
                    Row(),
                  ],
                ),
                Text(
                  WeatherCode.fromCode(
                        dailyWeatherData.weatherCode,
                      )?.description ??
                      'Unknown weather',
                ),
                Column(
                  spacing: 6.50,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.thermostat, color: Colors.blue),
                            Text('Température'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.minTemperature}° / ${dailyWeatherData.maxTemperature}°',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.thermostat, color: Colors.orange),
                            Text('Ressenti'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.minApparentTemperature}° / ${dailyWeatherData.maxApparentTemperature}°',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.water_drop_outlined, color: Colors.blue),
                            Text('Humidité'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.meanRelativeHumidity}%',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.air, color: Colors.green),
                            Text('Vent max'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.maxWindSpeed} km/h',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.cloudy_snowing, color: Colors.grey),
                            Text('Précipitations'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.precipitationSum} mm',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: parametersRowSpacing,
                          children: [
                            Icon(Icons.cloud_queue, color: Colors.pink),
                            Text('Nuages'),
                          ],
                        ),
                        Text(
                          '${dailyWeatherData.meanCloudCover}%',
                          style: valueStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
