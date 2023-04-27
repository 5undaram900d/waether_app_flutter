
import 'package:a03_weather_app/a06_api_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class A03_ToggleTheme extends GetxController{

  @override
  void onInit() async{                   // in getx in place used onInit() like place of Init() in stateful

    await getUserLocation();

    currentWeatherData = getCurrentWeather(latitude.value, longitude.value);

    hourlyWeatherData = getHourlyWeather(latitude.value, latitude.value);

    super.onInit();
  }

  var isDark = false.obs;           // obs is a one type of listener

  dynamic currentWeatherData;

  dynamic hourlyWeatherData;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  var isLoaded = false.obs;

  changeTheme(){
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  getUserLocation() async{
    var isLocationEnabled;
    var userPermission;

    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isLocationEnabled){
      return Future.error("Location is not enabled");
    }

    userPermission = await Geolocator.checkPermission();
    if(userPermission == LocationPermission.deniedForever){
      return Future.error("Permission is denied forever");
    }
    else if(userPermission == LocationPermission.denied){
      userPermission = await Geolocator.requestPermission();
      if(userPermission == LocationPermission.denied){
        return Future.error("Permission is denied");
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value){
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isLoaded.value = true;
    });

  }

}