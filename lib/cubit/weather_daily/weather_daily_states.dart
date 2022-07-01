import 'package:weather_app/models/weather_locations.dart';

abstract class WeatherDailyState {}

class WeatherDailyInitialState extends WeatherDailyState {}

class WeatherDailyLoadingState extends WeatherDailyState {}

class WeatherDailyLoadedState extends WeatherDailyState {
  final WeatherForecastDaily forecastDaily;
  WeatherDailyLoadedState(this.forecastDaily);
}

class WeatherDailyErrorState extends WeatherDailyState {
  final String message;
  WeatherDailyErrorState(this.message);
}
