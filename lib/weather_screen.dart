import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additionalInformation.dart';
import 'package:weather_app/hourlyForecastItem.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final baseURL = "https://api.openweathermap.org/data/2.5/";

  final city = "London";

  final apiKey = "8d5e8067681393cccb6b80f007b9e590";

  Future getCurrentWeather() async {
    try {
      final response =
          await http.get(Uri.parse('$baseURL/forecast?q=$city&appid=$apiKey'));
      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occured";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: getCurrentWeather(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ));
                }
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //main card
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "300.67 F",
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Icon(
                                      Icons.cloud,
                                      size: 65,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Rain",
                                      style: TextStyle(fontSize: 24),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //listing card
                      Text(
                        "Weather Forecast",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            HourlyForecastItem(
                              icon: Icons.cloud,
                              temperature: "300.5",
                              time: "03:00",
                            ),
                            HourlyForecastItem(
                              icon: Icons.cloud,
                              temperature: "298.5",
                              time: "06:00",
                            ),
                            HourlyForecastItem(
                              icon: Icons.cloud,
                              temperature: "299.0",
                              time: "09:00",
                            ),
                            HourlyForecastItem(
                              icon: Icons.cloud,
                              temperature: "315.4",
                              time: "12:00",
                            ),
                            HourlyForecastItem(
                              icon: Icons.thunderstorm,
                              temperature: "310.9",
                              time: "15:00",
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //additional information card
                      Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInformation(
                            icon: Icons.water_drop,
                            title: "Humidity",
                            description: '91',
                          ),
                          AdditionalInformation(
                            icon: Icons.air,
                            title: "Wint speed",
                            description: "6.5",
                          ),
                          AdditionalInformation(
                            icon: Icons.beach_access,
                            title: "Pressure",
                            description: "1200",
                          )
                        ],
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
