import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/api/location_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/weather_locations.dart';

class WeatherApiRepository {
  final Dio _dio = Dio();
  static List<String> listOfCity = [];
  static const String keyPrefs = "cities";

  Future<String> saveCitiesLocally({required String cityName}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      listOfCity = prefs.getStringList(keyPrefs) ?? [];
      listOfCity.add(cityName);
      if (prefs.getStringList(keyPrefs) != null) {
        prefs.remove(keyPrefs);
      }
      prefs.setStringList(keyPrefs, listOfCity);
      return "Success";
    } catch (e) {
      return "Error saveCitiesLocally method";
    }
  }
  Future<String> deleteCitiesLocally({required String cityName}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      listOfCity = prefs.getStringList(keyPrefs) ?? [];
      listOfCity.remove(cityName);
      if (prefs.getStringList(keyPrefs) != null) {
        prefs.remove(keyPrefs);
      }
      prefs.setStringList(keyPrefs, listOfCity);
      return "Success deleted";
    } catch (e) {
      return "Error saveCitiesLocally method";
    }
  }
  Future<List<String>> getCitiesLocally() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getStringList(keyPrefs) ?? [];
    } catch (e) {
      print("Error on getCitiesLocally method");
    }
    return [];
  }

  Future<WeatherForecastDaily> fetchWeatherForecast(
      {String? cityName, bool? isCity}) async {
    Map<String, String>? parameters;

    if (isCity == true) {
      var queryParameters = {
        'APPID': Constants.weatherAppIid,
        'units': 'metric',
        'q': cityName,
        'lang': 'ru'
      };
      parameters = queryParameters.cast<String, String>();
    } else {
      Location location = Location();
      await location.getCurrentLocation();
      var queryParameters = {
        'APPID': Constants.weatherAppIid,
        'units': 'metric',
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'lang': 'en'
      };
      parameters = queryParameters;
    }

    log('response: ${Constants.weatherBaseScheme + Constants.weatherBaseUrlDomain + Constants.weatherForecastPath + parameters.toString()}');

    var response = await _dio.get(
        Constants.weatherBaseScheme +
            Constants.weatherBaseUrlDomain +
            Constants.weatherForecastPath,
        queryParameters: parameters);

    if (response.statusCode == HttpStatus.ok) {
      final validMap =
          json.decode(json.encode(response.data)) as Map<String, dynamic>;
      log('response: $validMap');
      return WeatherForecastDaily.fromJson(validMap);
    } else {
      return Future.error("Error response");
    }
  }
}
