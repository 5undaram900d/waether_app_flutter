
import 'package:a03_weather_app/a07_hourly_weather_model.dart';
import 'package:flutter/material.dart';

import 'a04_api_setup.dart';
import 'a05_current_weather_model.dart';
import 'package:http/http.dart' as http;


getCurrentWeather(lat, long) async {
  var link = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";

  var res = await http.get(Uri.parse(link));
  if(res.statusCode == 200){
    var data = currentWeatherDataFromJson(res.body.toString());
    debugPrint("Fetching data successfully");
    return data;
  }
}


getHourlyWeather(lat, long) async {
  var hourlyLink = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";

  var res = await http.get(Uri.parse(hourlyLink));
  if(res.statusCode == 200){
    var data = hourlyWeatherDataFromJson(res.body.toString());
    debugPrint("Fetching hourly data successfully");
    return data;
  }
}