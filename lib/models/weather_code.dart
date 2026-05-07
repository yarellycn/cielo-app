enum WeatherCode {
  clearSky(0, 'Ciel dégagé', 'clear_sky.png'), // Clear sky,
  mainlyClear(1, 'Principalement dégagé', 'mainly_clear.png'), // Mainly clear
  partlyCloudy(
    2,
    'Partiellement nuageux',
    'partly_cloudy.png',
  ), // Partly cloudy
  overcast(3, 'Couvert', 'overcast.png'), // Overcast
  fog(45, 'Brouillard', 'fog.png'), // Fog
  rimeFog(48, 'Brouillard givrant', 'rime_fog.png'), // Depositing rime fog
  lightDrizzle(51, 'Bruine légère', 'light_drizzle.png'), // Light drizzle
  moderateDrizzle(
    53,
    'Bruine modérée',
    'moderate_drizzle.png',
  ), // Moderate drizzle
  denseDrizzle(55, 'Bruine dense', 'dense_drizzle.png'), // Dense drizzle
  lightFreezingDrizzle(
    56,
    'Bruine verglaçante légère',
    'light_freezing_drizzle.png',
  ), // Light freezing drizzle
  denseFreezingDrizzle(
    57,
    'Bruine verglaçante dense',
    'dense_freezing_drizzle.png',
  ), // Dense freezing drizzle
  slightRain(61, 'Pluie faible', 'slight_rain.png'), // Slight rain
  moderateRain(63, 'Pluie modérée', 'moderate_rain.png'), // Moderate rain
  heavyRain(65, 'Forte pluie', 'heavy_rain.png'), // Heavy rain
  lightFreezingRain(
    66,
    'Pluie verglaçante légère',
    'light_freezing_rain.png',
  ), // Light freezing rain
  heavyFreezingRain(
    67,
    'Forte pluie verglaçante',
    'heavy_freezing_rain.png',
  ), // Heavy freezing rain
  slightSnowFall(
    71,
    'Faibles chutes de neige',
    'slight_snowfall.png',
  ), // Slight snow fall
  moderateSnowFall(
    73,
    'Chutes de neige modérées',
    'moderate_snowfall.png',
  ), // Moderate snow fall
  heavySnowFall(
    75,
    'Fortes chutes de neige',
    'heavy_snowfall.png',
  ), // Heavy snow fall
  snowGrains(77, 'Neige en grains', 'snow_grains.png'), // Snow grains
  slightRainShowers(
    80,
    'Averses de pluie faibles',
    'slight_rain_showers.png',
  ), // Slight rain showers
  moderateRainShowers(
    81,
    'Averses de pluie modérées',
    'moderate_rain_showers.png',
  ), // Moderate rain showers
  violentRainShowers(
    82,
    'Averses de pluie violentes',
    'violent_rain_showers.png',
  ), // Violent rain showers
  slightSnowShowers(
    85,
    'Averses de neige faibles',
    'slight_snow_showers.png',
  ), // Slight snow showers
  heavySnowShowers(
    86,
    'Fortes averses de neige',
    'heavy_snow_showers.png',
  ), // Heavy snow showers
  slightThunderstorm(
    95,
    'Orage faible',
    'slight_thunderstorm.png',
  ), // Slight Thunderstorm
  thunderstormSlightHail(
    96,
    'Orage avec grêle faible',
    'thunderstorm_slight_hail.png',
  ), // Thunderstorm with slight hail
  thunderstormHeavyHail(
    99,
    'Orage avec forte grêle',
    'thunderstorm_heavy_hail.png',
  ); // Thunderstorm with heavy hail

  static const iconsLocation = 'assets/weather/';

  const WeatherCode(this.code, this.description, this.iconFileName);
  final int code;
  final String description;
  final String iconFileName;

  String get iconAsset => '$iconsLocation$iconFileName';

  static WeatherCode? fromCode(int code) {
    return WeatherCode.values.where((value) => value.code == code).firstOrNull;
  }
}
