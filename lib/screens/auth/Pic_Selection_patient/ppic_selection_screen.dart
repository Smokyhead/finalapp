import 'package:finalapp/screens/auth/Pic_Selection_patient/ppic_selection_body.dart';
import 'package:flutter/material.dart';

class PPicSelectScreen extends StatelessWidget {
  const PPicSelectScreen({super.key});

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
      child: const PPicSelectBody(),
    ));
  }
}
