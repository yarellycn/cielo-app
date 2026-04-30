class HourlyWeather {
  final DateTime time;
  final int temperature;
  final int apparentTemperature;
  final int relativeHumidity;
  final int windSpeed;
  final double precipitation;
  final int cloudCover;
  final int weatherCode;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.precipitation,
    required this.cloudCover,
    required this.weatherCode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature_2m'] as num).round(),
      apparentTemperature: (json['apparent_temperature'] as num).round(),
      relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).round(),
      precipitation: (json['precipitation'] as num).toDouble(),
      cloudCover: (json['cloud_cover'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}
