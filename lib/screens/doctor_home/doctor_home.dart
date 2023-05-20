// ignore_for_file: avoid_print

import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/doctor_home/home_screens/home_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/notif_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/account_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:badges/badges.dart' as badges;
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int currentPage = 0;
  final screens = const [HomePage(), DNotifPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    setState(() {
      DNotifPage.notifNumber;
    });
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: screens,
      ),
      bottomNavigationBar: StylishBottomBar(
        elevation: 10,
        backgroundColor: kPrimaryLightColor,
        option: AnimatedBarOptions(
            iconStyle: IconStyle.animated,
            barAnimation: BarAnimation.blink,
            backgroundColor: kPrimaryColor),
        items: [
          BottomBarItem(
            icon: const Icon(IconlyLight.home),
            title: const Text("Accueil"),
            unSelectedColor: Colors.black,
            selectedColor: kPrimaryColor,
          ),
          BottomBarItem(
              icon: badges.Badge(
                  showBadge: DNotifPage.notifNumber == 0 ? false : true,
                  badgeContent: Text(
                    "${DNotifPage.notifNumber}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(IconlyLight.notification)),
              title: const Text("Notifications"),
              unSelectedColor: Colors.black,
              selectedColor: kPrimaryColor),
          BottomBarItem(
              icon: const Icon(IconlyLight.profile),
              title: const Text("Compte"),
              unSelectedColor: Colors.black,
              selectedColor: kPrimaryColor),
        ],
        currentIndex: currentPage,
        onTap: (selectedIndex) {
          setState(() {
            currentPage = selectedIndex;
          });
        },
      ),
    );
  }
}
