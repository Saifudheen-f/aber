import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';


class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
           gradient: const LinearGradient(
              colors: [
                Color.fromARGB(153, 244, 238, 238),
             Color.fromARGB(153, 238, 241, 237),
                Color.fromARGB(153, 234, 239, 233), // Start with dark blue
              ],
              stops: [0.0, 0.8, 2.0], // Positions for the gradient transition
              begin: Alignment.centerLeft, // Start of the gradient
              end: Alignment.centerRight, // End of the gradient
            ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bordercolor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Quote on the left
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME to!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 154, 3, 3),
                      ),
                    ),
                    const Text(
                      'ABER steel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Text(
                      "craftsmanship meets innovation in the manufacturing of steel doors and windows.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Image on the right
            Container(
              width: 120,
              height: 60,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/test.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
