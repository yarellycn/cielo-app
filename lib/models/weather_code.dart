enum WeatherCode {
  clearSky(0, 'Ciel dégagé'), // Clear sky
  mainlyClear(1, 'Principalement dégagé'), // Mainly clear
  partlyCloudy(2, 'Partiellement nuageux'), // Partly cloudy
  overcast(3, 'Couvert'), // Overcast
  fog(45, 'Brouillard'), // Fog
  rimeFog(48, 'Brouillard givrant'), // Depositing rime fog
  lightDrizzle(51, 'Bruine légère'), // Light drizzle
  moderateDrizzle(53, 'Bruine modérée'), // Moderate drizzle
  denseDrizzle(55, 'Bruine dense'), // Dense drizzle
  lightFreezingDrizzle(
    56,
    'Bruine verglaçante légère',
  ), // Light freezing drizzle
  denseFreezingDrizzle(
    57,
    'Bruine verglaçante dense',
  ), // Dense freezing drizzle
  slightRain(61, 'Pluie faible'), // Slight rain
  moderateRain(63, 'Pluie modérée'), // Moderate rain
  heavyRain(65, 'Forte pluie'), // Heavy rain
  lightFreezingRain(66, 'Pluie verglaçante légère'), // Light freezing rain
  heavyFreezingRain(67, 'Forte pluie verglaçante'), // Heavy freezing rain
  slightSnowFall(71, 'Faibles chutes de neige'), // Slight snow fall
  moderateSnowFall(73, 'Chutes de neige modérées'), // Moderate snow fall
  heavySnowFall(75, 'Fortes chutes de neige'), // Heavy snow fall
  snowGrains(77, 'Neige en grains'), // Snow grains
  slightRainShowers(80, 'Averses de pluie faibles'), // Slight rain showers
  moderateRainShowers(81, 'Averses de pluie modérées'), // Moderate rain showers
  violentRainShowers(82, 'Averses de pluie violentes'), // Violent rain showers
  slightSnowShowers(85, 'Averses de neige faibles'), // Slight snow showers
  heavySnowShowers(86, 'Fortes averses de neige'), // Heavy snow showers
  slightThunderstorm(95, 'Orage faible'), // Slight Thunderstorm
  thunderstormSlightHail(
    96,
    'Orage avec grêle faible',
  ), // Thunderstorm with slight hail
  thunderstormHeavyHail(
    99,
    'Orage avec forte grêle',
  ); // Thunderstorm with heavy hail

  const WeatherCode(this.code, this.description);
  final int code;
  final String description;

  static WeatherCode? fromCode(int code) {
    return WeatherCode.values.where((value) => value.code == code).firstOrNull;
  }
}
