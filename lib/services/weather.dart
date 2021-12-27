import 'package:clima_app/services/location.dart';
import 'package:clima_app/services/networking.dart';

// api key
const apiKey = '73a31f8c0de5ece67aa1b98c9178af7c';

const openWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

// responsible for getting waether for a particular location
class WeatherModel {
  // for getting weather of typed location
  Future<dynamic> getCityWeather(String cityName) async{
    var url = '$openWeatherMapUrl?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  // for getting weather data of default(current place) location
  Future<dynamic> getLocationWeather() async{
    Location loc = Location();
    await loc.getCurrentLocation();

    // http requests using http package (networking file)
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapUrl?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey&units=metric');

    // getting from network file
    var weatherData =
        await networkHelper.getData(); // these data send to locationscreen

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
