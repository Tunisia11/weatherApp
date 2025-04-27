// lib/cubit/weather_state.dart

import 'package:equatable/equatable.dart';
import 'package:weather_app/models/currentWether.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather_response.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String city;
  final double currentTemp;
  final String currentCondition;
  final String country;
  final String localTime;
  final List<ForecastDay> forecastDays; // Update from List<dynamic>
  final Current currentWeather;
  final int selectedDayIndex;
  final WeatherResponse weatherResponse;

  WeatherLoaded({
  required this.weatherResponse,
  required this.city,
  required this.currentTemp,
  required this.currentCondition,
  required this.country,
  required this.localTime,
  required this.forecastDays, // Update type here
  required this.currentWeather,
  this.selectedDayIndex = 0,
});

  WeatherLoaded copyWith({int? selectedDayIndex}) {
    return WeatherLoaded(
      weatherResponse: weatherResponse,
      city: city,
      currentTemp: currentTemp,
      currentCondition: currentCondition,
      country: country,
      localTime: localTime,
      forecastDays: forecastDays,
      currentWeather: currentWeather,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }

  @override
  List<Object?> get props => [
        city,
        currentTemp,
        currentCondition,
        country,
        localTime,
        forecastDays,
        currentWeather,
        selectedDayIndex,
      ];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object?> get props => [message];
}
