import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: icontheme,
        size: 50.0,
      ),
    );
  }
}
