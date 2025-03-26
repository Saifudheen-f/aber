
import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/core/errormessage.dart';
import 'package:espoir_marketing/core/validation.dart';
import 'package:espoir_marketing/presentation/screens/homescreen.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: backGroundDecoration,
            ),
          ),
          Container(
            decoration: imageDecoration,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02, // 10% padding of screen width
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Image(
                      image: AssetImage(logoImage),
                      width: 200,
                      height: 200,
                    ),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextFied(
                            controller: userNameController,
                            hintText: 'Enter Username',
                            obscureText: false,
                            validator: validateEmail,
                          ),
                          SizedBox(height: size.height * 0.02),
                          MyTextFied(
                            controller: passwordController,
                            hintText: 'Enter password',
                            obscureText: true,
                            validator: (value) =>
                                validateNotNull(value, 'password'),
                            maxLine: 1,
                          ),
                          SizedBox(height: size.height * 0.04),
                          MyButton(
                            onpress: _signInWithEmailAndPassword,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to handle sign-in logic
  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userNameController.text,
          password: passwordController.text,
        );
        if (userCredential.user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        }
      } catch (e) {
        String errorMessage =
            'An unexpected error occurred. Please try again later.';

        if (e is FirebaseAuthException) {
          // Get the user-friendly error message from the function
          errorMessage = getFriendlyErrorMessage(e);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid credentials')),
      );
    }
  }
}
