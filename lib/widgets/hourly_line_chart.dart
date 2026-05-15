import 'package:cielo_app/models/hourly_weather.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HourlyLineChart extends StatefulWidget {
  final List<HourlyWeather>? hourlyWeatherData;

  const HourlyLineChart({super.key, required this.hourlyWeatherData});

  @override
  State<HourlyLineChart> createState() => HourlyLineChartState();
}

class HourlyLineChartState extends State<HourlyLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  String text = switch (value.toInt()) {
    2 => 'MAR',
    5 => 'JUN',
    8 => 'SEP',
    _ => '',
  };
  return SideTitleWidget(meta: meta, child: Text(text));
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  String text = switch (value.toInt()) {
    0 => '0°C',
    7 => '7°C',
    14 => '14°C',
    21 => '21°C',
    28 => '28°C',
    _ => '',
  };

  return Text(text);
}

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(show: true),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.black),
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 28,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
      ),
    ],
  );
}
