import 'package:flutter/material.dart';

import 'package:weather_app/ui/widgets/daysectorItem.dart';

typedef DayTapCallback = void Function(int index);

class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final DayTapCallback onDayTap;

  const DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A303D),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(days.length, (i) {
          return GestureDetector(
            onTap: () => onDayTap(i),
            child: DaySelectorItem(
              day: days[i],
              isSelected: i == selectedIndex,
            ),
          );
        }),
      ),
    );
  }
}
