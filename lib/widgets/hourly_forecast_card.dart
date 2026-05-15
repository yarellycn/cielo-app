import 'package:cielo_app/models/city_data.dart';
import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/widgets/hourly_line_chart.dart';
import 'package:flutter/material.dart';

class HourlyForecastCard extends StatefulWidget {
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final CityData? selectedCity;
  final List<HourlyWeather> hourlyWeatherData;

  const HourlyForecastCard({
    super.key,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.selectedCity,
    required this.hourlyWeatherData,
  });

  @override
  State<HourlyForecastCard> createState() => HourlyForecastCardState();
}

class HourlyForecastCardState extends State<HourlyForecastCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.transparent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 20.00,
          children: [
            Row(
              children: [
                Text(
                  'Données horaires',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: HourlyLineChart(hourlyWeatherData: widget.hourlyWeatherData),
            ),
          ],
        ),
      ),
    );
  }
}
