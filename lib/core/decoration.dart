import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

BoxDecoration imageDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage(backGroundimage),
    fit: BoxFit.cover,
  ),
);

final BoxDecoration backGroundDecoration = BoxDecoration(
  borderRadius: const BorderRadius.vertical(
    bottom: Radius.circular(10),
  ),
  gradient: LinearGradient(
    colors: [
      secondaryColor,
      primaryColor.withOpacity(0.8),
      secondaryColor,
    ],
    stops: const [0.0, 1.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);

const Gradient gradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 164, 34, 25),
    Color.fromARGB(255, 152, 20, 13),
    Color.fromARGB(255, 211, 18, 4),
  ],
  stops: [0.0, 0.8, 2.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

