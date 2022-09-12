import 'dart:async';
import 'package:banking_app/constants/const.dart';
import 'package:banking_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage('assets/images/app_logo.jpg'),
          ),
          SizedBox(
            height: 15.0,
          ),
          DefaultTextStyle(
            style: TextStyle(color: secondaryColor, fontSize: 25.0),
            child: Text('Online Banking'),
          ),
        ],
      ),
    );
  }
}
