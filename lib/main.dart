import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'models/weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String location = '';
  String _weather = '';
  String Address = 'search';

  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Placemark> getPlacemark(double latitude, double longitude) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    return placemark[0];
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  Future getData(double latitude, double longitude) async {
    String api = 'http://api.openweathermap.org/data/2.5/forecast';
    String appId = '381c7775ecbf2b68915054705c3a5195';

    String url = '$api?lat=$latitude&lon=$longitude&APPID=$appId';

    http.Response response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    Map parsed = json.decode(response.body);

    return parsed['list'][0]['weather'][0]['description'];
  }

  @override
  void initState() {
    super.initState();
    getPosition().then((position) {
      getPlacemark(position.latitude, position.longitude).then((data) {
        getData(position.latitude, position.longitude).then((weather) {
          print('on line 62...$_weather');

          setState(() {
            location = data.locality!;
            _weather = weather as String;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _weather,
            ),
            Text(Address),
            ElevatedButton(
                onPressed: () async {
                  Position position = await getPosition();
                  GetAddressFromLatLong(position);
                },
                child: const Text('Get location'))
          ],
        ),
      ),
    );
  }
}
