import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/screens/admin/home/consultations.dart';
import 'package:finalapp/screens/admin/home/doctors_list_admin.dart';
import 'package:finalapp/screens/admin/home/holidays.dart';
import 'package:finalapp/screens/admin/home/patients_list_admin.dart';
import 'package:finalapp/screens/admin/home/services.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:badges/badges.dart' as badges;

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<StatefulWidget> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 10,
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: const Text(
            "ADMIN",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Scaffold();
                  }));
                },
                icon: const badges.Badge(
                    badgeContent: Text(
                      "0",
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(IconlyBold.notification))),
            IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  FirestoreServices.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WelcomeScreen();
                  }));
                },
                icon: const Icon(IconlyBold.logout))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Button(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Doctors();
                }));
              },
              text: "Docteurs",
              icon: const Icon(Icons.medical_information_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Patients();
                }));
              },
              text: "Patients",
              icon: const Icon(Icons.person),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Consultations();
                }));
              },
              text: "Consultations",
              icon: const Icon(Icons.punch_clock_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const ManageServices();
                }));
              },
              text: "Services",
              icon: const Icon(Icons.medical_services_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Holidays();
                }));
              },
              text: "Jours fériés",
              icon: const Icon(Icons.access_time),
            ),
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function() onPressed;
  const Button(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(30),
      width: size.width * 0.9,
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(10),
          backgroundColor: MaterialStateProperty.all(kPrimaryColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              icon
            ],
          ),
        ),
      ),
    );
  }
}
