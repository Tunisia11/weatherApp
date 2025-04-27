class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String? ?? 'Unknown City',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? 'Unknown Country',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      tzId: json['tz_id'] as String? ?? '',
      localtime: json['localtime'] as String? ?? '',
    );
  }
}