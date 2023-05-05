import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/patient_home/home_screens/account_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/home_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/notif_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int currentPage = 0;
  final screens = const [
    HomePage(),
    SearchPage(),
    NotifPage(),
    AccountPage(),
  ];

  final items = const [
    Icon(IconlyLight.home),
    Icon(IconlyLight.search),
    Icon(IconlyLight.notification),
    Icon(IconlyLight.profile),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: currentPage,
        onTap: (selectedIndex) {
          setState(() {
            currentPage = selectedIndex;
          });
        },
        height: 55,
        animationDuration: const Duration(milliseconds: 100),
        backgroundColor: Colors.transparent,
        color: kPrimaryLightColor,
      ),
    );
  }
}
