import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/models/current_weather.dart';
import 'package:cielo_app/models/weather_code.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/current_weather/weather_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentWeatherCard extends StatefulWidget {
  final City? selectedCity;
  final CurrentWeather? currentWeatherData;
  final String? timeZoneAbbreviation;
  final bool shouldStackGrid;

  const CurrentWeatherCard({
    super.key,
    this.selectedCity,
    this.currentWeatherData,
    this.timeZoneAbbreviation,
    required this.shouldStackGrid,
  });

  @override
  State<CurrentWeatherCard> createState() => CurrentWeatherCardState();
}

/// State for [CurrentWeatherCard].
class CurrentWeatherCardState extends State<CurrentWeatherCard> {
  Widget weatherColumnContent(CurrentWeather currentWeather) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat(
      'EEEE d MMMM y HH:mm',
      'fr_FR',
    ).format(currentWeather.time);
    final timezoneAbbreviation = widget.timeZoneAbbreviation;
    final formattedDateWithTimezone = timezoneAbbreviation == null
        ? formattedDate
        : '$formattedDate $timezoneAbbreviation';
    final displayedDate =
        '${formattedDateWithTimezone[0].toUpperCase()}${formattedDateWithTimezone.substring(1)}';
    const weatherIconSize = 64.0;
    final weatherCode = WeatherCode.fromCode(currentWeather.weatherCode);

    return Column(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: .start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Météo Actuelle'.toUpperCase(),
          style: const TextStyle(color: AppColors.secondaryTextOnPrimary),
        ),
        Text(displayedDate),
        Text(
          widget.selectedCity?.name ?? 'Montpellier',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 2,
          children: [
            if (weatherCode != null)
              Image.asset(
                weatherCode.iconAsset,
                width: weatherIconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${currentWeather.temperature}°C',
                  style: textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  weatherCode?.description ?? 'Unknown currentWeather',
                  style: const TextStyle(
                    color: AppColors.secondaryTextOnPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget weatherGrid(
    CurrentWeather currentWeather,
    double tileHeight,
    double tileSpacing,
    int columnCount,
  ) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisExtent: tileHeight,
        mainAxisSpacing: tileSpacing,
        crossAxisSpacing: tileSpacing,
      ),
      children: [
        WeatherInfoTile(
          title: 'Ressenti'.toUpperCase(),
          information: '${currentWeather.apparentTemperature}°C',
          weatherIcon: Icons.thermostat,
        ),
        WeatherInfoTile(
          title: 'Humidité'.toUpperCase(),
          information: '${currentWeather.relativeHumidity}%',
          weatherIcon: Icons.water_drop_outlined,
        ),
        WeatherInfoTile(
          title: 'Vent'.toUpperCase(),
          information: '${currentWeather.windSpeed} km/h',
          weatherIcon: Icons.air,
        ),
        WeatherInfoTile(
          title: 'Précipitations'.toUpperCase(),
          information: '${currentWeather.precipitation} mm',
          weatherIcon: Icons.cloudy_snowing,
        ),
        WeatherInfoTile(
          title: 'Nuages'.toUpperCase(),
          information: '${currentWeather.cloudCover}%',
          weatherIcon: Icons.cloud_queue,
        ),
      ],
    );
  }

  Widget buildCurrentWeatherWidget(BuildContext context) {
    Widget currentWeatherWidget;
    final currentWeather = widget.currentWeatherData;

    if (currentWeather == null) {
      return const Text('No current weather available');
    }
    const cardPadding = 35.0;
    const tileWidth = 135.0;
    const tileHeight = 55.0;
    const tileSpacing = 12.0;

    currentWeatherWidget = Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.mainCardBackgroundPrimaryColor,
              AppColors.mainCardBackgroundSecondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(cardPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final weatherColumnWidth = availableWidth * 0.50;
            final maxGridWidth = (tileWidth * 2) + tileSpacing;
            final gridWidth = maxGridWidth;
            final columnCount = 2;
            final rowCount = (5 / columnCount).ceil();
            final gridHeight =
                (rowCount * tileHeight) + ((rowCount - 1) * tileSpacing);
            final shouldStackGrid = widget.shouldStackGrid;

            if (shouldStackGrid) {
              return Column(
                spacing: cardPadding,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: availableWidth,
                    child: weatherColumnContent(currentWeather),
                  ),
                  SizedBox(
                    width: availableWidth,
                    height: gridHeight,
                    child: weatherGrid(
                      currentWeather,
                      tileHeight,
                      tileSpacing,
                      columnCount,
                    ),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: weatherColumnWidth,
                  child: weatherColumnContent(currentWeather),
                ),
                const Spacer(),
                SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: weatherGrid(
                    currentWeather,
                    tileHeight,
                    tileSpacing,
                    columnCount,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    return currentWeatherWidget;
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
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
        child: buildCurrentWeatherWidget(context),
      ),
    );
    // return buildCurrentWeatherWidget(context);
    // );
  }
}
