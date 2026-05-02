import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/cielo_app_bar.dart';
import 'package:cielo_app/widgets/current_weather_card.dart';
import 'package:cielo_app/widgets/daily_forecast_list.dart';
import 'package:cielo_app/widgets/forecast_range_selector.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: CieloAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Center(child: CurrentWeatherCard()),
          Center(
            child: ForecastRangeSelector(
              selectedRange: selectedRange,
              selectedCustomRange: selectedCustomRange,
              onRangeSelected: (range) {
                setState(() {
                  selectedRange = range;
                });
              },
              onCustomSelectedRange: (range) {
                setState(() {
                  selectedRange = ForecastRange.custom;
                  selectedCustomRange = range;
                });
              },
            ),
          ),
          Text(
            'Prévisons journalières',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          DailyForecastList(
            selectedRange: selectedRange,
            selectedCustomRange: selectedCustomRange,
          ),
        ],
      ),
    );
  }
}
