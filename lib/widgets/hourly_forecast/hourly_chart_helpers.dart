import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:flutter/material.dart';

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
  if (hourlyWeatherData == null || hourlyWeatherData!.isEmpty) {
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
