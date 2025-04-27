import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/ui/errorView.dart';
import 'package:weather_app/ui/initalViewScreen.dart';
import 'package:weather_app/ui/widgets/weatherDashbord.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242834),
      body: SafeArea(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return const InitialView();
            } else if (state is WeatherLoading) {
              return const LoadingView();
            } else if (state is WeatherLoaded) {
              return WeatherDashboard(
                city: state.city,
                temperature: state.currentTemp,
                condition: state.currentCondition,
              );
            } else if (state is WeatherError) {
              return ErrorView(message: state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}






class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
          "assets/loading.json",
          width: 300,
          height: 300,
          fit: BoxFit.fill,
          repeat: true,
          frameRate: FrameRate.max,
          )
      );
  }
}

