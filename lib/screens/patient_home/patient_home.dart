import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/home_screens/account_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/home_page.dart';
import 'package:finalapp/screens/patient_home/home_screens/messaging.dart';
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
    Messaging(),
    PNotifPage(),
    AccountPage(),
  ];
  Widget getNT() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Notifications")
            .where('patient', isEqualTo: Patient.uid)
            .where('read', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Text(
              "0",
              style: TextStyle(color: Colors.white),
            );
          } else {
            nbNot = snapshots.data!.docs.length;
            return Text(
              snapshots.data!.docs.length.toString(),
              style: const TextStyle(color: Colors.white),
            );
          }
        });
  }

  Widget getConv() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Conversations")
            .where('patient', isEqualTo: Patient.uid)
            .where('seenByPatient', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Text(
              "0",
              style: TextStyle(color: Colors.white),
            );
          } else {
            nbConv = snapshots.data!.docs.length;
            return Text(
              snapshots.data!.docs.length.toString(),
              style: const TextStyle(color: Colors.white),
            );
          }
        });
  }

  static int? nbNot;
  static int? nbConv;
  @override
  Widget build(BuildContext context) {
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
                showBadge: nbConv == 0 ? false : true,
                badgeContent: getConv(),
                child: const Icon(IconlyLight.chat)),
            title: const Text("Messages"),
            unSelectedColor: Colors.black,
            selectedColor: kPrimaryColor,
          ),
          BottomBarItem(
              icon: badges.Badge(
                  showBadge: nbNot == 0 ? false : true,
                  badgeContent: getNT(),
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
