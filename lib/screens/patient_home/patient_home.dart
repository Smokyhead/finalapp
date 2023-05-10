import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/home_screens/account_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/home_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/notif_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:badges/badges.dart' as badges;

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
    PNotifPage(),
    AccountPage(),
  ];
  static int? nb;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Notifications')
        .where('read', isEqualTo: false)
        .where('patient', isEqualTo: Patient.uid)
        .snapshots()
        .listen((event) {
      int unreadCount = event.docs.length;
      nb = unreadCount;
    });
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: screens,
      ),
      bottomNavigationBar: StylishBottomBar(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        backgroundColor: kPrimaryLightColor,
        option: AnimatedBarOptions(
            iconStyle: IconStyle.animated,
            barAnimation: BarAnimation.blink,
            opacity: 0.8,
            backgroundColor: kPrimaryColor),
        items: [
          BottomBarItem(
            icon: const Icon(IconlyLight.home),
            title: const Text("Accueil"),
            unSelectedColor: Colors.black,
            selectedColor: kPrimaryColor,
          ),
          BottomBarItem(
            icon: const Icon(IconlyLight.search),
            title: const Text("Recherche"),
            unSelectedColor: Colors.black,
            selectedColor: kPrimaryColor,
          ),
          BottomBarItem(
              icon: badges.Badge(
                  showBadge: nb == 0 || nb == null ? false : true,
                  badgeContent: Text(
                    nb.toString(),
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
