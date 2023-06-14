// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/doctor_profile.dart';
import 'package:finalapp/screens/patient_home/home_screens/chat.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsList extends StatefulWidget {
  const DoctorsList({super.key});

  @override
  State<StatefulWidget> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
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
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Mes Docteurs"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Doctors')
            .where('patients', arrayContains: Patient.uid)
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
                "Vous n'avez aucun docteur pour le moment",
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
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 243, 243, 243),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
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
                        contentPadding: const EdgeInsets.all(10),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['firstName']} ${data['lastName']}",
                              style: const TextStyle(
                                  height: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text("${data['phone']}")
                          ],
                        ),
                        subtitle: Text(data['service']),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 203, 203, 203),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['imageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['imageUrl']),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                  radius: 20,
                                  backgroundColor: kPrimaryColor,
                                  child: IconButton(
                                      onPressed: () {
                                        Conversation.id = "";
                                        FirestoreServices.getDoctorById(
                                            data['userUID']);
                                        FirestoreServices.getConv(
                                            data['userUID'], Doctor.uid);
                                        showDialog(
                                            context: (context),
                                            builder: (BuildContext context) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: kPrimaryColor,
                                                ),
                                              );
                                            });
                                        Timer(const Duration(seconds: 1), () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChatPage()));
                                        });
                                      },
                                      icon: const Icon(
                                        IconlyBold.send,
                                        size: 20,
                                      ))),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.green,
                                child: IconButton(
                                  onPressed: () async {
                                    final Uri url =
                                        Uri(scheme: 'tel', path: data['phone']);
                                    launchUrl(url);
                                  },
                                  icon: const Icon(
                                    IconlyBold.call,
                                    size: 20,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
