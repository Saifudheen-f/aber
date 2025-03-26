
import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';

class Mapbutton extends StatelessWidget {
  const Mapbutton(
      {super.key,
      required this.location,
      required this.onpress,
       required this.longpress,
      required this.loading});
  final String location;
  final VoidCallback onpress;
  final VoidCallback longpress;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      onLongPress:longpress ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: icontheme,
                    ),
                  ),
                   const SizedBox(height: 8),
                 
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: gradient
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 239, 240, 241),
                      ),
                      Text(
                        'Google map',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  loading
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              location,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
           const SizedBox(height: 8),
                 
        ],
      ),
    );
  }
}
