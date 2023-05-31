// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/home_screens/account_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/consultations_list_doctor.dart';
import 'package:finalapp/screens/doctor_home/home_screens/patient_profile.dart';
import 'package:finalapp/screens/doctor_home/home_screens/patients_list.dart';
import 'package:finalapp/screens/doctor_home/home_screens/today_appointments.dart';
import 'package:finalapp/screens/patient_home/widgets/consultation_card.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key});
  final String today = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.2 - 40,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height * 0.2 - 40,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 41, 41, 41),
                            spreadRadius: 0.005,
                            blurRadius: 5,
                          )
                        ],
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30, left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Bienvenue",
                                  style: TextStyle(
                                      fontSize: 20, color: kPrimaryLightColor),
                                ),
                                Text(
                                  "Dr ${Doctor.firstName} ${Doctor.lastName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 27.5,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 41, 41, 41),
                                  spreadRadius: 0.005,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            margin: const EdgeInsets.only(bottom: 20, top: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 50,
                              backgroundImage:
                                  const AssetImage("assets/images/avatar.jpg"),
                              foregroundImage: Doctor.imageUrl.isEmpty
                                  ? null
                                  : NetworkImage(Doctor.imageUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Consultations d'aujourd'hui",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const DTodayConsultationsList();
                            }));
                          },
                          icon: const Icon(
                            IconlyBold.arrow_right_circle,
                            size: 33,
                            color: Color.fromARGB(255, 11, 45, 61),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Appointments")
                        .where('isApproved', isEqualTo: true)
                        .where('status', isEqualTo: 'upcoming')
                        .where('doctorId', isEqualTo: Doctor.uid)
                        .where('date', isEqualTo: today)
                        .orderBy('dateTime', descending: false)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      }
                      final docs = snapshots.data?.docs;
                      if (docs == null || docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Vous n'avez aucune consultation pour le moment",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 170,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final appointmentTime =
                                  data['dateTime'] as Timestamp;
                              final appointmentDateTime =
                                  appointmentTime.toDate();
                              final currentTime = DateTime.now();
                              if (appointmentDateTime.isBefore(currentTime)) {
                                FirebaseFirestore.instance
                                    .collection("Appointments")
                                    .doc(data["id"])
                                    .update({"status": "passed"});
                              }
                              return ConsultationCard(
                                imageUrl: data['patientImageUrl'],
                                firstName: data['patientFirstName'],
                                date: data['date'],
                                time: data['time'],
                                lastName: data['patientLastName'],
                                doctorPhone: data['doctorPhone'],
                                doctorid: data['doctorId'],
                                id: data['id'],
                                patientPhone: data['patientPhone'],
                                patientid: data['patientId'],
                                role: 'patient',
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Consulter vos rendez-vous",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const DConsultationsList();
                            }));
                          },
                          icon: const Icon(
                            IconlyBold.arrow_right_circle,
                            size: 33,
                            color: Color.fromARGB(255, 11, 45, 61),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mes Services",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const AccountPage();
                            }));
                          },
                          icon: const Icon(
                            IconlyBold.arrow_right_circle,
                            size: 33,
                            color: Color.fromARGB(255, 11, 45, 61),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                        spacing: 5,
                        children: Doctor.services
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mes Patients",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const PatientsList();
                            }));
                          },
                          icon: const Icon(
                            IconlyBold.arrow_right_circle,
                            size: 33,
                            color: Color.fromARGB(255, 11, 45, 61),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Patients")
                        .where('doctors', arrayContains: Doctor.uid)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      }
                      final docs = snapshots.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Vous n'avez aucun patient pour le moment",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 145,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var data =
                                  docs[index].data() as Map<String, dynamic>;
                              return ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () {
                                  final id = data['userUID'];
                                  print(id);
                                  FirestoreServices.getPatientById(id);
                                  FirestoreServices.getObs(
                                      data['userUID'], Doctor.uid);
                                  showDialog(
                                      context: (context),
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                        );
                                      });
                                  Timer(const Duration(seconds: 1), () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PatientProfile()));
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 0.005,
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 50,
                                        backgroundImage: const AssetImage(
                                            "assets/images/avatar.jpg"),
                                        foregroundImage: data['imageUrl']
                                                .isEmpty
                                            ? null
                                            : NetworkImage(data['imageUrl']),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data['firstName'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      data['lastName'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
