import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';

class MainIcon extends StatelessWidget {
  const MainIcon(
      {super.key,
      required this.icon,
      required this.txt,
      required this.onpress});
  final IconData icon;
  final String txt;
  final VoidCallback onpress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(153, 175, 173, 173),
                Color.fromARGB(153, 179, 175, 175),
                Color.fromARGB(153, 176, 173, 173), // Start with dark blue
              ],
              stops: [0.0, 0.8, 2.0], // Positions for the gradient transition
              begin: Alignment.centerLeft, // Start of the gradient
              end: Alignment.centerRight, // End of the gradient
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, gradient: gradient),
                        child: Icon(
                          icon, // Replace with your icon variable
                          size: 30, color: Colors.white,
                        ),
                      ),
                      const Text("●●")
                    ],
                  ),
                  Text(
                    txt,
                    style: const TextStyle(
                        fontSize: 13, color: Color.fromARGB(255, 2, 57, 105)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
