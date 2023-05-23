import 'package:finalapp/constants.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<StatefulWidget> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  FirestoreServices.signOut();
                },
                icon: const Icon(IconlyBold.logout))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Button(
              onPressed: () {},
              text: "Liste des docteurs",
              icon: const Icon(Icons.medical_information_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {},
              text: "Liste des patients",
              icon: const Icon(Icons.person),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {},
              text: "Liste des consultations",
              icon: const Icon(Icons.punch_clock_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {},
              text: "Ajouter service",
              icon: const Icon(Icons.medical_services_outlined),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () {},
              text: "Ajouter jour férier",
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
  final Function onPressed;
  final String text;
  const Button(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.icon});

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
        onPressed: onPressed(),
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
