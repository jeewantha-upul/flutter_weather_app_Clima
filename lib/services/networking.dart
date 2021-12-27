import 'package:http/http.dart' as http;
import 'dart:convert';

// http requests using http package
class NetworkHelper{

  NetworkHelper(this.url);
  final String url;

  Future getData()async{
    // here we use http to see clearly that we have used this get method from http package . this is only for further references of our code
    http.Response response = await http.get(url);

    if(response.statusCode == 200){
      dynamic data = jsonDecode(response.body);
      return data;
    }
    else{
      print(response.statusCode);
    }
  }
}