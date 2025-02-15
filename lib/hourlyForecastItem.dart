import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final icon;
  final temperature;
  final time;
  const HourlyForecastItem({super.key,required this.icon,required this.temperature,required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 35,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              temperature,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ),
    );
  }
}
