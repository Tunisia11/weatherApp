// lib/cubit/settings/settings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/cubit/settings/states.dart';
import 'package:weather_app/models/settings.dart';
import 'dart:convert';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      emit(SettingsLoading());
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('settings');
      
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson);
        final settings = SettingsModel.fromMap(settingsMap);
        emit(SettingsLoaded(settings));
      } else {
        final defaultSettings = SettingsModel.defaultSettings();
        emit(SettingsLoaded(defaultSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  Future<void> updateLanguage(String language) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(language: language);
        await _saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to update language: $e'));
    }
  }

  Future<void> toggleDarkTheme(bool value) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(darkTheme: value);
        await _saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to toggle dark theme: $e'));
    }
  }

  Future<void> toggleAlerts(bool value) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(enableAlerts: value);
        await _saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to toggle alerts: $e'));
    }
  }

  Future<void> toggleNotifications(bool value) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(enableNotifications: value);
        await _saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to toggle notifications: $e'));
    }
  }

  Future<void> _saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = json.encode(settings.toMap());
    await prefs.setString('settings', settingsJson);
  }

  Future<void> resetToDefaults() async {
    try {
      final defaultSettings = SettingsModel.defaultSettings();
      await _saveSettings(defaultSettings);
      emit(SettingsLoaded(defaultSettings));
    } catch (e) {
      emit(SettingsError('Failed to reset settings: $e'));
    }
  }
}