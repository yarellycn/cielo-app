import 'package:cielo_app/models/city_data.dart';
import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/models/hourly_weather_metric.dart';
import 'package:cielo_app/theme/app_button_styles.dart';
import 'package:cielo_app/theme/app_colors.dart';
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
  HourlyWeatherMetric selectedMetric = HourlyWeatherMetric.temperature;

  @override
  Widget build(BuildContext context) {
    Widget hourlyMetricButton({
      required HourlyWeatherMetric metric,
      required String label,
    }) {
      final isSelected = selectedMetric == metric;

      return FilledButton(
        style: AppButtonStyles.hourlyMetricButton(
          context,
          isSelected: isSelected,
        ),
        onPressed: () => setState(() {
          selectedMetric = metric;
        }),
        child: Text(label),
      );
    }

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
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Données horaires',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.mainBackgroundColor,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: .center,
                    children: [
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.temperature,
                        label: 'Température',
                      ),
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.apparentTemperature,
                        label: 'Ressenti',
                      ),
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.humidity,
                        label: 'Humidité',
                      ),
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.wind,
                        label: 'Vent',
                      ),
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.precipitation,
                        label: 'Précipitations',
                      ),
                      hourlyMetricButton(
                        metric: HourlyWeatherMetric.clouds,
                        label: 'Nuages',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 20),
                child: HourlyLineChart(
                  hourlyWeatherData: widget.hourlyWeatherData,
                  selectedMetric: selectedMetric,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
