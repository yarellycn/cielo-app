import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/enums/hourly_weather_metric.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartYAxisRange {
  final double min;
  final double max;
  final double interval;

  const ChartYAxisRange({
    required this.min,
    required this.max,
    required this.interval,
  });
}

List<HourlyWeather> getHourlyDataForRange({
  required List<HourlyWeather> hourlyWeatherData,
  required ForecastRange selectedRange,
  required DateTimeRange? selectedCustomRange,
}) {
  final today = DateUtils.dateOnly(DateTime.now());

  final DateTimeRange dateRange = switch (selectedRange) {
    ForecastRange.past3Days => DateTimeRange(
      start: today.subtract(const Duration(days: 3)),
      end: today.subtract(const Duration(days: 1)),
    ),
    ForecastRange.today => DateTimeRange(start: today, end: today),
    ForecastRange.next3Days => DateTimeRange(
      start: today,
      end: today.add(const Duration(days: 3)),
    ),
    ForecastRange.next7Days => DateTimeRange(
      start: today,
      end: today.add(const Duration(days: 7)),
    ),
    ForecastRange.all => DateTimeRange(
      start: today.subtract(const Duration(days: 3)),
      end: today.add(const Duration(days: 7)),
    ),
    ForecastRange.custom =>
      selectedCustomRange ?? DateTimeRange(start: today, end: today),
  };

  return hourlyWeatherData.where((hourlyData) {
    final hourlyDate = DateUtils.dateOnly(hourlyData.time);

    return !hourlyDate.isBefore(dateRange.start) &&
        !hourlyDate.isAfter(dateRange.end);
  }).toList();
}

Widget buildHourlyChart({
  required List<HourlyWeather>? hourlyWeatherData,
  required ForecastRange selectedRange,
  required DateTimeRange? selectedCustomRange,
  required Widget Function(List<HourlyWeather> todayHourlyData) builder,
}) {
  if (hourlyWeatherData == null || hourlyWeatherData.isEmpty) {
    return Center(child: Text('Hourly weather data is not available.'));
  }

  final visibleHourlyData = getHourlyDataForRange(
    hourlyWeatherData: hourlyWeatherData,
    selectedRange: selectedRange,
    selectedCustomRange: selectedCustomRange,
  );

  if (visibleHourlyData.isEmpty) {
    return const Center(child: Text('No hourly weather data available.'));
  }

  return builder(visibleHourlyData);
}

double getXInterval(
  ForecastRange selectedRange,
  List<HourlyWeather> visibleHourlyData,
) {
  int hourCount = visibleHourlyData.length;
  double getInterval(int hourCount, int maxNumberOfTitles) {
    return hourCount / maxNumberOfTitles;
  }

  switch (selectedRange) {
    case ForecastRange.past3Days:
      final maxNumberOfTitles = 12;
      return getInterval(hourCount, maxNumberOfTitles);
    case ForecastRange.today:
      final maxNumberOfTitles = 12;
      return getInterval(hourCount, maxNumberOfTitles);
    case ForecastRange.next3Days:
      final maxNumberOfTitles = 16;
      return getInterval(hourCount, maxNumberOfTitles);
    case ForecastRange.next7Days:
      final maxNumberOfTitles = 16;
      return getInterval(hourCount, maxNumberOfTitles);
    case ForecastRange.all:
      final maxNumberOfTitles = 22;
      return getInterval(hourCount, maxNumberOfTitles);
    case ForecastRange.custom:
      final maxNumberOfTitles = 12;
      return getInterval(hourCount, maxNumberOfTitles);
  }
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
    case HourlyWeatherMetric.precipitation:
      return hourlyData.precipitation;
    case HourlyWeatherMetric.clouds:
      return hourlyData.cloudCover;
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
    case HourlyWeatherMetric.precipitation:
      return 'Précipitation';
    case HourlyWeatherMetric.clouds:
      return 'Nuages';
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
    case HourlyWeatherMetric.precipitation:
      return 'mm';
    case HourlyWeatherMetric.clouds:
      return '%';
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
    case HourlyWeatherMetric.precipitation:
      return AppColors.precipitation;
    case HourlyWeatherMetric.clouds:
      return AppColors.clouds;
  }
}

String getHourlyTooltipLabel({
  required HourlyWeather hourlyData,
  required HourlyWeatherMetric selectedMetric,
}) {
  final formattedDate = DateFormat('EEEE d MMMM', 'fr').format(hourlyData.time);
  final formattedTime = DateFormat('HH:mm', 'fr').format(hourlyData.time);
  final value = getHourlyMetricValue(hourlyData, selectedMetric);
  final label = getMetricLabel(selectedMetric);
  final weatherUnit = getWeatherUnit(selectedMetric);

  return '$formattedDate, $formattedTime\n$label: $value$weatherUnit';
}