import 'dart:developer';

import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/models/hourly_weather_metric.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyLineChart extends StatefulWidget {
  final List<HourlyWeather>? hourlyWeatherData;
  final HourlyWeatherMetric selectedMetric;

  const HourlyLineChart({
    super.key,
    required this.hourlyWeatherData,
    required this.selectedMetric,
  });

  @override
  State<HourlyLineChart> createState() => HourlyLineChartState();
}

class HourlyLineChartState extends State<HourlyLineChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.hourlyWeatherData == null || widget.hourlyWeatherData!.isEmpty) {
      return Center(child: Text('Hourly weather data is not available.'));
    }
    return LineChart(mainData(widget.hourlyWeatherData, widget.selectedMetric));
  }
}

num getHourlyMetricValue(
  HourlyWeather hourly,
  HourlyWeatherMetric selectedMetric,
) {
  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
      return hourly.temperature;
    case HourlyWeatherMetric.apparentTemperature:
      return hourly.apparentTemperature;
    case HourlyWeatherMetric.humidity:
      return hourly.relativeHumidity;
    case HourlyWeatherMetric.wind:
      return hourly.windSpeed;
    case HourlyWeatherMetric.clouds:
      return hourly.cloudCover;
    default:
      return hourly.temperature;
  }
}

String getMetricLabel(HourlyWeatherMetric selectedMetric) {
  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
      return 'Température';
    case HourlyWeatherMetric.apparentTemperature:
      return 'Ressenti';
    case HourlyWeatherMetric.humidity:
      return 'Humidité';
    case HourlyWeatherMetric.wind:
      return 'Vent';
    case HourlyWeatherMetric.clouds:
      return 'Nuages';
    default:
      return 'Température';
  }
}

Widget bottomTitleWidgets(
  double value,
  TitleMeta meta,
  List<HourlyWeather> todayHourlyData,
) {
  final index = value.toInt();
  if (index < 0 || index >= todayHourlyData.length) {
    return const SizedBox.shrink();
  }

  final dateTime = todayHourlyData[index].time;
  final formattedDate = DateFormat('dd/MM').format(dateTime);
  final formattedTime = DateFormat('HH:mm').format(dateTime);

  final label = '$formattedDate\n$formattedTime';

  return SideTitleWidget(
    meta: meta,
    child: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9,
        color: AppColors.forecastButtonText,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    child: Text(
      '${value.round()}°C',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9,
        color: AppColors.forecastButtonText,
      ),
      textAlign: TextAlign.right,
    ),
  );
}

List<FlSpot> spots(
  List<HourlyWeather> todayHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  return List.generate(todayHourlyData.length, (index) {
    final hourlyData = todayHourlyData[index];
    final value = getHourlyMetricValue(hourlyData, selectedMetric);

    return FlSpot(index.toDouble(), value.toDouble());
  });
}

List<LineTooltipItem?> tooltipItems(
  List<LineBarSpot> touchedSpots,
  List<HourlyWeather> todayHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  return touchedSpots.map((touchedSpot) {
    final index = touchedSpot.x.toInt();
    if (index < 0 || index >= todayHourlyData.length) {
      return null;
    }
    final hourlyData = todayHourlyData[index];
    final dateTime = hourlyData.time;
    final formattedDate = DateFormat('EEEE d MMMM', 'fr').format(dateTime);
    final formattedTime = DateFormat('HH:mm', 'fr').format(dateTime);
    final value = getHourlyMetricValue(hourlyData, selectedMetric);
    final label = getMetricLabel(selectedMetric);

    return LineTooltipItem(
      '$formattedDate, $formattedTime\n$label: $value°C',
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }).toList();
}

LineChartData mainData(
  List<HourlyWeather>? hourlyWeatherData,
  HourlyWeatherMetric selectedMetric,
) {
  final today = DateUtils.dateOnly(DateTime.now());

  final todayHourlyData = hourlyWeatherData!.where((hourly) {
    final hourlyDate = DateUtils.dateOnly(hourly.time);
    return hourlyDate == today;
  }).toList();

  final values = todayHourlyData.map(
    (hourly) => getHourlyMetricValue(hourly, selectedMetric),
  );

  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);
  log('Min value: $minValue');
  log('Max value: $maxValue');

  final defaultMinY = 0;
  final defaultMaxY = 30;
  final leftTitlesInterval = 10;

  final chartMinY = minValue < defaultMinY
      ? (minValue / leftTitlesInterval).floor() * leftTitlesInterval
      : defaultMinY;

  final chartMaxY = maxValue > defaultMaxY
      ? (maxValue / leftTitlesInterval).ceil() * leftTitlesInterval
      : defaultMaxY;

  log('chartMinY: $chartMinY');
  log('chartMaxY: $chartMaxY');

  final hourCount = todayHourlyData.length;

  return LineChartData(
    gridData: FlGridData(
      show: true,
      horizontalInterval: leftTitlesInterval.toDouble(),
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          interval: 3,
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, todayHourlyData),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 46,
          interval: leftTitlesInterval.toDouble(),
          getTitlesWidget: leftTitleWidgets,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: AppColors.forecastButtonText),
    ),
    minX: 0,
    maxX: (hourCount - 1).toDouble(),
    minY: chartMinY.toDouble(),
    maxY: chartMaxY.toDouble(),
    lineBarsData: [
      LineChartBarData(
        spots: spots(todayHourlyData, selectedMetric),
        isCurved: true,
      ),
    ],
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        maxContentWidth: 220,
        getTooltipItems: (touchedSpots) {
          return tooltipItems(touchedSpots, todayHourlyData, selectedMetric);
        },
      ),
    ),
  );
}
