import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/appointment_page.dart';
import 'package:finalapp/screens/doctor_home/home_screens/chat_doc.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class DTodayConsultationsList extends StatefulWidget {
  const DTodayConsultationsList({super.key});

  @override
  State<StatefulWidget> createState() => _DTodayConsultationsListState();
}

class _DTodayConsultationsListState extends State<DTodayConsultationsList> {
  final String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final DateTime dateTime = DateTime.now();
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            )),
            elevation: 5,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: const Text("Rendez-vous d'aujourd'hui"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Appointments")
                .where('isApproved', isEqualTo: true)
                .where('doctorId', isEqualTo: Doctor.uid)
                .where('date', isEqualTo: today)
                .orderBy('dateTime', descending: false)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
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
                    "Vous n'avez aucun rendez-vous pour le moment",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final appointmentTime = data['dateTime'] as Timestamp;
                      final appointmentDateTime = appointmentTime.toDate();
                      final currentTime = DateTime.now();
                      if (appointmentDateTime.isBefore(currentTime)) {
                        FirebaseFirestore.instance
                            .collection("Appointments")
                            .doc(data["id"])
                            .update({"status": "passed"});
                      }
                      return Card(
                        elevation: 2.5,
                        color: const Color.fromARGB(255, 227, 239, 246),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          onTap: () {
                            toAppointPage(data['id']);
                          },
                          contentPadding: const EdgeInsets.all(5),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            backgroundImage:
                                const AssetImage("assets/images/avatar.jpg"),
                            foregroundImage: data['patientImageUrl'].isEmpty
                                ? null
                                : NetworkImage(data['patientImageUrl']),
                          ),
                          title: Text(
                            "${data['patientFirstName']} ${data['patientLastName']}",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Date: ${data['date']}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Heure: ${data['time']}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                data['status'] == 'upcoming'
                                    ? CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.red,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext build) {
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
                                                                Radius.circular(
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              30)),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            FirestoreServices
                                                                .getPres(Appointment
                                                                    .prescriptionId);
                                                            FirestoreServices
                                                                .getBill(
                                                                    Appointment
                                                                        .billId);
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Prescriptions")
                                                                .doc(
                                                                    Prescription
                                                                        .id)
                                                                .delete();
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Bills")
                                                                .doc(Bill.id)
                                                                .delete();
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Appointments")
                                                                .doc(data['id'])
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
                                      )
                                    : const SizedBox.shrink(),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.green,
                                  child: IconButton(
                                    onPressed: () {
                                      final Uri url = Uri(
                                          scheme: 'tel',
                                          path: data['patientPhone']);
                                      launchUrl(url);
                                    },
                                    icon: const Icon(
                                      IconlyBold.call,
                                      size: 15,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: kPrimaryColor,
                                  child: IconButton(
                                    onPressed: () {
                                      FirestoreServices.getPatientById(
                                          data['patientId']);
                                      Conversation.id = "";
                                      FirestoreServices.getConv(
                                          data['patientId'], data['doctorId']);
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
                                                    const ChatPageD()));
                                      });
                                    },
                                    icon: const Icon(
                                      IconlyBold.send,
                                      size: 15,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ));
  }

  void toAppointPage(String id) {
    FirestoreServices.getappointById(id);
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AppointPage()));
    });
  }
}
