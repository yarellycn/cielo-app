class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double windSpeed;
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
      time: (json['time']) as DateTime,
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      relativeHumidity: (json['relative_humidity_2m']) as int,
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      cloudCover: (json['cloud_cover']) as int,
      weatherCode: (json['weather_code']) as int,
    );
  }
}