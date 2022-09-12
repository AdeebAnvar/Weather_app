import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as k;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = true;
  num? temperature;
  num? humidity;
  num? pressure;
  num? clouds;
  String cityName = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: isLoaded,
        replacement: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.black,
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white38,
                    ),
                    hintText: "SEARCH CITY",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onFieldSubmitted: (String city) {
                    setState(() {
                      cityName = city;
                      getCityWeather(city);
                      isLoaded = false;
                      controller.clear();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pin_drop_sharp,
                ),
                Text(
                  cityName != null ? "$cityName" : "City name",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildWeathertile(
              label: "temperature ",
              unit: temperature != null ? "${temperature?.round()}" : "",
            ),
            buildWeathertile(
              label: "HUmidity",
              unit: humidity != null ? "${humidity?.round()}" : "",
            ),
            buildWeathertile(
              label: "Clouds",
              unit: clouds != null ? "${clouds?.round()}" : "",
            ),
            buildWeathertile(
              label: " Pressure",
              unit: pressure != null ? "${pressure?.round()}" : "",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeathertile({String? label, String? unit}) => Padding(
        padding: const EdgeInsets.all(23.0),
        child: ListTile(
          title: Text(
            label != null ? label.toString() : "",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 30,
            ),
          ),
          subtitle: Text(
            label != null ? unit.toString() : "",
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
            ),
          ),
        ),
      );

  getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    if (position != null) {
      getCurrentCityWeather(position);
    } else {
      print("");
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      // print(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      print(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temperature = 0;
        pressure = 0;
        humidity = 0;
        clouds = 0;
        cityName = 'NOT AVAILABLE';
      } else {
        temperature = decodedData['main']['temp'] - 273;
        pressure = decodedData['main']['pressure'];
        humidity = decodedData['main']['humidity'];
        clouds = decodedData['clouds']['all'];
        cityName = decodedData['name'];
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}
