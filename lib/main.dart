import 'package:cielo_app/widgets/cielo_app_bar.dart';
import 'package:cielo_app/widgets/current_weather_card.dart';
import 'package:flutter/material.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 29, 101, 195),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CieloAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: const [
          Center(child: CurrentWeatherCard()),
          // Center(child: CurrentWeatherCard()),
        ],
      ),
    );
  }
}
