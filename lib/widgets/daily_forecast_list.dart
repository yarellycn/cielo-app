import 'package:cielo_app/models/city_data.dart';
import 'package:cielo_app/models/forecast_data.dart';
import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/widgets/daily_forecast_card.dart';
import 'package:flutter/material.dart';

class DailyForecastList extends StatefulWidget {
  final OpenMeteoApi? api;
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final double widgetWidth;
  final CityData? selectedCity;

  const DailyForecastList({
    super.key,
    this.api,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.widgetWidth,
    required this.selectedCity,
  });

  @override
  State<DailyForecastList> createState() => DailyForecastListState();
}

class DailyForecastListState extends State<DailyForecastList> {
  late Future<ForecastData> forecastData;
  final today = DateUtils.dateOnly(DateTime.now());

  double getLatitude() {
    return widget.selectedCity?.latitude ?? OpenMeteoApi.defaultLatitude;
  }

  double getLongitude() {
    return widget.selectedCity?.longitude ?? OpenMeteoApi.defaultLongitude;
  }

  @override
  void initState() {
    super.initState();

    forecastData = (widget.api ?? OpenMeteoApi()).fetchWeatherDataForRange(
      startDate: today.subtract(const Duration(days: 3)),
      endDate: today.add(const Duration(days: 7)),
      latitude: getLatitude(),
      longitude: getLongitude(),
    );
  }

  @override
  void didUpdateWidget(covariant DailyForecastList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final locationHasChanged =
        oldWidget.selectedCity?.latitude != widget.selectedCity?.latitude ||
        oldWidget.selectedCity?.longitude != widget.selectedCity?.longitude;
    final shouldReloadCustomRangeRequest =
        (widget.selectedRange == .custom &&
        (oldWidget.selectedRange != .custom ||
            oldWidget.selectedCustomRange != widget.selectedCustomRange));
    final shouldReloadDefaultRangeRequest =
        (widget.selectedRange != .custom && oldWidget.selectedRange == .custom);

    if (shouldReloadCustomRangeRequest ||
        (locationHasChanged && widget.selectedRange == .custom)) {
      forecastData = (widget.api ?? OpenMeteoApi()).fetchWeatherDataForRange(
        startDate: widget.selectedCustomRange!.start,
        endDate: widget.selectedCustomRange!.end,
        latitude: getLatitude(),
        longitude: getLongitude(),
      );
    } else if (shouldReloadDefaultRangeRequest ||
        (locationHasChanged && widget.selectedRange != .custom)) {
      forecastData = (widget.api ?? OpenMeteoApi()).fetchWeatherDataForRange(
        startDate: today.subtract(const Duration(days: 3)),
        endDate: today.add(const Duration(days: 7)),
        latitude: getLatitude(),
        longitude: getLongitude(),
      );
    }
  }

  Widget buildDailyForecastWidget(
    BuildContext context,
    AsyncSnapshot<ForecastData> snapshot,
  ) {
    final Widget dailyWeatherWidget;

    if (snapshot.connectionState == ConnectionState.waiting) {
      dailyWeatherWidget = const Center(
        child: SizedBox.square(
          dimension: 32,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      dailyWeatherWidget = Text(
        'Unable to load weather data: ${snapshot.error}',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
    } else if (snapshot.hasData) {
      final dailyWeather = snapshot.data!.dailyWeatherData;
      final visibleDailyWeather = switch (widget.selectedRange) {
        ForecastRange.past3Days => dailyWeather.sublist(0, 3),
        ForecastRange.today => dailyWeather.sublist(3, 4),
        ForecastRange.next3Days => dailyWeather.sublist(3, 7),
        ForecastRange.next7Days => dailyWeather.sublist(3, 11),
        ForecastRange.all => dailyWeather,
        ForecastRange.custom => dailyWeather,
      };

      dailyWeatherWidget = LayoutBuilder(
        builder: (context, constraints) {
          final double wrapSpacing = 8;
          final availableWidth = constraints.maxWidth;
          final minDailyForecastWidth =
              (widget.widgetWidth - (wrapSpacing * 3)) / 4;

          double cardWidth = availableWidth;
          for (var i = 1; i < 5; i++) {
            double potentialCardWidth =
                (availableWidth - wrapSpacing * (i - 1)) / i;
            if (potentialCardWidth >= minDailyForecastWidth) {
              cardWidth = potentialCardWidth;
            }
          }

          return Wrap(
            spacing: wrapSpacing,
            runSpacing: wrapSpacing,
            children: List.generate(visibleDailyWeather.length, (index) {
              return SizedBox(
                width: cardWidth,
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
        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
        child: FutureBuilder<ForecastData>(
          future: forecastData,
          builder: buildDailyForecastWidget,
        ),
      ),
    );
  }
}
