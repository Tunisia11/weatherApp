// lib/services/weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/location.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

   Future<List<Location>> getLocationSuggestions(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$encodedQuery'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } else if (response.statusCode == 400) {
      return [];  // Return empty list for invalid queries
    } else {
      throw Exception('Failed to load suggestions: ${response.statusCode}');
    }
  }
  /// Fetches current weather + 7‑day forecast.
  Future<Map<String, dynamic>> getCurrentAndForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
   final query = cityName != null
    ? 'q=${Uri.encodeComponent(cityName)}'
    : 'q=$lat,$lon';

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&$query&days=7');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  List<ForecastDay> parseForecastDays(Map<String, dynamic> data) {
  return (data['forecast']['forecastday'] as List)
      .map((item) => ForecastDay.fromJson(item))
      .toList();
}
}
