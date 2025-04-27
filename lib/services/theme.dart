// lib/services/theme_service.dart
import 'package:flutter/material.dart';

class ThemeService {
  static ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.lightBlue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
      ),
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey[800],
      colorScheme: ColorScheme.dark(
        primary: Colors.blueGrey[800]!,
        secondary: Colors.tealAccent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.blueGrey[900],
      cardTheme: CardTheme(
        color: Colors.blueGrey[800],
        elevation: 4,
      ),
      iconTheme: IconThemeData(
        color: Colors.tealAccent[400],
      ),
    );
  }
}