import 'package:finalapp/screens/auth/Doctor_Login/Components/doctor_body_login.dart';
import 'package:flutter/material.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.5,
          image: AssetImage('assets/images/Untitled design.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: const DoctorLoginBody(),
    ));
  }
}
