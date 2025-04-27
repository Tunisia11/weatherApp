import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/cubit/pupularLocation/popular_locations_cubit.dart';
import 'package:weather_app/cubit/search/searchCubit.dart';
import 'package:weather_app/cubit/settings/cubit.dart';
import 'package:weather_app/cubit/settings/states.dart';
import 'package:weather_app/services/theme.dart';
import 'package:weather_app/ui/screens/settings.dart';
import 'cubit/weather_cubit.dart';
import 'services/weather_service.dart';
import 'ui/home_screen.dart';
import 'app_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  final dio = Dio();
  final weatherService = WeatherService("a403e8daa80245a68da201141221512");

  runApp(MyApp(weatherService: weatherService));
}

class MyApp extends StatelessWidget {
  final WeatherService weatherService;

  const MyApp({super.key, required this.weatherService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(
          create: (context) => WeatherCubit(weatherService)..fetchByLocation(),
        ),
        BlocProvider<PopularLocationsCubit>(
          create: (context) => PopularLocationsCubit(weatherService),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(weatherService),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          // Get theme based on current settings state
          final isDarkMode = state is SettingsLoaded ? state.settings.darkTheme : false;
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: ThemeService.getLightTheme(),
            darkTheme: ThemeService.getDarkTheme(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}