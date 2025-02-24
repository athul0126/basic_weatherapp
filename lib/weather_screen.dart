import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final city = "Kozhikode";

  final apiKey = "8d5e8067681393cccb6b80f007b9e590";

  Future<Map<String, dynamic>> getCurrentWeather() async {
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
          city,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                
              });
            },
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
                  return Center(child: CircularProgressIndicator.adaptive());
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
                final data = snapshot.data!;
                final currentWeatherData = data['list'][0];
                final currentTemprature = currentWeatherData['main']['temp'];
                final currentSky = currentWeatherData['weather'][0]['main'];
                final pressure = currentWeatherData['main']['pressure'];
                final humidity = currentWeatherData['main']['humidity'];
                final windSpeed = currentWeatherData['wind']['speed'];
                final tempInDegree = (currentTemprature-273.15).toStringAsFixed(1);
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
                                      '$tempInDegree C',
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Icon(
                                      currentSky == "Clouds" ||
                                              currentSky == "Rain"
                                          ? Icons.cloud
                                          : Icons.sunny,
                                      size: 65,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      currentSky,
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
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final hourlyForecast = data['list'][index + 1];
                            final hourlyForecastSky =
                                hourlyForecast['weather'][0]['main'];
                                final time = DateTime.parse(hourlyForecast['dt_txt']);
                            return HourlyForecastItem(
                              icon: hourlyForecastSky == 'Rain' ||
                                      hourlyForecastSky == 'Clouds'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              temperature:
                                  '${(hourlyForecast['main']['temp']-273.15).toStringAsFixed(1)} C',
                              time:DateFormat.j().format(time),
                            );
                          },
                          itemCount: 5,
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
                            description: humidity.toString(),
                          ),
                          AdditionalInformation(
                            icon: Icons.air,
                            title: "Wint speed",
                            description: windSpeed.toString(),
                          ),
                          AdditionalInformation(
                            icon: Icons.beach_access,
                            title: "Pressure",
                            description: pressure.toString(),
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
