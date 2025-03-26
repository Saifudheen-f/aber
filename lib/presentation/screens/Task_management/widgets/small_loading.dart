import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SmallLoading extends StatelessWidget {
  const SmallLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading",
            style: TextStyle(color: icontheme),
          ),
          SpinKitCircle(
            color: icontheme,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
