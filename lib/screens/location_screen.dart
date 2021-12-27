import 'package:flutter/material.dart';
import 'package:clima_app/utilities/constants.dart';
import 'dart:convert';
import 'package:clima_app/services/weather.dart';
import 'package:clima_app/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  // getting data from location file
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

// getting relevent icons and message
WeatherModel weather = WeatherModel();

  String weatherIcon;
  int temperature;
  String weatherMessage;
  String city;

@override
  void initState() {
  updateUi(widget.locationWeather);
    super.initState();
  }

  void updateUi(dynamic weatherData){
  setState(() {
    // if son connection occur / disables location state
    if(weatherData == null){
      temperature = 0;
      weatherIcon= 'Error';
      weatherMessage= 'Unable to get weather data';
      city = '';
      return;
    }
    // getting needed data as a decode type / compressed ( from loading screen)
    var condition = weatherData['weather'][0]['id'];
    // get weather icon
    weatherIcon =  weather.getWeatherIcon(condition);

    double temp = weatherData['main']['temp'];
    temperature = temp.toInt();
    // message showing
    weatherMessage = weather.getMessage(temperature);

    city = weatherData['name'];
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async{
                      var weatherData =await weather.getLocationWeather();
                      setState(() {
                        updateUi(weatherData);
                      });

                      print('got new weather data');
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: ()async {
                      // here typedName is the input field value
                     var typedName= await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );
                     if(typedName != null){
                       var weatherData = await weather.getCityWeather(typedName);
                       updateUi(weatherData);
                     }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $city",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

