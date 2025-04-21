import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String city;
  final String country;
  final int temperature;
  final String condition;
  final IconData icon;

  const LocationCard({
    super.key,
    required this.city,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Weather-specific colors based on condition
    Color getWeatherColor() {
      if (condition.toLowerCase().contains('rain') || 
          condition.toLowerCase().contains('storm')) {
        return const Color(0xFF4287f5); // Blue for rain/storm
      } else if (condition.toLowerCase().contains('cloud')) {
        return const Color(0xFFa6b1c0); // Gray for cloudy
      } else if (condition.toLowerCase().contains('sun') || 
                condition.toLowerCase().contains('clear')) {
        return const Color(0xFFFFC107); // Yellow/amber for sun
      } else if (condition.toLowerCase().contains('snow')) {
        return const Color(0xFFd1e6ff); // Light blue for snow
      } else if (condition.toLowerCase().contains('fog') || 
                condition.toLowerCase().contains('mist')) {
        return const Color(0xFFc9c9c9); // Gray for fog/mist
      } else if (condition.toLowerCase().contains('wind')) {
        return const Color(0xFF9dc6ff); // Light blue for windy
      }
      return const Color(0xFF8bc9ff); // Default light blue
    }

    // Get card gradient colors based on temperature
    List<Color> getTemperatureGradient() {
      if (temperature > 30) {
        // Hot
        return [const Color(0xFF2A303D), const Color(0xFF453232)];
      } else if (temperature > 20) {
        // Warm
        return [const Color(0xFF2A303D), const Color(0xFF353D46)];
      } else if (temperature < 5) {
        // Cold
        return [const Color(0xFF2A303D), const Color(0xFF2A3645)];
      }
      // Default
      return [const Color(0xFF2A303D), const Color(0xFF2A303D)];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: getTemperatureGradient(),
        ),
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
                      "$temperature°",
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
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  country,
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
                icon,
                color: getWeatherColor(),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}