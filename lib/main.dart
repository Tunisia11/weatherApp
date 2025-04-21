import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'cubit/weather_cubit.dart';
import 'services/weather_service.dart';
import 'ui/home_screen.dart';
import 'app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  final dio = Dio();
  final weatherService = WeatherService(dio, 'a403e8daa80245a68da201141221512');

  runApp(MyApp(weatherService: weatherService));
}

class MyApp extends StatelessWidget {
  final WeatherService weatherService;

  const MyApp({super.key, required this.weatherService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: BlocProvider(
        create: (_) => WeatherCubit(weatherService)..fetchByLocation(),
        child: const HomeScreen(),
      ),
    );
  }
}
