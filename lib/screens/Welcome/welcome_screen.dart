import 'package:finalapp/Screens/Welcome/Components/body_welc.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Untitled design.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Body(),
    ));
  }
}
