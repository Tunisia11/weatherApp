import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';

import 'package:intl/intl.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/ui/widgets/currentWetherCard.dart';
import 'package:weather_app/ui/widgets/daySector.dart';
import 'package:weather_app/ui/widgets/hader.dart';
import 'package:weather_app/ui/widgets/popular.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key, required String city, required double temperature, required String condition}) : super(key: key);

  @override
  _WeatherDashboardState createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().fetchByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WeatherError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<WeatherCubit>().fetchByLocation(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is WeatherLoaded) {
          // Build list of short day names
          final days = state.forecastDays
              .map((d) => DateFormat.E().format(d.date))
              .toList();
          final idx = state.selectedDayIndex;
          // Determine display values for selected day
          double displayTemp;
          String displayCondition;
          if (idx == 0) {
            displayTemp = state.currentTemp;
            displayCondition = state.currentCondition;
          } else {
            final ForecastDay day = state.forecastDays[idx];
            displayTemp = day.maxTemp;
            displayCondition = day.condition;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(username: "Maram"),
                const SizedBox(height: 20),
                SearchBar(
                  onSubmitted: (query) =>
                      context.read<WeatherCubit>().searchByCity(query),
                ),
                const SizedBox(height: 20),
                CurrentWeatherCard(
                  city: state.city,
                  temperature: displayTemp,
                  condition: displayCondition,
                ),
                const SizedBox(height: 20),
                DaySelector(
                  days: days,
                  selectedIndex: idx,
                  onDayTap: (i) => context.read<WeatherCubit>().selectDay(i),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Popular Locations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const PopularLocationsGrid(),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<WeatherCubit>().fetchByLocation(),
            child: const Text('Load Weather'),
          ),
        );
      },
    );
  }
}
