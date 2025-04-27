part of 'searchCubit.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Location> locations;

  SearchSuccess(this.locations);
}

class SearchWeatherLoaded extends SearchState {
  final WeatherResponse weatherResponse;

  SearchWeatherLoaded(this.weatherResponse);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}