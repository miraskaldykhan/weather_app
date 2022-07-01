import 'package:dio/dio.dart';
import 'package:weather_app/cubit/weather_daily/weather_daily_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/weather_locations.dart';
import '../../api/weather_api_repo.dart';

class WeatherDailyCubit extends Cubit<WeatherDailyState> {
  final WeatherApiRepository _weatherApiRepository;
  WeatherDailyCubit({required WeatherApiRepository weatherApiRepository})
      : _weatherApiRepository = weatherApiRepository,
        super(WeatherDailyInitialState());

  Future<void> getWeatherDailyInfoWithLonAndLat() async {
    emit(WeatherDailyLoadingState());
    try {
      final WeatherForecastDaily weatherInfo =
          await _weatherApiRepository.fetchWeatherForecast();
      emit(WeatherDailyLoadedState(weatherInfo));
    }on DioError catch (e) {
      emit(WeatherDailyErrorState(e.response!.statusMessage.toString()));
    }
  }


  Future<void> getWeatherDailyInfoWithCity({required String cityName}) async {
    emit(WeatherDailyLoadingState());
    try {
        final WeatherForecastDaily weatherInfo = await _weatherApiRepository
            .fetchWeatherForecast(cityName: cityName, isCity: true);
      emit(WeatherDailyLoadedState(weatherInfo));
    }on DioError catch (e) {
      emit(WeatherDailyErrorState(e.response!.statusMessage.toString()));
    }
  }
}
