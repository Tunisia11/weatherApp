import 'package:flutter/material.dart';
import 'package:weather_app/models/currentWether.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/ui/widgets/animations/clloudsAimation.dart';
import 'package:weather_app/ui/widgets/animations/rainAimation.dart';
import 'package:weather_app/ui/widgets/animations/snowAnimations.dart';
import 'package:weather_app/ui/widgets/animations/stormAnimations.dart';
import 'package:weather_app/ui/widgets/animations/sunAnimation.dart';

class CurrentWeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final String condition;
  final Current currentWeather;
  
  const CurrentWeatherCard({
    super.key,
    required this.currentWeather,
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

  String get _weatherCondition {
    final lc = condition.toLowerCase();
    if (lc.contains('rain')) return 'rain';
    if (lc.contains('cloud')) return 'cloudy';
    if (lc.contains('sun') || lc.contains('clear')) return 'sunny';
    if (lc.contains('storm') || lc.contains('thunder')) return 'storm';
    if (lc.contains('snow')) return 'snow';
    return 'default';
  }

  Color get _cardBaseColor {
    switch (_weatherCondition) {
      case 'rain':
        return const Color(0xFF1E2533);
      case 'cloudy':
        return const Color(0xFF2D3240);
      case 'sunny':
        return const Color(0xFF2A3045);
      case 'storm':
        return const Color(0xFF1A1F2E);
      case 'snow':
        return const Color(0xFF2C3548);
      default:
        return const Color(0xFF2A303D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          // Background animation + gradient
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _cardBaseColor,
                          _cardBaseColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  _buildWeatherAnimation(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildTempAndCondition(),
                const Spacer(),
                _buildDetailsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildTempAndCondition() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${temperature.round()}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 70,
              fontWeight: FontWeight.bold,
              height: 0.9,
              shadows: [Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Color.fromARGB(100, 0, 0, 0),
              )],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                condition,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Feels like ${currentWeather.feelslikeC?.round() ?? temperature.round()}°",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ],
      );

  Widget _buildDetailsRow() => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherDetailItem(
              Icons.water_drop_outlined,
              "${currentWeather.humidity?.round() ?? 0}%",
              "Humidity",
            ),
            _buildWeatherDetailItem(
              Icons.air,
              "${currentWeather.windKph?.round() ?? 0} km/h",
              "Wind",
            ),
            _buildWeatherDetailItem(
              Icons.visibility_outlined,
              "${currentWeather.windKph?.toStringAsFixed(1) ?? 0} km",
              "Visibility",
            ),
          ],
        ),
  );

  Widget _buildWeatherDetailItem(IconData icon, String value, String label) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        ],
      );

  Widget _buildWeatherAnimation() {
    switch (_weatherCondition) {
      case 'rain':
        return const RainAnimation();
      case 'cloudy':
        return const CloudAnimation();
      case 'sunny':
        return const SunAnimation();
      case 'storm':
        return const StormAnimation();
      case 'snow':
        return const SnowAnimation();
      default:
        return Container();
    }
  }
}
