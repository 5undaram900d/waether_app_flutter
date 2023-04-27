
import 'dart:js_util';

import 'package:a03_weather_app/a02_custom_themes.dart';
import 'package:a03_weather_app/a03_toggle_theme.dart';
import 'package:a03_weather_app/a05_current_weather_model.dart';
import 'package:a03_weather_app/a07_hourly_weather_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class A01_HomeScreen extends StatefulWidget {

  const A01_HomeScreen({Key? key}) : super(key: key);

  @override
  State<A01_HomeScreen> createState() => _A01_HomeScreenState();
}

class _A01_HomeScreenState extends State<A01_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: A02_CustomThemes.lightTheme,
      darkTheme: A02_CustomThemes.darkTheme,
      themeMode: ThemeMode.system,

      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: const A03_WeatherApp(),
    );
  }
}

class A03_WeatherApp extends StatelessWidget {
  const A03_WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);      // for shaving the theme state

    var controller = Get.put(A03_ToggleTheme());



    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(date, style: TextStyle(color: theme.primaryColor),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Obx(
            () => IconButton(
              onPressed: (){
                controller.changeTheme();
              },
              icon: Icon(controller.isDark.value ? Icons.light_mode : Icons.dark_mode, color: theme.iconTheme.color,),
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: theme.iconTheme.color,)),



          /// **************************************************
          // Column(
          //   children: [
          //     searchBox(),
          //     Expanded(
          //       child: ListView(
          //         children: [
          //           Container(
          //             margin: const EdgeInsets.only(top: 35, bottom: 20),
          //             child: const Text('All Lists', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
          //           ),
          //           for(A04_ToDo_Function todoo in _foundToDo)
          //             A03_ToDo_Item(todo: todoo, onToDoChanged: _handleToDoChange, onDeleteItem: _deleteToDoItem,)
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          /// **************************************************
          FutureBuilder(
            future: controller.currentWeatherData,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                CurrentWeatherData data = snapshot.data;
                return Material(
                  child: Autocomplete <String>(
                    optionsBuilder: (TextEditingValue textEditingValue){
                      if(textEditingValue.text == '') {
                        return Iterable.empty();
                      }
                      // return listItems.where((item) => item.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      return data.where
                    },
                    onSelected: (item) => debugPrint('The $item was selected'),
                  ),
                );
              }
            },
          ),
          /// **************************************************



        ],
      ),


      body: Obx(
          () => controller.isLoaded.value

              ? Container(
                  padding: const EdgeInsets.all(12),
                  child: FutureBuilder(
                    future: controller.currentWeatherData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        CurrentWeatherData data = snapshot.data;

                        List dat = [];
                        dat = data;

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// *********************************
                              Material(
                                child: Autocomplete <String>(
                                  optionsBuilder: (TextEditingValue textEditingValue){
                                    if(textEditingValue.text == '') {
                                      return Iterable.empty();
                                    }
                                    // return listItems.where((item) => item.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                                    return
                                  },
                                  onSelected: (item) => debugPrint('The $item was selected'),
                                ),
                              ),
                              /// *********************************

                              Text(data.name, style: TextStyle(color: theme.primaryColor, letterSpacing: 2,fontWeight: FontWeight.bold, fontSize: 30),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network('http://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png', height: 80, width: 80,),
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: '${data.main.temp}⁰',         // by default it has white color
                                              style: TextStyle(color: theme.primaryColor, fontSize: 35)
                                          ),
                                          TextSpan(
                                              text: '  ${data.weather[0].main}',         // by default it has white color
                                              style: TextStyle(color: theme.primaryColor, fontSize: 15, letterSpacing: 2)
                                          ),
                                        ]
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(onPressed: null, icon: Icon(Icons.expand_less, color: theme.iconTheme.color,), label: Text('${data.main.tempMax}', style: TextStyle(color: theme.iconTheme.color),),),
                                  TextButton.icon(onPressed: null, icon: Icon(Icons.expand_more, color: theme.iconTheme.color,), label: Text('${data.main.tempMin}', style: TextStyle(color: theme.iconTheme.color),),),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(3, (index) {

                                  var iconList = [
                                    "https://media.tenor.com/GtDkRSPU9CgAAAAC/cloud-weather.gif",
                                    "https://img.freepik.com/premium-vector/humidity-weather-sensor-water-level-rate-vector-stock-illustration_100456-11209.jpg?w=826",
                                    "https://cdn-icons-png.flaticon.com/512/3050/3050874.png"
                                  ];
                                  var values = ["${data.clouds.all}", "${data.main.humidity}", "${data.wind.speed} km/h"];

                                  return Column(
                                    children: [
                                      const SizedBox(height: 10,),

                                      Image.network(iconList[index], width: 80, height: 80,),

                                      const SizedBox(height: 10,),

                                      Text(values[index], style: TextStyle(color: Colors.grey[600]),)
                                    ],
                                  );
                                }),
                              ),

                              const SizedBox(height: 10,),
                              const Divider(thickness: 2,),
                              const SizedBox(height: 10,),

                              FutureBuilder(
                                future: controller.hourlyWeatherData,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if(snapshot.hasData){

                                    HourlyWeatherData hourlyData = snapshot.data;

                                    return SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: hourlyData.list.length > 12 ? 12 : hourlyData.list.length,
                                          itemBuilder: (BuildContext context, int index){

                                            var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyData.list[index].dt * 1000));

                                            return Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurpleAccent,
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(time, style: const TextStyle(color: Colors.white),),
                                                  Image.network("http://openweathermap.org/img/wn/${hourlyData.list[index].weather[0].icon}@2x.png", height: 80, width: 80,),
                                                  Text('${hourlyData.list[index].main.temp}⁰', style: const TextStyle(color: Colors.white),),
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    );
                                  }
                                  else{
                                    return const Center(child: CircularProgressIndicator(),);
                                  }
                                }
                              ),

                              const SizedBox(height: 10,),
                              const Divider(thickness: 2,),
                              const SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Next 7 days..', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.primaryColor),),
                                  TextButton(onPressed: (){}, child: const Text('View All'))
                                ],
                              ),

                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (BuildContext context, int index){
                                  var day = DateFormat("EEEE").format(DateTime.now().add(Duration(days: index+1)));

                                  return Card(
                                    color: theme.cardColor,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(day, style: TextStyle(fontWeight: FontWeight.w500, color: theme.primaryColor),)),

                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: null,
                                              icon: Image.network("https://www.logolynx.com/images/logolynx/b1/b10d8953568b3b8b34633ced23fbb23f.png", height: 40, width: 40,),
                                              label: Text('38℃', style: TextStyle(color: theme.primaryColor),),
                                            ),
                                          ),

                                          RichText(
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '42℃ / ',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: theme.primaryColor),
                                                  ),

                                                  TextSpan(
                                                    text: '26℃',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.iconTheme.color),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                },
                              ),

                            ],
                          ),
                        );
                      }
                      else{
                        return const Center(child: CircularProgressIndicator(),);
                      }
                    },
                  )

                )

              : const Center(child: CircularProgressIndicator())

      ),

    );
  }




  /// ******************************************************
  // Widget searchBox(){
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: TextField(
  //       onChanged: (value) => _runFilter(value),
  //       decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.all(0),
  //         prefixIcon: Icon(Icons.search, color: Colors.black, size: 30,),
  //         border: InputBorder.none,
  //         hintText: "Search",
  //         hintStyle: TextStyle(fontSize: 20),
  //         prefixIconConstraints: BoxConstraints(maxHeight: 25, minWidth: 40),
  //       ),
  //     ),
  //   );
  // }
  //
  // void _runFilter(String enteredKeyword) {
  //   List<A04_ToDo_Function> results = [];
  //   if(enteredKeyword.isEmpty) {
  //     results = todoList;
  //   }
  //   else{
  //     results = todoList.where((element) => element.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
  //   }
  //   setState(() {
  //     _foundToDo = results;
  //   });
  // }
  /// **************************************************



}









// complete