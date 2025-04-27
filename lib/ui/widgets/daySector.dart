
import 'package:flutter/material.dart';
import 'package:weather_app/ui/widgets/daysectorItem.dart';

class DaySelector extends StatelessWidget {
  final List forecastDays;
  final List<String> days;
  final int selectedIndex;
  final Function(int) onDayTap;

  const DaySelector({
    super.key,
    required this.forecastDays,
    required this.days,
    required this.selectedIndex,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            " Forecast",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 115,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A303D),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forecastDays.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final day = forecastDays[index];
              // Get temperature from the forecast day object
              // Adjust this based on your actual ForecastDay structure
              final temperature = day.maxTemp ?? 0.0;
              
              return GestureDetector(
                onTap: () => onDayTap(index),
                child: DaySelectorItem(
                  forecastDay: day,
                  day: days[index],
                  isSelected: index == selectedIndex,
                  temperature: temperature,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}