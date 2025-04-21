// lib/services/weather_service.dart

import 'package:dio/dio.dart';
import 'package:weather_app/models/forecast.dart';


class WeatherService {
  final Dio dio;
  final String apiKey;

  WeatherService(this.dio, this.apiKey);

  /// Fetches current weather + 7‑day forecast.
  Future<Map<String, dynamic>> getCurrentAndForecast({
    double? lat,
    double? lon,
    String? cityName,
    int days = 7,
  }) async {
    final query = cityName ?? (lat != null && lon != null ? '$lat,$lon' : '');
    final response = await dio.get(
      'http://api.weatherapi.com/v1/forecast.json',
      queryParameters: {
        'key': apiKey,
        'q': query,
        'days': days,
        'aqi': 'no',
        'alerts': 'no',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather data');
    }

    return response.data;
  }

  /// Parses the forecast days out of the JSON.
  List<ForecastDay> parseForecastDays(Map<String, dynamic> json) {
    final list = json['forecast']['forecastday'] as List;
    return list.map((e) => ForecastDay.fromJson(e)).toList();
  }
}
