import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String title;
  final String content;

  const InfoContainer({required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: icontheme,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 81, 81, 82),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
