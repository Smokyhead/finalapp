// ignore_for_file: avoid_print

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/doctor_home/home_screens/home_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/notif_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/account_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:badges/badges.dart' as badges;

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int currentPage = 0;
  final screens = const [HomePage(), NotifPage(), AccountPage()];
  final items = [
    const Icon(IconlyLight.home),
    badges.Badge(
        position: badges.BadgePosition.topEnd(),
        badgeContent: const Text(
          "!",
          style: TextStyle(color: Colors.white),
        ),
        child: const Icon(IconlyLight.notification)),
    const Icon(IconlyLight.profile),
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
