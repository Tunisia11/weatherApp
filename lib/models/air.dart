class AirQuality {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm25;
  final double pm10;
  final int usEpaIndex;
  final int gbDefraIndex;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm25,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: json['co']?.toDouble() ?? 0.0,
      no2: json['no2']?.toDouble() ?? 0.0,
      o3: json['o3']?.toDouble() ?? 0.0,
      so2: json['so2']?.toDouble() ?? 0.0,
      pm25: json['pm2_5']?.toDouble() ?? 0.0,
      pm10: json['pm10']?.toDouble() ?? 0.0,
      usEpaIndex: json['us-epa-index'] ?? 1,
      gbDefraIndex: json['gb-defra-index'] ?? 1,
    );
  }
}