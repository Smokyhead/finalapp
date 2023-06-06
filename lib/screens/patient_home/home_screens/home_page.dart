// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/appointment_page_p.dart';
import 'package:finalapp/screens/patient_home/doctor_profile.dart';
import 'package:finalapp/screens/patient_home/home_screens/consultations_list.dart';
import 'package:finalapp/screens/patient_home/home_screens/doctors_list.dart';
import 'package:finalapp/screens/patient_home/home_screens/today_appointments_patient.dart';
import 'package:finalapp/screens/patient_home/widgets/consultation_card.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime dateTime = DateTime.now();
  final String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
      ),
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
                                  "${Patient.firstName} ${Patient.lastName}",
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
                              foregroundImage: Patient.imageUrl.isEmpty
                                  ? null
                                  : NetworkImage(Patient.imageUrl),
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
                        "Rendez-vous d'aujourd'hui",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const PTodayConsultationsList();
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
                        .where('patientId', isEqualTo: Patient.uid)
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
                            "Vous n'avez aucun rendez-vous aujourd'hui",
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
                                imageUrl: data['doctorImageUrl'],
                                firstName: data['doctorFirstName'],
                                date: data['date'],
                                time: data['time'],
                                lastName: data['doctorLastName'],
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
                    height: 15,
                  ),
                  Container(
                    width: size.width - 50,
                    height: 0.5,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Rendez-vous Prochain",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Appointments")
                          .where('isApproved', isEqualTo: true)
                          .where('patientId', isEqualTo: Patient.uid)
                          .where('status', isEqualTo: 'upcoming')
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
                              "Vous n'avez aucun rendez-vous à venir pour le moment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          final doc = snapshots.data?.docs.first;
                          final data = doc!.data() as Map<String, dynamic>;
                          return SizedBox(
                            height: 100,
                            width: size.width * 0.95,
                            child: Card(
                                elevation: 2.5,
                                color: const Color.fromARGB(255, 227, 239, 246),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () {
                                    FirestoreServices.getappointById(
                                        data['id']);
                                    showDialog(
                                        context: (context),
                                        builder: (BuildContext context) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: kPrimaryColor,
                                            ),
                                          );
                                        });
                                    Timer(const Duration(seconds: 2), () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AppointPage()));
                                    });
                                  },
                                  contentPadding: const EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundImage: const AssetImage(
                                        "assets/images/avatar.jpg"),
                                    foregroundImage: data['doctorImageUrl']
                                            .isEmpty
                                        ? null
                                        : NetworkImage(data['doctorImageUrl']),
                                  ),
                                  title: Text(
                                    "${data['doctorFirstName']} ${data['doctorLastName']}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Date: ${data['date']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Heure: ${data['time']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext build) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Avertissement!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30,
                                                            color: Colors.red),
                                                      ),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      content: const Text(
                                                          "vous êtes sur le point de supprimer un rendez-vous!\nvoulez-vous vraiment la supprimer?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          kPrimaryColor),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30)),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Annuler")),
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30)),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Appointments")
                                                                  .doc(data[
                                                                      'id'])
                                                                  .delete();
                                                              final uuid =
                                                                  const Uuid()
                                                                      .v4();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Notifications')
                                                                  .doc(uuid)
                                                                  .set({
                                                                'read': false,
                                                                'patient': data[
                                                                    'patientId'],
                                                                'doctor': data[
                                                                    'doctorId'],
                                                                'title':
                                                                    "Annulation",
                                                                'content':
                                                                    "Votre rendez-vous avec Dr $data['doctorFirstName'] $data['doctorLaststName'] le $data['date'] à $data['time'] est annulée",
                                                                'dateTime':
                                                                    dateTime,
                                                                'appointmentId':
                                                                    data['id'],
                                                                'id': uuid
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Supprimer"))
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              IconlyBold.delete,
                                              size: 15,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.green,
                                          child: IconButton(
                                            onPressed: () {
                                              final Uri url = Uri(
                                                  scheme: 'tel',
                                                  path: data['doctorPhone']);
                                              launchUrl(url);
                                            },
                                            icon: const Icon(
                                              IconlyBold.call,
                                              size: 15,
                                            ),
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width - 50,
                    height: 0.5,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 15,
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
                              return const ConsultationsList();
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
                    height: 15,
                  ),
                  Container(
                    width: size.width - 50,
                    height: 0.5,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mes Docteurs",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const DoctorsList();
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
                        .collection("Doctors")
                        .where('patients', arrayContains: Patient.uid)
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
                            "Vous n'avez aucun docteur pour le moment",
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
                                  FirestoreServices.getDoctorById(id);
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
                                                const DoctorProfile()));
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
