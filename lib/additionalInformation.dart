import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const AdditionalInformation({super.key,required this.icon,required this.title,required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
                  children: [
                    Icon(icon),SizedBox(height: 10,),
                    Text(title,style: TextStyle(fontSize: 16),),
                    Text(description,style: TextStyle(fontSize: 16),),
                  ],
                );
  }
}