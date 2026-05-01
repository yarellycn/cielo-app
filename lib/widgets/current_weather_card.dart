import 'package:cielo_app/models/forecast_data.dart';
import 'package:cielo_app/models/weather_code.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/widgets/weather_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays the current weather data fetched from the Open-Meteo API.
class CurrentWeatherCard extends StatefulWidget {
  final OpenMeteoApi? api;

  const CurrentWeatherCard({super.key, this.api});

  @override
  State<CurrentWeatherCard> createState() => CurrentWeatherCardState();
}

/// State for [CurrentWeatherCard].
class CurrentWeatherCardState extends State<CurrentWeatherCard> {
  late final Future<ForecastData> forecastDataFuture;

  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    forecastDataFuture = (widget.api ?? OpenMeteoApi())
        .fetchWeatherDataForRange(startDate: today, endDate: today);
  }

  /// Builds the card contents for the current [forecastDataFuture] snapshot.
  Widget buildCurrentWeatherWidget(
    BuildContext context,
    AsyncSnapshot<ForecastData> snapshot,
  ) {
    Widget currentWeatherWidget;
    final colorScheme = Theme.of(context).colorScheme;

    if (snapshot.connectionState == ConnectionState.waiting) {
      currentWeatherWidget = const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      currentWeatherWidget = Text(
        'Unable to load weather data: ${snapshot.error}',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
    } else if (snapshot.hasData) {
      final currentWeather = snapshot.data!.currentWeatherData;
      if (currentWeather == null) {
        currentWeatherWidget = const Text('No current weather available');
        return currentWeatherWidget;
      }

      final formattedDate = DateFormat(
        'EEEE d MMMM y HH:mm',
        'fr_FR',
      ).format(currentWeather.time);
      const cardPadding = 35.0;
      const tileWidth = 130.0;
      const tileHeight = 60.0;
      const tileSpacing = 12.0;

      currentWeatherWidget = Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(cardPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final leftColumnWidth = availableWidth * 0.25;
            final maxGridWidth = (tileWidth * 2) + tileSpacing;
            final availableGridWidth = availableWidth - leftColumnWidth;
            final gridWidth = (availableGridWidth >= maxGridWidth)
                ? maxGridWidth
                : tileWidth;
            final columnCount = gridWidth >= maxGridWidth ? 2 : 1;
            final rowCount = (5 / columnCount).ceil();
            final gridHeight =
                (rowCount * tileHeight) + ((rowCount - 1) * tileSpacing);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: leftColumnWidth,
                  child: Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: .start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Météo Actuelle'.toUpperCase()),
                      Text(
                        '${formattedDate[0].toUpperCase()}${formattedDate.substring(1).toLowerCase()}',
                      ),
                      Text('Montpellier'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Icon(Icons.sunny, color: colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text('${currentWeather.temperature} °C'),
                              Text(
                                WeatherCode.fromCode(
                                      currentWeather.weatherCode,
                                    )?.description ??
                                    'Unknown currentWeather',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: GridView(
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
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      currentWeatherWidget = const Text('No data available');
    }

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
        style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
        child: FutureBuilder<ForecastData>(
          future: forecastDataFuture,
          builder: buildCurrentWeatherWidget,
        ),
      ),
    );
  }
}
