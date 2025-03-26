import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class Taskcompled extends StatelessWidget {
  const Taskcompled({super.key, required this.onpress});
 final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color:icontheme,
       shape: BoxShape.circle
        ),
        child: IconButton(
            onPressed:onpress,
            icon: Icon(
              Icons.task,
              color: Colors.white,
            )),
      ),
    );
  }
}
