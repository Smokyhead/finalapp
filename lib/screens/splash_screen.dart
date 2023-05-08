import 'dart:async';

import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/screens/doctor_home/doctor_home.dart';
import 'package:finalapp/screens/patient_home/patient_home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkUser();
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Untitled design.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/Clin.jpg',
                scale: 2,
              ),
            )));
  }

  void checkUser() {
    if (UserState.isConnected == true) {
      if (Role.role == "patient") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const DoctorHome())));
      } else if (Role.role == "doctor") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PatientHome())));
      }
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen())));
    }
  }
}
