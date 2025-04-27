import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/services/weather_service.dart';

part 'searchState.dart';

class SearchCubit extends Cubit<SearchState> {
  final WeatherService _weatherService;
  final List<Location> _recentSearches = [];

  SearchCubit(this._weatherService) : super(SearchInitial());

  /// Fetch weather by city name
  Future<void> fetchWeatherByCity(String cityName) async {
    emit(SearchLoading());
    try {
      final data = await _weatherService.getCurrentAndForecast(cityName: cityName);
      final weatherResponse = WeatherResponse.fromJson(data);
      emit(SearchWeatherLoaded(weatherResponse));
    } catch (e) {
      emit(SearchError('Failed to fetch weather for $cityName: ${e.toString()}'));
    }
  }

  /// Search for city suggestions
  Future<void> searchCity(String query) async {
    if (query.length < 3) return;

    emit(SearchLoading());
    try {
      final suggestions = await _weatherService.getLocationSuggestions(query);
      final validSuggestions = suggestions.where((loc) =>
          loc.name.isNotEmpty && loc.country.isNotEmpty).toList();

      if (validSuggestions.isEmpty) {
        emit(SearchError('No matching locations found'));
        return;
      }

      emit(SearchSuccess(validSuggestions));
      _addToRecentSearches(validSuggestions.first);
    } catch (e) {
      emit(SearchError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Add a location to recent searches
  void _addToRecentSearches(Location location) {
    if (_recentSearches.length >= 5) _recentSearches.removeLast();
    _recentSearches.insert(0, location);
  }

  /// Get recent searches
  List<Location> getRecentSearches() {
    return _recentSearches;
  }
}