import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/pupularLocation/popular_locations_cubit.dart';

import 'locationCard.dart';

class PopularLocationsGrid extends StatelessWidget {
  const PopularLocationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularLocationsCubit, PopularLocationsState>(
      builder: (context, state) {
        if (state is PopularLocationsLoaded) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.25,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: state.locations
                .map((location) => LocationCard(weather: location))
                .toList(),
          );
        }
        if (state is PopularLocationsError) {
          return Text('Error: ${state.message}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}