import 'dart:async';

import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/presentation/screens/homescreen.dart';
import 'package:espoir_marketing/presentation/screens/login/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Timer(const Duration(seconds: 2), _checkAuthentication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: imageDecoration,
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 2),
            child:  Image(
              image: AssetImage(
               logoImage,
              ),
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }

  void _checkAuthentication() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
     
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            const Homepage(),
      ));
    } else {
     
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
    }
  }
}
