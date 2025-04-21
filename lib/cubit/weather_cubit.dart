// lib/cubit/weather_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _service;

  WeatherCubit(this._service) : super(WeatherInitial());

  /// 1️⃣ Fetch by GPS
  Future<void> fetchByLocation() async {
    emit(WeatherLoading());
    try {
      final pos = await _determinePosition();
      await _loadWeather(lat: pos.latitude, lon: pos.longitude);
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  /// 2️⃣ Search by city name
  Future<void> searchByCity(String cityName) async {
    emit(WeatherLoading());
    try {
      await _loadWeather(cityName: cityName);
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  /// Shared loader for current + forecast
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

    final city = data['location']['name'] as String;
    final current = data['current'];
    final temp = (current['temp_c'] as num).toDouble();
    final cond = current['condition']['text'] as String;

    final days = _service.parseForecastDays(data);

    emit(WeatherLoaded(
      city: city,
      currentTemp: temp,
      currentCondition: cond,
      forecastDays: days,
    ));
  }

  /// 3️⃣ Select a different day from the 7‑day forecast
  void selectDay(int index) {
    final s = state;
    if (s is WeatherLoaded && index >= 0 && index < s.forecastDays.length) {
      emit(s.copyWith(selectedDayIndex: index));
    }
  }

  /// Permission + GPS helper
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
