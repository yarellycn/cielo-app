class DailyWeather {
  final DateTime date;
  final int minTemperature;
  final int maxTemperature;
  final int minApparentTemperature;
  final int maxApparentTemperature;
  final int meanRelativeHumidity;
  final int maxWindSpeed;
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
      date: DateTime.parse(json['time'] as String),
      minTemperature: (json['temperature_2m_min'] as num).round(),
      maxTemperature: (json['temperature_2m_max'] as num).round(),
      minApparentTemperature: (json['apparent_temperature_min'] as num)
          .round(),
      maxApparentTemperature: (json['apparent_temperature_max'] as num)
          .round(),
      meanRelativeHumidity: (json['relative_humidity_2m_mean'] as num).toInt(),
      maxWindSpeed: (json['wind_speed_10m_max'] as num).round(),
      precipitationSum: (json['precipitation_sum'] as num).toDouble(),
      meanCloudCover: (json['cloud_cover_mean'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}
