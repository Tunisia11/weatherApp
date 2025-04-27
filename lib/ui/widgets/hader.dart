
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/ui/screens/searchScreen.dart';
import 'package:weather_app/ui/screens/settings.dart';

class Header extends StatelessWidget {
  final String countryName;
  final String cityName;
  final WeatherResponse? weatherResponse;

  const Header({
    super.key, 
    required this.countryName, 
    required this.cityName, 
    this.weatherResponse
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cityName,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              countryName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7), 
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
         onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<WeatherCubit>(context), // Pass existing cubit
        child: const SearchScreen(),
      ),
    ),
  );
},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          },
        ),
      ],
    );
  }
}
