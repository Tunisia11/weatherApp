import 'package:flutter/material.dart';
import 'package:weather_app/ui/widgets/locationCard.dart';

class PopularLocationsGrid extends StatelessWidget {
  const PopularLocationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: const [
        LocationCard(
          city: "Paris",
          country: "France",
          temperature: 18,
          condition: "Rainy",
          icon: Icons.water_drop,
        ),
        LocationCard(
          city: "Madrid",
          country: "Spain",
          temperature: 24,
          condition: "Partly Sunny",
          icon: Icons.cloud,
        ),
        LocationCard(
          city: "Rome",
          country: "Italy",
          temperature: 21,
          condition: "Sunny",
          icon: Icons.wb_sunny,
        ),
        LocationCard(
          city: "Rio Brazi",
          country: "Brazil",
          temperature: 28,
          condition: "Sunny",
          icon: Icons.wb_sunny,
        ),
      ],
    );
  }
}
