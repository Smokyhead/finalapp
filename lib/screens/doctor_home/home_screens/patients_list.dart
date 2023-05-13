// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<StatefulWidget> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  bool typing = false;
  TextEditingController? searchCont = TextEditingController();
  String name = "";

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
          title: typing
              ? SizedBox(
                  height: 35,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    cursorColor: Colors.black,
                    controller: searchCont,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 15),
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        hintText: 'Rechercher',
                        hintStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                )
              : const Text("Mes Patients"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(typing ? Icons.done : IconlyBold.search),
                onPressed: () {
                  setState(() {
                    typing = !typing;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Patients')
            .where('doctors', arrayContains: Doctor.uid)
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
                    if (name.isEmpty) {
                      return Card(
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
                                      builder: (context) => const Scaffold()));
                            });
                          },
                          contentPadding: const EdgeInsets.all(10),
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
                          title: Text(
                            "${data['firstName']} ${data['lastName']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            data['phone'],
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  IconlyBold.call,
                                  size: 20,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (data['firstName']
                            .toString()
                            .toLowerCase()
                            .contains(name.toLowerCase()) ||
                        data['lastName']
                            .toString()
                            .toLowerCase()
                            .contains(name.toLowerCase())) {
                      return Card(
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
                                      builder: (context) => const Scaffold()));
                            });
                          },
                          contentPadding: const EdgeInsets.all(10),
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
                          title: Text(
                            "${data['firstName']} ${data['lastName']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            data['phone'],
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  IconlyBold.call,
                                  size: 20,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            );
          }
        },
      ),
    );
  }
}
