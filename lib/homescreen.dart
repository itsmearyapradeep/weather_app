import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isLoaded = false;
  late num temp;
  late num press;
  late num hum;
  late num cover;
  late String cityname = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentlocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff8EC5FC),
              Color(0xffD9AFD9),
              Color(0xff0093E9),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Visibility(
          visible: isLoaded,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.09,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    onFieldSubmitted: (String s) {
                      setState(() {
                        cityname = s;
                        getcityweather(s);
                        isLoaded = false;
                        controller.clear();
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'search city',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      cityname,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade900,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                          image: AssetImage('images/thermometer.png'),
                          width: MediaQuery.of(context).size.width * 0.09),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'temperature:${temp.toStringAsFixed(3)} °C',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade900,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                          image: AssetImage('images/barometer.png'),
                          width: MediaQuery.of(context).size.width * 0.09),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'pressure:${press.toStringAsFixed(3)} hPa',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade900,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                          image: AssetImage('images/humidity.png'),
                          width: MediaQuery.of(context).size.width * 0.09),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'humidity:${hum.toInt()} %',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade900,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                          image: AssetImage('images/cloud cover.png'),
                          width: MediaQuery.of(context).size.width * 0.09),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'cloud cover:${cover.toInt()}',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )
            ],
          ),
          replacement: Center(child: CircularProgressIndicator()),
        ),
      ),
    ));
  }

  getCurrentlocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);
    if (p != null) {
      print('Lat:${p.latitude},Long:${p.longitude}');
      getCurrentcityweather(p);
    } else {
      print('data unavailable');
    }
  }

  getcityweather(String cityname) async {
    var Client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await Client.get(url);
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

  getCurrentcityweather(Position position) async {
    var Client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await Client.get(url);
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

  updateUI(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityname = 'not available';
      } else {
        temp = decodeData['main']['temp'] - 273;
        press = decodeData['main']['pressure'];
        hum = decodeData['main']['humidity'];
        cover = decodeData['clouds']['all'];
        cityname = decodeData['name'];
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  }
