enum WeatherCode {
  clearSky(0, 'Clear sky'),
  mainlyClear(1, 'Mainly clear'),
  partlyCloudy(2, 'Partly cloudy'),
  overcast(3, 'Overcast'),
  fog(45, 'Fog'),
  rimeFog(48, 'Depositing rime fog'),
  lightDrizzle(51, 'Light drizzle'),
  moderateDrizzle(53, 'Moderate drizzle'),
  denseDrizzle(55, 'Dense drizzle'),
  lightFreezingDrizzle(56, 'Light freezing drizzle'),
  denseFreezingDrizzle(57, 'Dense freezing drizzle'),
  slightRain(61, 'Slight rain'),
  moderateRain(63, 'Moderate rain'),
  heavyRain(65, 'Heavy rain'),
  lightFreezingRain(66, 'Light freezing rain'),
  heavyFreezingRain(67, 'Heavy freezing rain'),
  slightSnowFall(71, 'Slight snow fall'),
  moderateSnowFall(73, 'Moderate snow fall'),
  heavySnowFall(75, 'Heavy snow fall'),
  snowGrains(77, 'Snow grains'),
  slightRainShowers(80, 'Slight rain showers'),
  moderateRainShowers(81, 'Moderate rain showers'),
  violentRainShowers(82, 'Violent rain showers'),
  slightSnowShowers(85, 'Slight snow showers'),
  heavySnowShowers(86, 'Heavy snow showers'),
  slightThunderstorm(95, 'Slight Thunderstorm'),
  thunderstormSlightHail(96, 'Thunderstorm with slight hail'),
  thunderstormHeavyHail(99, 'Thunderstorm with heavy hail');

  const WeatherCode(this.code, this.description);
  final int code;
  final String description;

  static WeatherCode? fromCode(int code) {
    return WeatherCode.values.where((value) => value.code == code).firstOrNull;
  }
}
