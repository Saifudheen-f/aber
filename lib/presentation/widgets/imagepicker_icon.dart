
import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';
class ImagePickerIcons extends StatelessWidget {
  const ImagePickerIcons(
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
          height: 70,
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient:gradient
            ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color:Colors.white,
                  ),
                  Text(
                    txt,
                    style: const TextStyle(fontSize: 10,color:Colors.white,),
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
