import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_response.dart';

import '../services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _service;

  WeatherCubit(this._service) : super(WeatherInitial());

  /// Fetch weather by GPS
  Future<void> fetchByLocation() async {
    emit(WeatherLoading());
    try {
      final pos = await _determinePosition();
      await _loadWeather(lat: pos.latitude, lon: pos.longitude);
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  
  /// Load weather data
  Future<void> _loadWeather({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    final data = await _service.getCurrentAndForecast(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );

    final weatherResponse = WeatherResponse.fromJson(data);

    emit(WeatherLoaded(
      weatherResponse: weatherResponse,
      city: weatherResponse.location.name,
      currentTemp: weatherResponse.current.tempC,
      currentCondition: weatherResponse.current.condition.text,
      country: weatherResponse.location.country,
      localTime: weatherResponse.location.localtime,
      forecastDays: _service.parseForecastDays(data),
      currentWeather: weatherResponse.current,
      selectedDayIndex: 0, // Add default selected day index
    ));
  }

  /// Select a different day from the 7‑day forecast
  void selectDay(int index) {
    final s = state;
    if (s is WeatherLoaded && index >= 0 && index < s.forecastDays.length) {
      emit(s.copyWith(selectedDayIndex: index));
    }
  }

  /// Helper to determine GPS position
  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw Exception('Permission permanently denied; enable in settings.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}