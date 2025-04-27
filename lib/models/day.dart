import 'package:weather_app/models/condition.dart';

class Day {
  final double maxtempC;
  final double maxtempF;
  final double mintempC;
  final double mintempF;
  final double avgtempC;
  final double avgtempF;
  final double maxwindMph;
  final double maxwindKph;
  final double totalprecipMm;
  final double totalprecipIn;
  final double totalsnowCm;
  final double avgvisKm;
  final double avgvisMiles;
  final double avghumidity;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final Condition condition;
  final double uv;

  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toDouble(),
      maxtempF: json['maxtemp_f'].toDouble(),
      mintempC: json['mintemp_c'].toDouble(),
      mintempF: json['mintemp_f'].toDouble(),
      avgtempC: json['avgtemp_c'].toDouble(),
      avgtempF: json['avgtemp_f'].toDouble(),
      maxwindMph: json['maxwind_mph'].toDouble(),
      maxwindKph: json['maxwind_kph'].toDouble(),
      totalprecipMm: json['totalprecip_mm'].toDouble(),
      totalprecipIn: json['totalprecip_in'].toDouble(),
      totalsnowCm: json['totalsnow_cm'].toDouble(),
      avgvisKm: json['avgvis_km'].toDouble(),
      avgvisMiles: json['avgvis_miles'].toDouble(),
      avghumidity: json['avghumidity'].toDouble(),
      dailyWillItRain: json['daily_will_it_rain'],
      dailyChanceOfRain: json['daily_chance_of_rain'],
      dailyWillItSnow: json['daily_will_it_snow'],
      dailyChanceOfSnow: json['daily_chance_of_snow'],
      condition: Condition.fromJson(json['condition']),
      uv: json['uv'].toDouble(),
    );
  }
}
