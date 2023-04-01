import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';
import 'dart:ui';

class SevenDayPage extends StatefulWidget {
  final ThemeData themeData;
  final dailyForecastWeather;

  const SevenDayPage(
    this.themeData, {
    Key? key,
    required ThemeData,
    this.dailyForecastWeather,
  }) : super(key: key);

  @override
  State<SevenDayPage> createState() => _SevenDayPageState();
}

class _SevenDayPageState extends State<SevenDayPage> {
  @override
  Widget build(BuildContext context) {
    var weatherData = widget.dailyForecastWeather;

    //function to get weather
    Map getForecastWeather(int index) {
      int maxWind = weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
      int chanceOfRain =
          weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate = DateTime.parse(weatherData[index]["date"]);
      var forecastDate = DateFormat('EEE, MMMM d').format(parsedDate);

      String weatherName = weatherData[index]["day"]["condition"]["text"];
      String weatherIcon;
      String DEGREE_SYMBOL = "\u{00B0}";

      //weathericon change follow daytime-nighttime
      if (parsedDate.hour >= 6 && parsedDate.hour < 18) {
        weatherIcon = weatherName.replaceAll(' ', '').toLowerCase() + "day.png";
      } else {
        weatherIcon =
            weatherName.replaceAll(' ', '').toLowerCase() + "night.png";
      }

      int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
      int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

      var forecastData = {
        'maxWind': maxWind,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature
      };
      return forecastData;
    }

    return Theme(
      data: widget.themeData,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: [
                      //Icon Menu
                      CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white10,
                          child: IconButton(
                              onPressed: (() {
                                Navigator.pop(context);
                              }),
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                                size: 20,
                              ))),

                      Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                            Text(
                              ' Next 2 Days',
                              style: h1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //Container Weather
              Expanded(
                child: Column(children: [
                  //Tomorrow
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 370,
                            height: 400,
                            color: Colors.white10,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 40),
                      child: Image.asset(
                        'assets/clouds2.png',
                        width: 120,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 335, top: 190),
                      child: Image.asset(
                        'assets/clouds2.png',
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 240, top: 380),
                      child: Image.asset(
                        'assets/clouds2.png',
                        width: 50,
                      ),
                    ),
                    //Weather picture real time
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 15),
                      child: Image.asset(
                        'assets/' + getForecastWeather(1)['weatherIcon'],
                        width: 200,
                        height: 200,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 210),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Tomorrow
                          Text(
                            'Tomorrow',
                            style: h2.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //Date
                          Text(
                            getForecastWeather(1)['forecastDate'],
                            style: h2.copyWith(fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //Temperature max-min
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                getForecastWeather(1)['maxTemperature']
                                    .toString(),
                                style: h3.copyWith(fontSize: 40),
                              ),
                              Text(
                                ' /' +
                                    getForecastWeather(1)['minTemperature']
                                        .toString() +
                                    DEGREE_SYMBOL,
                                style: text3.copyWith(fontSize: 25),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //Weather Status
                          Text(
                            getForecastWeather(1)['weatherName'],
                            style: text1.copyWith(
                                color: Colors.white70, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 280),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Wind
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/wind.png',
                                width: 40,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                getForecastWeather(1)['maxWind'].toString() +
                                    ' km/h', //ตัวเเปร windspeed
                                style:
                                    text2.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Wind',
                                style: text3,
                              )
                            ],
                          ),
                          //Chance Of Rain
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/chanceofrain.png',
                                width: 40,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                getForecastWeather(1)['chanceOfRain']
                                        .toString() +
                                    ' %', //Chance Of Rain
                                style:
                                    text2.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Chance Of Rain',
                                style: text3,
                              )
                            ],
                          ),
                          //Humidity
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/humidity.png',
                                width: 40,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                getForecastWeather(1)['avgHumidity']
                                        .toString() +
                                    ' %', //Humidity
                                style:
                                    text2.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Humidity',
                                style: text3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  // Next day
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 370,
                            height: 180,
                            color: Colors.white10,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 100),
                      child: Image.asset(
                        'assets/clouds2.png',
                        width: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 310, top: 200),
                      child: Image.asset(
                        'assets/clouds2.png',
                        width: 40,
                      ),
                    ),
                    //Weather picture real time
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Image.asset(
                        'assets/' + getForecastWeather(2)['weatherIcon'],
                        width: 150,
                        height: 150,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 35, left: 210),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Tomorrow
                          Text(
                            getForecastWeather(2)['forecastDate'],
                            style: h2,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //Temperature max-min
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                getForecastWeather(2)['maxTemperature']
                                    .toString(),
                                style: h3.copyWith(fontSize: 28),
                              ),
                              Text(
                                ' /' +
                                    getForecastWeather(2)['minTemperature']
                                        .toString() +
                                    DEGREE_SYMBOL,
                                style: text3.copyWith(fontSize: 22),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //Weather Status
                          Text(
                            getForecastWeather(2)['weatherName'],
                            style: text1.copyWith(color: Colors.white70),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
