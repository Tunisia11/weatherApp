import 'package:equatable/equatable.dart';
import 'package:weather_app/models/settings.dart';


abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;
  
  const SettingsLoaded(this.settings);
  
  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;
  
  const SettingsError(this.message);
  
  @override
  List<Object> get props => [message];
}