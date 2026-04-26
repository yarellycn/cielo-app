import 'package:cielo_app/models/weather_code.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/widgets/weather_info_tile.dart';
import 'package:flutter/material.dart';

/// A widget that displays the current weather data fetched from the Open-Meteo API.
class CurrentWeatherCard extends StatefulWidget {
  final OpenMeteoApi? api;

  const CurrentWeatherCard({super.key, this.api});

  @override
  State<CurrentWeatherCard> createState() => CurrentWeatherCardState();
}

/// State for [CurrentWeatherCard].
class CurrentWeatherCardState extends State<CurrentWeatherCard> {
  late final Future<Map> forecastDataFuture;

  @override
  void initState() {
    super.initState();
    forecastDataFuture = (widget.api ?? OpenMeteoApi()).fetchForecastData();
  }

  /// Builds the card contents for the current [forecastDataFuture] snapshot.
  Widget buildWeatherWidget(BuildContext context, AsyncSnapshot<Map> snapshot) {
    final Widget weatherWidget;

    if (snapshot.connectionState == ConnectionState.waiting) {
      weatherWidget = const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      weatherWidget = Text(
        'Unable to load weather data: ${snapshot.error}',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
    } else if (snapshot.hasData) {
      final screenWidth = MediaQuery.of(context).size.width;
      final cardWidth = screenWidth * 0.85;
      const cardPadding = 35.0;
      const tileWidth = 130.0;
      const tileHeight = 60.0;
      const tileSpacing = 12.0;

      weatherWidget = Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 60, 123, 175),
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
                      Text(
                        'Météo Actuelle'.toUpperCase(),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Montpellier',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.wb_sunny),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text('${snapshot.data!['temperature_2m']} °C'),
                              Text(
                                WeatherCode.fromCode(
                                      snapshot.data!['weather_code'] as int,
                                    )?.description ??
                                    'Unknown weather',
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
                        information:
                            '${snapshot.data!['apparent_temperature']} °C',
                      ),
                      WeatherInfoTile(
                        title: 'Humidité'.toUpperCase(),
                        information:
                            '${snapshot.data!['relative_humidity_2m']} %',
                      ),
                      WeatherInfoTile(
                        title: 'Vent'.toUpperCase(),
                        information: '${snapshot.data!['wind_speed_10m']} km/h',
                      ),
                      WeatherInfoTile(
                        title: 'Précipitations'.toUpperCase(),
                        information: '${snapshot.data!['precipitation']} mm',
                      ),
                      WeatherInfoTile(
                        title: 'Nuages'.toUpperCase(),
                        information: '${snapshot.data!['cloud_cover']} %',
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
      weatherWidget = const Text('No data available');
    }

    return weatherWidget;
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
        child: FutureBuilder<Map>(
          future: forecastDataFuture,
          builder: buildWeatherWidget,
        ),
      ),
    );
  }
}
