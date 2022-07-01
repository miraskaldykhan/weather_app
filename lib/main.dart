import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/api/weather_api_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/locations/locations_cubit.dart';
import 'package:weather_app/cubit/weather_daily/weather_daily_cubit.dart';
import 'screens/homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WeatherApiRepository weatherApiRepository = WeatherApiRepository();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
        providers: [
          BlocProvider<WeatherDailyCubit>(
            create: (context) =>
                WeatherDailyCubit(weatherApiRepository: weatherApiRepository),
          ),
          BlocProvider<LocationsListCubit>(
            create: (context) =>
                LocationsListCubit(weatherApiRepository: weatherApiRepository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Weather App by Miras Kaldykhan",
          home: HomePage(),
        ));
  }
}
