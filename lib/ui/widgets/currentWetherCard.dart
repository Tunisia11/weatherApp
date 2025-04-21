import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final String condition;

  const CurrentWeatherCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.condition,
  });

  IconData get _weatherIcon {
    final lc = condition.toLowerCase();
    if (lc.contains('rain')) return Icons.grain;
    if (lc.contains('cloud')) return Icons.cloud;
    if (lc.contains('sun') || lc.contains('clear')) return Icons.wb_sunny;
    if (lc.contains('storm') || lc.contains('thunder')) return Icons.flash_on;
    if (lc.contains('snow')) return Icons.ac_unit;
    return Icons.help_outline;
  }

  Color get _iconColor {
    final lc = condition.toLowerCase();
    if (lc.contains('rain')) return Colors.blueAccent;
    if (lc.contains('cloud')) return Colors.grey;
    if (lc.contains('sun') || lc.contains('clear')) return Colors.orangeAccent;
    if (lc.contains('storm') || lc.contains('thunder')) return Colors.deepPurpleAccent;
    if (lc.contains('snow')) return Colors.lightBlueAccent;
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A303D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Left info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      city,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${temperature.round()}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  condition,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),

          // Right icon
          Icon(
            _weatherIcon,
            color: _iconColor,
            size: 60,
          ),
        ],
      ),
    );
  }
}
