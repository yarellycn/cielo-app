class City {
  final String name;
  final double latitude;
  final double longitude;
  final int population;
  final String country;
  final String admin1;

  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.population,
    required this.country,
    required this.admin1,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: (json['name'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      population: (json['population'] as num?)?.toInt() ?? 0,
      country: (json['country'] as String?) ?? '',
      admin1: (json['admin1'] as String?) ?? '',
    );
  }
}
