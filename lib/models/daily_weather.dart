class DailyWeather {
  final DateTime date;
  final double minTemperature;
  final double maxTemperature;
  final double minApparentTemperature;
  final double maxApparentTemperature;
  final int meanRelativeHumidity;
  final double maxWindSpeed;
  final double precipitationSum;
  final int meanCloudCover;
  final int weatherCode;

  const DailyWeather({
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minApparentTemperature,
    required this.maxApparentTemperature,
    required this.meanRelativeHumidity,
    required this.maxWindSpeed,
    required this.precipitationSum,
    required this.meanCloudCover,
    required this.weatherCode,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: (json['time']) as DateTime,
      minTemperature: (json['temperature_2m_min'] as num).toDouble(),
      maxTemperature:(json['temperature_2m_max'] as num).toDouble(),
      minApparentTemperature: (json['apparent_temperature_min'] as num).toDouble(),
      maxApparentTemperature: (json['apparent_temperature_max'] as num).toDouble(),
      meanRelativeHumidity: (json['relative_humidity_2m_mean']) as int,
      maxWindSpeed: (json['wind_speed_10m_max'] as num).toDouble(),
      precipitationSum: (json['precipitation_sum'] as num).toDouble(),
      meanCloudCover: (json['cloud_cover_mean']) as int,
      weatherCode: (json['weather_code']) as int,
    );
  }
}