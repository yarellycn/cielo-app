import 'dart:developer';

import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/enums/hourly_weather_metric.dart';
import 'package:cielo_app/models/hourly_weather.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/hourly_forecast/hourly_chart_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyBarChart extends StatefulWidget {
  final List<HourlyWeather>? hourlyWeatherData;
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;

  const HourlyBarChart({
    super.key,
    required this.hourlyWeatherData,
    required this.selectedRange,
    required this.selectedCustomRange,
  });

  @override
  State<HourlyBarChart> createState() => HourlyBarChartState();
}

class HourlyBarChartState extends State<HourlyBarChart> {
  @override
  Widget build(BuildContext context) {
    return buildHourlyChart(
      hourlyWeatherData: widget.hourlyWeatherData,
      selectedRange: widget.selectedRange,
      selectedCustomRange: widget.selectedCustomRange,
      builder: (visibleHourlyData) =>
          BarChart(mainData(visibleHourlyData, widget.selectedRange)),
    );
  }
}

List<BarChartGroupData> barValues(List<HourlyWeather> visibleHourlyData) {
  var showingTooltip = -1;
  return List.generate(visibleHourlyData.length, (index) {
    final hourlyData = visibleHourlyData[index];

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
  List<HourlyWeather> visibleHourlyData,
  double interval,
) {
  final index = value.toInt();
  final isLastIndex = index == visibleHourlyData.length - 1;
  final isIntervalIndex = index % interval == 0;

  if (!isIntervalIndex && !isLastIndex) {
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

ChartYAxisRange getAxisRange(List<HourlyWeather> visibleHourlyData) {
  final values = visibleHourlyData.map(
    (hourlyData) => hourlyData.precipitation,
  );

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

  return ChartYAxisRange(
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

BarTooltipItem? barTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
  List<HourlyWeather> visibleHourlyData,
) {
  if (groupIndex < 0 || groupIndex >= visibleHourlyData.length) {
    return null;
  }

  return BarTooltipItem(
    getHourlyTooltipLabel(
      hourlyData: visibleHourlyData[groupIndex],
      selectedMetric: HourlyWeatherMetric.precipitation,
    ),
    const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
  );
}

BarChartData mainData(
  List<HourlyWeather> visibleHourlyData,
  ForecastRange selectedRange,
) {
  final axisYRange = getAxisRange(visibleHourlyData);
  final xInterval = getXInterval(selectedRange, visibleHourlyData);

  return BarChartData(
    gridData: FlGridData(
      show: true,
      horizontalInterval: axisYRange.interval,
      verticalInterval: xInterval,
    ),
    titlesData: FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          // interval:
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, visibleHourlyData, xInterval),
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
    barGroups: barValues(visibleHourlyData),
    barTouchData: BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        maxContentWidth: 220,
        tooltipBorder: BorderSide(
          color: AppColors.forecastButtonBackground,
          width: 1,
        ),
        tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)),
        getTooltipColor: (_) => Colors.white,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItem: (group, groupIndex, rod, rodIndex) =>
            barTooltipItem(group, groupIndex, rod, rodIndex, visibleHourlyData),
      ),
    ),
  );
}
