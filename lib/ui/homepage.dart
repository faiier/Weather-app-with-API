import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //format date
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:weatherapp/ui/detailPage.dart';

const h1 = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
const h2 = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);
const h3 = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 30,
);
const text1 = TextStyle(
  color: Colors.white,
  fontSize: 16,
);
const text2 = TextStyle(
  color: Colors.white,
  fontSize: 12,
);
const text3 = TextStyle(
  color: Colors.white70,
  fontSize: 12,
);
const DEGREE_SYMBOL = "\u{00B0}";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSwitchedOn = true; //Day_Night_Switch

  //Day Theme
  final ThemeData dayTheme = ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 5, 134, 219),
      fontFamily: 'Lato');

  //Night Theme
  final ThemeData nightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xff19212F),
    fontFamily: 'Lato',
  );

  //Search City
  final TextEditingController _cityController = TextEditingController();

  static String API_KEY = 'a896f8e567974ef6b7e124125231703'; //My API Key

  String location = 'Bangkok'; //Default location
  String country = '';
  String weatherIcon = '';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  String currentDate = '';
  //Forecast data
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  int minTemperature = 0;
  int maxTemperature = 0;
  int chanceOfRain = 0;

  String currentWeatherStatus = '';

  //API Call
  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days=7&q=";

  //function Search City
  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);
        country = getShortLocationName(locationData["country"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('EEE, MMMM d').format(parsedDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];

        //weathericon change follow daytime-nighttime
        if (parsedDate.hour >= 6 && parsedDate.hour < 18) {
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() +
              "day.png";
        } else {
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() +
              "night.png";
        }

        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        minTemperature = dailyWeatherForecast[0]['day']['mintemp_c'].toInt();
        maxTemperature = dailyWeatherForecast[0]['day']['maxtemp_c'].toInt();
        chanceOfRain = hourlyWeatherForecast[0]['chance_of_rain'].toInt();

        print(dailyWeatherForecast);
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    return Theme(
      data: _isSwitchedOn ? nightTheme : dayTheme,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Icon Menu
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        child: Image.asset(
                          'assets/menu.png',
                          width: 25,
                          height: 25,
                        )),

                    Container(
                      width: 255,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Icon Location
                          Icon(Icons.location_on_rounded,
                              size: 38, color: Colors.white),

                          //City Name
                          Text(
                            location + ', ', //ตัวเเปร location
                            style: h1,
                          ),

                          //Country Name
                          Text(
                            country, //ตัวเเปร country
                            style: text1.copyWith(color: Colors.white70),
                          ),

                          //Arrow Down

                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white70,
                              ),
                            ),
                            onTap: () {
                              _cityController.clear();
                              showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                        controller:
                                            ModalScrollController.of(context),
                                        child: Container(
                                          height: 350,
                                          //color: Colors.white60,
                                          child: TextField(
                                            onChanged: (searchText) {
                                              fetchWeatherData(searchText);
                                            },
                                            controller: _cityController,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () =>
                                                    _cityController.clear(),
                                                child: Icon(
                                                  Icons.close,
                                                ),
                                              ),
                                              hintText:
                                                  'Search city e.g. London',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                          ),
                        ],
                      ),
                    ),

                    //Day_Night_Switch
                    Container(
                      width: 65,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white10,
                      ),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: _isSwitchedOn,
                          onChanged: (value) {
                            setState(() {
                              _isSwitchedOn = value;
                            });
                          },
                          activeTrackColor: Colors.transparent,
                          activeColor: _isSwitchedOn
                              ? Colors.yellow[600]
                              : Colors.yellow[600],
                          inactiveThumbImage:
                              const AssetImage('assets/day.png'),
                          activeThumbImage:
                              const AssetImage('assets/night.png'),
                          inactiveTrackColor: Colors.transparent,
                          inactiveThumbColor: Colors.yellow[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Today',
              style: h2,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              currentDate, //ตัวเเปร วัน วันที่ เดือน
              style: text1.copyWith(color: Colors.white70),
            ),
            SizedBox(
              height: 15,
            ),
            //Weather Container
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 370,
                        height: 390,
                        color: Colors.white10,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 130),
                  child: Image.asset(
                    'assets/clouds2.png',
                    width: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 220, top: 120),
                  child: Image.asset(
                    'assets/clouds2.png',
                    width: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 335, top: 220),
                  child: Image.asset(
                    'assets/clouds2.png',
                    width: 50,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      //Picture weather real-time

                      Image.asset(
                        'assets/' + weatherIcon,
                        width: 200,
                        height: 200,
                      ),

                      //Weather status
                      Text(
                        currentWeatherStatus,
                        style: h1.copyWith(fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      //Temperature

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                temperature.toString(), //degrees celsius
                                style: h3,
                              ),
                            ),
                            Text(
                              ' $DEGREE_SYMBOL', //degrees celsius symbol
                              style: h3.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),

                      //Max-Min Temperature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'H:' + maxTemperature.toString(),
                              style: text1,
                            ),
                          ),
                          Text(
                            '$DEGREE_SYMBOL',
                            style: text1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'L:' + minTemperature.toString(),
                              style: text1,
                            ),
                          ),
                          Text(
                            '$DEGREE_SYMBOL',
                            style: text1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Wind
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/wind.png',
                                width: 30,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                windSpeed.toString() +
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
                                width: 30,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                chanceOfRain.toString() + ' %', //Chance Of Rain
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
                                width: 30,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                humidity.toString() + ' %', //Humidity
                                style:
                                    text2.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Humidity',
                                style: text3,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today',
                    style: h1.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.yellow[200]),
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          'Next 2 Day ',
                          style: h1.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () {
                      if (_isSwitchedOn == true) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return SevenDayPage(
                            nightTheme,
                            ThemeData: nightTheme,
                            dailyForecastWeather: dailyWeatherForecast,
                          );
                        })));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return SevenDayPage(
                            dayTheme,
                            ThemeData: dayTheme,
                            dailyForecastWeather: dailyWeatherForecast,
                          );
                        })));
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: 370,
                height: 1,
                color: Colors.white10,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: hourlyWeatherForecast.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  String currentTime =
                      DateFormat('HH:mm:ss').format(DateTime.now());
                  String currentHour = currentTime.substring(0, 2);

                  String forecastTime =
                      hourlyWeatherForecast[index]["time"].substring(11, 16);
                  String forecastHour =
                      hourlyWeatherForecast[index]["time"].substring(11, 13);

                  String forecastWeatherName =
                      hourlyWeatherForecast[index]["condition"]["text"];

                  String forecastTemperature =
                      hourlyWeatherForecast[index]["temp_c"].round().toString();

                  String displayTimeNow =
                      currentHour == forecastHour ? "Now" : forecastTime;

                  String sunriseTime = '06:00:00';
                  String sunsetTime = '18:00:00';
                  bool isDaytime = (forecastTime
                              .compareTo(sunriseTime.substring(0, 2)) >=
                          0 &&
                      forecastTime.compareTo(sunsetTime.substring(0, 2)) < 0);

                  //weathericon change follow daytime-nighttime
                  String forecastWeatherIcon = isDaytime
                      ? forecastWeatherName.replaceAll(' ', '').toLowerCase() +
                          "day.png"
                      : forecastWeatherName.replaceAll(' ', '').toLowerCase() +
                          "night.png";

                  return Container(
                    decoration: BoxDecoration(
                      color: currentHour == forecastHour
                          ? Colors.white10
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            child: Image.asset(
                              'assets/' + forecastWeatherIcon,
                              width: 60,
                            ),
                          ),
                          Text(
                            forecastTemperature + '\u{00B0}',
                            style: text1,
                          ),
                          Text(displayTimeNow,
                              style: text1.copyWith(
                                fontWeight: currentHour == forecastHour
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
