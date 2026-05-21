import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/models/forecast_data.dart';
import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/cielo_app_bar.dart';
import 'package:cielo_app/widgets/current_weather_card.dart';
import 'package:cielo_app/widgets/daily_forecast_list.dart';
import 'package:cielo_app/widgets/forecast_range_selector.dart';
import 'package:cielo_app/widgets/hourly_forecast_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cielo',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 55, 162, 216),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  ForecastRange selectedRange = ForecastRange.next3Days;
  DateTimeRange? selectedCustomRange;
  City? selectedCity;

  late Future<ForecastData> presetForecastDataFuture;
  late Future<ForecastData> forecastDataFuture;
  ForecastData? presetForecastData;
  bool isShowingCustomForecastData = false;

  double getLatitude() {
    return selectedCity?.latitude ?? OpenMeteoApi.defaultLatitude;
  }

  double getLongitude() {
    return selectedCity?.longitude ?? OpenMeteoApi.defaultLongitude;
  }

  Future<ForecastData> fetchDefaultForecastData() {
    final today = DateUtils.dateOnly(DateTime.now());

    return OpenMeteoApi()
        .fetchWeatherDataForRange(
          startDate: today.subtract(const Duration(days: 3)),
          endDate: today.add(const Duration(days: 7)),
          latitude: getLatitude(),
          longitude: getLongitude(),
        )
        .then((forecastData) {
          presetForecastData = forecastData;
          return forecastData;
        });
  }

  Future<ForecastData> fetchCustomRangeForecastData(DateTimeRange range) {
    return OpenMeteoApi().fetchWeatherDataForRange(
      startDate: range.start,
      endDate: range.end,
      latitude: getLatitude(),
      longitude: getLongitude(),
    );
  }

  @override
  void initState() {
    super.initState();
    presetForecastDataFuture = fetchDefaultForecastData();
    forecastDataFuture = presetForecastDataFuture;
  }

  Widget getCurrentWeatherCard(BuildContext context, TextTheme textTheme) {
    return FutureBuilder<ForecastData>(
      future: presetForecastDataFuture,
      // initialData: presetForecastData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox.square(
              dimension: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(
            'Unable to load weather data: ${snapshot.error}',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          );
        }

        if (!snapshot.hasData) {
          return const Text('No data available');
        }

        final forecastData = snapshot.data!;

        return CurrentWeatherCard(
          selectedCity: selectedCity,
          currentWeatherData: forecastData.currentWeatherData,
          timeZoneAbbreviation: forecastData.timezoneAbbreviation,
        );
      },
    );
  }

  Widget getForecastRangeSelector() {
    return ForecastRangeSelector(
      selectedRange: selectedRange,
      selectedCustomRange: selectedCustomRange,
      onRangeSelected: (range) {
        setState(() {
          selectedRange = range;

          if (range != ForecastRange.custom) {
            selectedCustomRange = null;

            if (isShowingCustomForecastData) {
              isShowingCustomForecastData = false;
              forecastDataFuture = presetForecastDataFuture;
            }
          }
        });
      },
      onCustomSelectedRange: (range) {
        setState(() {
          selectedRange = ForecastRange.custom;
          selectedCustomRange = range;
          isShowingCustomForecastData = true;
          forecastDataFuture = fetchCustomRangeForecastData(range);
        });
      },
    );
  }

  Widget getHourlyForecastCard(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        FutureBuilder<ForecastData>(
          future: forecastDataFuture,
          // initialData: presetForecastData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.square(
                  dimension: 32,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Unable to load weather data: ${snapshot.error}',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              );
            }

            if (!snapshot.hasData) {
              return const Text('No data available');
            }

            final forecastData = snapshot.data!;

            return HourlyForecastCard(
              selectedRange: selectedRange,
              selectedCustomRange: selectedCustomRange,
              selectedCity: selectedCity,
              hourlyWeatherData: forecastData.hourlyWeatherData,
            );
          },
        ),
      ],
    );
  }

  Widget getDailyWeatherList(
    BuildContext context,
    TextTheme textTheme,
    double dailyWeatherListWidth,
  ) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        Text(
          'Prévisons journalières',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        FutureBuilder<ForecastData>(
          future: forecastDataFuture,
          // initialData: presetForecastData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.square(
                  dimension: 32,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Unable to load weather data: ${snapshot.error}',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              );
            }

            if (!snapshot.hasData) {
              return const Text('No data available');
            }

            final forecastData = snapshot.data!;

            return DailyForecastList(
              dailyWeatherData: forecastData.dailyWeatherData,
              selectedRange: selectedRange,
              selectedCustomRange: selectedCustomRange,
              widgetWidth: dailyWeatherListWidth,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double widgetWidth = 1250.00;
    const double homePadding = 20.00;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: CieloAppBar(
        maxContentWidth: widgetWidth,
        padding: homePadding,
        onCitySelected: (city) {
          setState(() {
            selectedCity = city;
            presetForecastData = null;

            if (selectedRange == ForecastRange.custom &&
                selectedCustomRange != null) {
              isShowingCustomForecastData = true;
              forecastDataFuture = fetchCustomRangeForecastData(
                selectedCustomRange!,
              );
              presetForecastDataFuture = fetchDefaultForecastData();
            } else {
              isShowingCustomForecastData = false;
              presetForecastDataFuture = fetchDefaultForecastData();
              forecastDataFuture = presetForecastDataFuture;
            }
          });
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth < widgetWidth
              ? constraints.maxWidth
              : widgetWidth;

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: ListView(
                padding: const EdgeInsets.all(homePadding),
                children:
                    [
                          getCurrentWeatherCard(context, textTheme),
                          getForecastRangeSelector(),
                          getHourlyForecastCard(context, textTheme),
                          getDailyWeatherList(
                            context,
                            textTheme,
                            widgetWidth - homePadding * 2,
                          ),
                        ]
                        .expand(
                          (widget) => [widget, const SizedBox(height: 20)],
                        )
                        .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
