// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/description_model.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AppointPage extends StatefulWidget {
  const AppointPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppointPageState();
}

class _AppointPageState extends State<AppointPage> {
  TextEditingController myController = TextEditingController();
  bool typing = false;
  String uuid = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Consultation"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.25,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryLightColor,
                    spreadRadius: 10,
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(250, 80),
                    bottomRight: Radius.elliptical(250, 80)),
                gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryLightColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Appointment.doctorImage.isEmpty
                        ? null
                        : NetworkImage(Appointment.doctorImage),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${Appointment.doctorFirstName} ${Appointment.doctorLastName}",
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.call,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        Appointment.doctorPhone,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: TextButton.icon(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        onPressed: () async {
                          final Uri url = Uri(
                              scheme: 'tel', path: Appointment.patientPhone);
                          launchUrl(url);
                        },
                        icon: const Icon(
                          IconlyBold.call,
                          size: 18,
                        ),
                        label: const Text('Appeler')),
                  )
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  const Icon(
                    IconlyLight.time_circle,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Appointment.time,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  const Icon(
                    IconlyLight.calendar,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Appointment.date,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 60,
              width: 260,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(
                        style: BorderStyle.solid, color: kPrimaryColor)),
                    elevation: MaterialStateProperty.all(6),
                    backgroundColor:
                        MaterialStateProperty.all(kPrimaryLightColor),
                    foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  child: const Text(
                    "Retour",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      height: 150,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
