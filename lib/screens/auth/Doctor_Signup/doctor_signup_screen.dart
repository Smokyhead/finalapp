import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/auth/Doctor_Signup/Components/doctor_body_signup.dart';
import 'package:flutter/material.dart';

class DoctorSignupScreen extends StatelessWidget {
  const DoctorSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            )),
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: const Text("Inscription - Docteur"),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('assets/images/Untitled design.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Body(),
        ));
  }
}
