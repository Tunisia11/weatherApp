import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/pupularLocation/popular_locations_cubit.dart';


class LocationCard extends StatelessWidget {
  final LocationWeather weather;

  const LocationCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: _getGradient(weather.temp),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "${weather.temp.round()}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "C",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  weather.city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  weather.country,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                _getWeatherIcon(weather.condition),
                color: _getWeatherColor(weather.condition),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Add these methods inside the LocationCard class
IconData _getWeatherIcon(String condition) {
  final lc = condition.toLowerCase();
  if (lc.contains('rain')) return Icons.umbrella;
  if (lc.contains('cloud')) return Icons.cloud;
  if (lc.contains('sun') || lc.contains('clear')) return Icons.wb_sunny;
  if (lc.contains('storm') || lc.contains('thunder')) return Icons.electric_bolt;
  if (lc.contains('snow')) return Icons.ac_unit;
  return Icons.thermostat;
}

Color _getWeatherColor(String condition) {
  final lc = condition.toLowerCase();
  if (lc.contains('rain') || lc.contains('storm')) return const Color(0xFF4287f5);
  if (lc.contains('cloud')) return const Color(0xFFa6b1c0);
  if (lc.contains('sun') || lc.contains('clear')) return const Color(0xFFFFC107);
  if (lc.contains('snow')) return const Color(0xFFd1e6ff);
  if (lc.contains('fog') || lc.contains('mist')) return const Color(0xFFc9c9c9);
  return const Color(0xFF8bc9ff);
}

LinearGradient _getGradient(double temp) {
  if (temp > 30) {
    return const LinearGradient(
      colors: [Color(0xFF2A303D), Color(0xFF453232)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (temp > 20) {
    return const LinearGradient(
      colors: [Color(0xFF2A303D), Color(0xFF353D46)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (temp < 5) {
    return const LinearGradient(
      colors: [Color(0xFF2A303D), Color(0xFF2A3645)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  return const LinearGradient(
    colors: [Color(0xFF2A303D), Color(0xFF2A303D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

  // Add _getWeatherIcon, _getWeatherColor, and _getGradient methods from original code
}