class CurrentWeather {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double windSpeed;
  final double precipitation;
  final int cloudCover;
  final int weatherCode;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.precipitation,
    required this.cloudCover,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      cloudCover: (json['cloud_cover'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}
