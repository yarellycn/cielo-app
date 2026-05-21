import 'dart:developer';

import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/enums/hourly_weather_metric.dart';
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

    final todayHourlyData = getTodayHourlyData(widget.hourlyWeatherData!);

    if (todayHourlyData.isEmpty) {
      return const Center(child: Text('No hourly weather data available.'));
    }

    return LineChart(mainData(todayHourlyData, widget.selectedMetric));
  }
}

class AxisRange {
  final double min;
  final double max;
  final double interval;

  const AxisRange({
    required this.min,
    required this.max,
    required this.interval,
  });
}

AxisRange getAxisRange(
  List<HourlyWeather> todayHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  final values = todayHourlyData.map(
    (hourlyData) => getHourlyMetricValue(hourlyData, selectedMetric),
  );

  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);

  log('Min value: $minValue');
  log('Max value: $maxValue');

  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
    case HourlyWeatherMetric.apparentTemperature:
      final defaultMinY = 0;
      final defaultMaxY = 30;
      final defaultInterval = 10;

      final chartMinY = minValue < defaultMinY
          ? (minValue / defaultInterval).floor() * defaultInterval
          : defaultMinY;

      final chartMaxY = maxValue > defaultMaxY
          ? (maxValue / defaultInterval).ceil() * defaultInterval
          : defaultMaxY;

      log('chartMinY: $chartMinY');
      log('chartMaxY: $chartMaxY');

      return AxisRange(
        min: chartMinY.toDouble(),
        max: chartMaxY.toDouble(),
        interval: defaultInterval.toDouble(),
      );
    case HourlyWeatherMetric.humidity:
      final defaultMinY = 0;
      final defaultMaxY = 80;
      final defaultInterval = 20;

      final chartMaxY = maxValue > defaultMaxY ? 100 : defaultMaxY;
      final chartInterval = maxValue > defaultMaxY ? 25 : defaultInterval;

      return AxisRange(
        min: defaultMinY.toDouble(),
        max: chartMaxY.toDouble(),
        interval: chartInterval.toDouble(),
      );
    case HourlyWeatherMetric.wind:
      final defaultMinY = 0;
      final defaultMaxY = 20;
      final defaultInterval = 5;

      final chartMaxY = maxValue > defaultMaxY
          ? (maxValue / defaultInterval).ceil() * defaultInterval
          : defaultMaxY;

      return AxisRange(
        min: defaultMinY.toDouble(),
        max: chartMaxY.toDouble(),
        interval: defaultInterval.toDouble(),
      );
    case HourlyWeatherMetric.precipitation:
      throw ArgumentError('Precipitation should use HourlyBarChart.');
    case HourlyWeatherMetric.clouds:
      final defaultMinY = 0;
      final defaultMaxY = 4;
      final defaultInterval = 1;

      final chartMaxY = maxValue > defaultMaxY
          ? (maxValue / defaultInterval).ceil() * defaultInterval
          : defaultMaxY;

      final chartInterval = maxValue > defaultMaxY ? 25 : defaultInterval;

      return AxisRange(
        min: defaultMinY.toDouble(),
        max: chartMaxY.toDouble(),
        interval: chartInterval.toDouble(),
      );
  }
}

List<HourlyWeather> getTodayHourlyData(List<HourlyWeather>? hourlyWeatherData) {
  final today = DateUtils.dateOnly(DateTime.now());
  return hourlyWeatherData!.where((hourlyData) {
    final hourlyDate = DateUtils.dateOnly(hourlyData.time);
    return hourlyDate == today;
  }).toList();
}

num getHourlyMetricValue(
  HourlyWeather hourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
      return hourlyData.temperature;
    case HourlyWeatherMetric.apparentTemperature:
      return hourlyData.apparentTemperature;
    case HourlyWeatherMetric.humidity:
      return hourlyData.relativeHumidity;
    case HourlyWeatherMetric.wind:
      return hourlyData.windSpeed;
    case HourlyWeatherMetric.clouds:
      return hourlyData.cloudCover;
    default:
      return hourlyData.temperature;
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

String getWeatherUnit(HourlyWeatherMetric selectedMetric) {
  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
      return '°C';
    case HourlyWeatherMetric.apparentTemperature:
      return '°C';
    case HourlyWeatherMetric.humidity:
      return '%';
    case HourlyWeatherMetric.wind:
      return 'km/h';
    case HourlyWeatherMetric.clouds:
      return '%';
    default:
      return '°C';
  }
}

MaterialColor getMetricColor(HourlyWeatherMetric selectedMetric) {
  switch (selectedMetric) {
    case HourlyWeatherMetric.temperature:
      return AppColors.temperature;
    case HourlyWeatherMetric.apparentTemperature:
      return AppColors.apparentTemperature;
    case HourlyWeatherMetric.humidity:
      return AppColors.humidity;
    case HourlyWeatherMetric.wind:
      return AppColors.wind;
    case HourlyWeatherMetric.clouds:
      return AppColors.clouds;
    default:
      return AppColors.temperature;
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

Widget leftTitleWidgets(
  double value,
  TitleMeta meta,
  HourlyWeatherMetric selectedMetric,
) {
  final weatherUnit = getWeatherUnit(selectedMetric);

  return SideTitleWidget(
    meta: meta,
    child: Text(
      '${value.round()}$weatherUnit',
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
    final weatherUnit = getWeatherUnit(selectedMetric);

    return LineTooltipItem(
      '$formattedDate, $formattedTime\n$label: $value$weatherUnit',
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }).toList();
}

LineChartData mainData(
  List<HourlyWeather> todayHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  final bottomTitlesInterval = 3.00;
  final hourCount = todayHourlyData.length;
  final metricColor = getMetricColor(selectedMetric);
  final axisYRange = getAxisRange(todayHourlyData, selectedMetric);

  return LineChartData(
    gridData: FlGridData(
      show: true,
      horizontalInterval: axisYRange.interval,
      verticalInterval: bottomTitlesInterval,
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          interval: bottomTitlesInterval,
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, todayHourlyData),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 46,
          interval: axisYRange.interval,
          getTitlesWidget: (value, meta) =>
              leftTitleWidgets(value, meta, selectedMetric),
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: AppColors.forecastButtonText),
    ),
    minX: 0,
    maxX: (hourCount - 1).toDouble(),
    minY: axisYRange.min,
    maxY: axisYRange.max,
    lineBarsData: [
      LineChartBarData(
        spots: spots(todayHourlyData, selectedMetric),
        isCurved: true,
        preventCurveOverShooting: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [
              metricColor.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.35),
            ],
          ),
        ),
        color: metricColor,
      ),
    ],
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        maxContentWidth: 220,
        tooltipBorder: BorderSide(
          color: AppColors.forecastButtonBackground,
          width: 1,
        ),
        tooltipBorderRadius: BorderRadius.all(Radius.circular(12)),
        getTooltipColor: (_) => Colors.white,
        getTooltipItems: (touchedSpots) {
          return tooltipItems(touchedSpots, todayHourlyData, selectedMetric);
        },
      ),
    ),
  );
}
