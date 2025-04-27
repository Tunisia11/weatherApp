import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/services/weather_service.dart';


class PopularLocationsCubit extends Cubit<PopularLocationsState> {
  final WeatherService _weatherService;
  final List<String> _cities = const ['Paris', 'Madrid', 'Rome', 'Rio de Janeiro'];

  PopularLocationsCubit(this._weatherService) : super(PopularLocationsLoading()) {
    loadPopularLocations();
  }

  Future<void> loadPopularLocations() async {
    try {
      final locations = await Future.wait(
        _cities.map((city) => _fetchCityData(city))
      );
      emit(PopularLocationsLoaded(locations));
    } catch (e) {
      emit(PopularLocationsError(e.toString()));
    }
  }

  Future<LocationWeather> _fetchCityData(String city) async {
    final data = await _weatherService.getCurrentAndForecast(cityName: city);
    return LocationWeather(
      city: data['location']['name'],
      country: data['location']['country'],
      temp: (data['current']['temp_c'] as num).toDouble(),
      condition: data['current']['condition']['text'],
    );
  }
}

abstract class PopularLocationsState {}
class PopularLocationsLoading extends PopularLocationsState {}
class PopularLocationsLoaded extends PopularLocationsState {
  final List<LocationWeather> locations;
  PopularLocationsLoaded(this.locations);
}
class PopularLocationsError extends PopularLocationsState {
  final String message;
  PopularLocationsError(this.message);
}

class LocationWeather {
  final String city;
  final String country;
  final double temp;
  final String condition;

  LocationWeather({
    required this.city,
    required this.country,
    required this.temp,
    required this.condition,
  });
}