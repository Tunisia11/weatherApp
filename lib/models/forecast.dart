// lib/models/forecast_day.dart

class ForecastDay {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final day = json['day'];
    return ForecastDay(
      date: DateTime.parse(json['date']),
      maxTemp: (day['maxtemp_c'] as num).toDouble(),
      minTemp: (day['mintemp_c'] as num).toDouble(),
      condition: day['condition']['text'],
      iconUrl: "https:${day['condition']['icon']}",
    );
  }
}
