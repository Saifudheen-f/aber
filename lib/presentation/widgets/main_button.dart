
import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onpress, required this.child});
  final VoidCallback onpress;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap:onpress ,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: gradient,
            ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          )
        ),
      ),
    );
  }
}
