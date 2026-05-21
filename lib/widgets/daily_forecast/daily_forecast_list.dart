import 'package:cielo_app/models/daily_weather.dart';
import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/widgets/daily_forecast/daily_forecast_card.dart';
import 'package:flutter/material.dart';

class DailyForecastList extends StatefulWidget {
  final List<DailyWeather> dailyWeatherData;
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final double widgetWidth;

  const DailyForecastList({
    super.key,
    required this.dailyWeatherData,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.widgetWidth,
  });

  @override
  State<DailyForecastList> createState() => DailyForecastListState();
}

class DailyForecastListState extends State<DailyForecastList> {
  Widget buildDailyForecastWidget(BuildContext context) {
    final Widget dailyWeatherWidget;

    final dailyWeather = widget.dailyWeatherData;
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
        child: buildDailyForecastWidget(context),
      ),
    );
  }
}
