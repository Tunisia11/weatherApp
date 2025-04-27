import 'package:flutter/material.dart';


class DaySelectorItem extends StatelessWidget {
  final dynamic forecastDay;
  final String day;
  final bool isSelected;
  final double temperature;

  const DaySelectorItem({
    super.key,
    required this.forecastDay,
    required this.day,
    required this.isSelected,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 75,
     
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFF1968E6)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF1968E6).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Day name
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),

          // Weather icon
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                forecastDay.iconUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.cloud,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          
         
          
          // Temperature
          Text(
            "${temperature.round()}°",
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.85),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
