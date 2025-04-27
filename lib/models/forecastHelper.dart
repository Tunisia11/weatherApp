import 'package:weather_app/models/forecast.dart';

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({
    required this.forecastday,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var forecastDayList = json['forecastday'] as List;
    List<ForecastDay> forecastDays = forecastDayList
        .map((forecastDayJson) => ForecastDay.fromJson(forecastDayJson))
        .toList();

    return Forecast(
      forecastday: forecastDays,
    );
  }
}