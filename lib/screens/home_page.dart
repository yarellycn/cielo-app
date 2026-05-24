import 'package:flutter/material.dart';
import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/models/forecast.dart';
import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/open_meteo_api.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/app_bar/cielo_app_bar.dart';
import 'package:cielo_app/widgets/current_weather/current_weather_card.dart';
import 'package:cielo_app/widgets/daily_forecast/daily_forecast_list.dart';
import 'package:cielo_app/widgets/forecast_range_selector/forecast_range_selector.dart';
import 'package:cielo_app/widgets/hourly_forecast/hourly_forecast_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ForecastRange selectedRange = ForecastRange.next3Days;
  DateTimeRange? selectedCustomRange;
  City? selectedCity;

  late Future<Forecast> presetForecastDataFuture;
  late Future<Forecast> forecastDataFuture;
  Forecast? presetForecastData;
  bool isShowingCustomForecastData = false;

  double getLatitude() {
    return selectedCity?.latitude ?? OpenMeteoApi.defaultLatitude;
  }

  double getLongitude() {
    return selectedCity?.longitude ?? OpenMeteoApi.defaultLongitude;
  }

  Future<Forecast> fetchDefaultForecastData() {
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

  Future<Forecast> fetchCustomRangeForecastData(DateTimeRange range) {
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

  Widget buildForecastSection({
    required Future<Forecast> future,
    required Widget Function(Forecast forecast) builder,
  }) {
    return FutureBuilder<Forecast>(
      future: future,
      builder: (context, snapshot) {
        final textTheme = Theme.of(context).textTheme;

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

        return builder(forecastData);
      },
    );
  }

  Widget buildCurrentWeatherCard(bool isPhoneLayout) {
    return buildForecastSection(
      future: presetForecastDataFuture,
      // initialData: presetForecastData,
      builder: (forecastData) {
        return CurrentWeatherCard(
          selectedCity: selectedCity,
          currentWeatherData: forecastData.currentWeatherData,
          timeZoneAbbreviation: forecastData.timezoneAbbreviation,
          shouldStackGrid: isPhoneLayout,
        );
      },
    );
  }

  Widget buildForecastRangeSelector(bool isPhoneLayout) {
    return ForecastRangeSelector(
      selectedRange: selectedRange,
      selectedCustomRange: selectedCustomRange,
      shouldStackRangePicker: isPhoneLayout,
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

  Widget buildHourlyForecastCard(bool isPhoneLayout) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        buildForecastSection(
          future: forecastDataFuture,
          // initialData: presetForecastData,
          builder: (forecastData) {
            return HourlyForecastCard(
              selectedRange: selectedRange,
              selectedCustomRange: selectedCustomRange,
              selectedCity: selectedCity,
              hourlyWeatherData: forecastData.hourlyWeatherData,
              isPhoneLayout: isPhoneLayout,
            );
          },
        ),
      ],
    );
  }

  Widget buildDailyWeatherList(
    double dailyWeatherListWidth,
    bool isPhoneLayout,
  ) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Prévisions journalières',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: isPhoneLayout ? .center : .start,
          ),
        ),
        buildForecastSection(
          future: forecastDataFuture,
          // initialData: presetForecastData,
          builder: (forecastData) {
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

    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableAppBarWidth =
        screenWidth.clamp(0.0, widgetWidth) - (homePadding * 2);
    final phoneBreakpoint = 650;

    final isPhoneLayout = availableAppBarWidth < phoneBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: CieloAppBar(
        maxContentWidth: widgetWidth,
        padding: homePadding,
        shouldStackSearchBar: isPhoneLayout,
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

          return ListView(
            padding: const EdgeInsets.all(homePadding),
            children: [
              Center(
                child: SizedBox(
                  width: contentWidth - homePadding * 2,
                  child: Column(
                    spacing: homePadding,
                    children: [
                      buildCurrentWeatherCard(isPhoneLayout),
                      buildForecastRangeSelector(isPhoneLayout),
                      buildHourlyForecastCard(isPhoneLayout),
                      buildDailyWeatherList(
                        widgetWidth - homePadding * 2,
                        isPhoneLayout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
