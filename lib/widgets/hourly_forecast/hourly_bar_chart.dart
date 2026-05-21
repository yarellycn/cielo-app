import 'dart:developer';

import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyBarChart extends StatefulWidget {
  final List<HourlyWeather>? hourlyWeatherData;
  const HourlyBarChart({super.key, required this.hourlyWeatherData});

  @override
  State<HourlyBarChart> createState() => HourlyBarChartState();
}

class HourlyBarChartState extends State<HourlyBarChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.hourlyWeatherData == null || widget.hourlyWeatherData!.isEmpty) {
      return Center(child: Text('Hourly weather data is not available.'));
    }

    final todayHourlyData = getTodayHourlyData(widget.hourlyWeatherData!);

    if (todayHourlyData.isEmpty) {
      return const Center(child: Text('No hourly weather data available.'));
    }

    return BarChart(mainData(todayHourlyData));
  }
}

List<HourlyWeather> getTodayHourlyData(List<HourlyWeather>? hourlyWeatherData) {
  final today = DateUtils.dateOnly(DateTime.now());
  return hourlyWeatherData!.where((hourlyData) {
    final hourlyDate = DateUtils.dateOnly(hourlyData.time);
    return hourlyDate == today;
  }).toList();
}

List<BarChartGroupData> barValues(List<HourlyWeather> todayHourlyData) {
  var showingTooltip = -1;
  return List.generate(todayHourlyData.length, (index) {
    final hourlyData = todayHourlyData[index];

    return BarChartGroupData(
      x: index,
      showingTooltipIndicators: showingTooltip == index ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: hourlyData.precipitation,
          color: AppColors.precipitation,
        ),
      ],
    );
  });
}

Widget bottomTitleWidgets(
  double value,
  TitleMeta meta,
  List<HourlyWeather> todayHourlyData,
  double interval,
) {
  final index = value.toInt();
  final isLastIndex = index == todayHourlyData.length - 1;
  final isIntervalIndex = index % interval == 0;

  if (!isIntervalIndex && !isLastIndex) {
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

AxisRange getAxisRange(List<HourlyWeather> todayHourlyData) {
  final values = todayHourlyData.map((hourlyData) => hourlyData.precipitation);

  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);

  log('Min value: $minValue');
  log('Max value: $maxValue');

  final defaultMinY = 0;
  final defaultMaxY = 4;
  final defaultInterval = 1;

  final chartMaxY = maxValue > defaultMaxY
      ? (maxValue / 10).ceil() * 10
      : defaultMaxY;

  final chartInterval = maxValue > defaultMaxY ? 5 : defaultInterval;

  return AxisRange(
    min: defaultMinY.toDouble(),
    max: chartMaxY.toDouble(),
    interval: chartInterval.toDouble(),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    child: Text(
      '${value.round()} mm',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9,
        color: AppColors.forecastButtonText,
      ),
      textAlign: TextAlign.right,
    ),
  );
}

BarChartData mainData(List<HourlyWeather> todayHourlyData) {
  final bottomTitlesInterval = 2.00;
  final axisYRange = getAxisRange(todayHourlyData);

  return BarChartData(
    gridData: FlGridData(
      show: true,
      horizontalInterval: axisYRange.interval,
      verticalInterval: bottomTitlesInterval,
    ),
    titlesData: FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, todayHourlyData, bottomTitlesInterval),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 46,
          interval: axisYRange.interval,
          getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
        ),
      ),
    ),
    minY: axisYRange.min,
    maxY: axisYRange.max,
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: AppColors.forecastButtonText),
    ),
    barGroups: barValues(todayHourlyData),
  );
}
