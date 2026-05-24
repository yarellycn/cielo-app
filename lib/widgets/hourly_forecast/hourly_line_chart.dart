import 'dart:developer';

import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/enums/hourly_weather_metric.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/hourly_forecast/hourly_chart_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyLineChart extends StatefulWidget {
  final List<HourlyWeather>? hourlyWeatherData;
  final HourlyWeatherMetric selectedMetric;
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final bool isPhoneLayout;

  const HourlyLineChart({
    super.key,
    required this.hourlyWeatherData,
    required this.selectedMetric,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.isPhoneLayout,
  });

  @override
  State<HourlyLineChart> createState() => HourlyLineChartState();
}

class HourlyLineChartState extends State<HourlyLineChart> {
  @override
  Widget build(BuildContext context) {
    return buildHourlyChart(
      hourlyWeatherData: widget.hourlyWeatherData,
      selectedRange: widget.selectedRange,
      selectedCustomRange: widget.selectedCustomRange,
      builder: (visibleHourlyData) => LineChart(
        mainData(
          visibleHourlyData,
          widget.selectedMetric,
          widget.selectedRange,
          widget.isPhoneLayout,
        ),
      ),
    );
  }
}

ChartYAxisRange getYAxisRange(
  List<HourlyWeather> visibleHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  final values = visibleHourlyData.map(
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

      return ChartYAxisRange(
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

      return ChartYAxisRange(
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

      return ChartYAxisRange(
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

      return ChartYAxisRange(
        min: defaultMinY.toDouble(),
        max: chartMaxY.toDouble(),
        interval: chartInterval.toDouble(),
      );
  }
}

Widget bottomTitleWidgets(
  double value,
  TitleMeta meta,
  List<HourlyWeather> visibleHourlyData,
) {
  final index = value.toInt();
  if (index < 0 || index >= visibleHourlyData.length) {
    return const SizedBox.shrink();
  }

  final dateTime = visibleHourlyData[index].time;
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
  List<HourlyWeather> visibleHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  return List.generate(visibleHourlyData.length, (index) {
    final hourlyData = visibleHourlyData[index];
    final value = getHourlyMetricValue(hourlyData, selectedMetric);

    return FlSpot(index.toDouble(), value.toDouble());
  });
}

List<LineTooltipItem?> tooltipItems(
  List<LineBarSpot> touchedSpots,
  List<HourlyWeather> visibleHourlyData,
  HourlyWeatherMetric selectedMetric,
) {
  return touchedSpots.map((touchedSpot) {
    final index = touchedSpot.x.toInt();
    if (index < 0 || index >= visibleHourlyData.length) {
      return null;
    }

    return LineTooltipItem(
      getHourlyTooltipLabel(
        hourlyData: visibleHourlyData[index],
        selectedMetric: selectedMetric,
      ),
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }).toList();
}

LineChartData mainData(
  List<HourlyWeather> visibleHourlyData,
  HourlyWeatherMetric selectedMetric,
  ForecastRange selectedRange,
  bool isPhoneLayout,
) {
  final hourCount = visibleHourlyData.length;
  final metricColor = getMetricColor(selectedMetric);
  final axisYRange = getYAxisRange(visibleHourlyData, selectedMetric);
  final xInterval = getXInterval(
    selectedRange,
    visibleHourlyData,
    isPhoneLayout,
  );

  return LineChartData(
    gridData: FlGridData(
      show: true,
      horizontalInterval: axisYRange.interval,
      verticalInterval: xInterval,
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          interval: xInterval,
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, visibleHourlyData),
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
        spots: spots(visibleHourlyData, selectedMetric),
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
          return tooltipItems(touchedSpots, visibleHourlyData, selectedMetric);
        },
      ),
    ),
  );
}
