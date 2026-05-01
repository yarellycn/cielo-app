import 'package:cielo_app/models/forecast_data.dart';
import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/widgets/daily_forecast_card.dart';
import 'package:flutter/material.dart';

class DailyForecastList extends StatefulWidget {
  final OpenMeteoApi? api;
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;

  const DailyForecastList({
    super.key,
    this.api,
    required this.selectedRange,
    required this.selectedCustomRange,
  });

  @override
  State<DailyForecastList> createState() => DailyForecastListState();
}

class DailyForecastListState extends State<DailyForecastList> {
  late final Future<ForecastData> forecastDataFuture;

  @override
  void initState() {
    super.initState();
    forecastDataFuture = (widget.api ?? OpenMeteoApi()).fetchForecastData();
  }

  Widget buildDailyForecastWidget(
    BuildContext context,
    AsyncSnapshot<ForecastData> snapshot,
  ) {
    final Widget dailyWeatherWidget;

    if (snapshot.connectionState == ConnectionState.waiting) {
      dailyWeatherWidget = const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      dailyWeatherWidget = Text(
        'Unable to load weather data: ${snapshot.error}',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
    } else if (snapshot.hasData) {
      final dailyWeather = snapshot.data!.dailyWeatherData;
      final selectedCustomRange = widget.selectedCustomRange;
      final visibleDailyWeather = switch (widget.selectedRange) {
        ForecastRange.past3Days => dailyWeather.sublist(0, 3),
        ForecastRange.today => dailyWeather.sublist(3, 4),
        ForecastRange.next3Days => dailyWeather.sublist(3, 7),
        ForecastRange.next7Days => dailyWeather.sublist(3),
        ForecastRange.all => dailyWeather,
        ForecastRange.custom =>
          selectedCustomRange == null
              ? dailyWeather.sublist(3, 4)
              : dailyWeather.where((dailyWeather) {
                  final date = DateUtils.dateOnly(dailyWeather.date);
                  final start = DateUtils.dateOnly(selectedCustomRange.start);
                  final end = DateUtils.dateOnly(selectedCustomRange.end);

                  return !date.isBefore(start) && !date.isAfter(end);
                }).toList(),
      };

      dailyWeatherWidget = LayoutBuilder(
        builder: (context, constraints) {
          // final columnCount = 3;
          // final cardHeight = 220.0;
          // final cardSpacing = 12.0;

          // return GridView(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: columnCount,
          //     mainAxisExtent: cardHeight,
          //     mainAxisSpacing: cardSpacing,
          //     crossAxisSpacing: cardSpacing,
          //   ),
          //   children: List.generate(dailyWeather.length, (index) {
          //     return DailyForecastCard(dailyWeatherData: dailyWeather[index]);
          //   }),
          // );
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(visibleDailyWeather.length, (index) {
              return SizedBox(
                width: 260,
                child: DailyForecastCard(
                  dailyWeatherData: visibleDailyWeather[index],
                ),
              );
            }),
          );
        },
      );
    } else {
      dailyWeatherWidget = const Text('No data available');
    }

    return dailyWeatherWidget;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: FutureBuilder<ForecastData>(
          future: forecastDataFuture,
          builder: buildDailyForecastWidget,
        ),
      ),
    );
  }
}
