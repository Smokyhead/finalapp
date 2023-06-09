// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/patient_home/home_screens/doctor.dart';
import 'package:finalapp/screens/patient_home/widgets/appointment.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          elevation: 5,
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
                        hintText: 'Recherche',
                        hintStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                )
              : const Text("Recherche"),
          leading: IconButton(
            icon: Icon(typing ? Icons.done : IconlyLight.search),
            onPressed: () {
              setState(() {
                typing = !typing;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Doctors").snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;

                        if (name.isEmpty) {
                          return Card(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                                              const DoctorProfileSearch()));
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
                                backgroundImage: const AssetImage(
                                    "assets/images/avatar.jpg"),
                                foregroundImage: data['imageUrl'].isEmpty
                                    ? null
                                    : NetworkImage(
                                        data['imageUrl'],
                                      ),
                              ),
                              trailing: TextButton(
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
                                                  const AppointmentPage()));
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            style: BorderStyle.solid,
                                            color: kPrimaryColor)),
                                    elevation: MaterialStateProperty.all(6),
                                    backgroundColor: MaterialStateProperty.all(
                                        kPrimaryLightColor),
                                    foregroundColor: MaterialStateProperty.all(
                                        kPrimaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                  child: const Text("Reserver")),
                            ),
                          );
                        } else if (data['lastName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['firstName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['service']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['phone']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase())) {
                          return Card(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                                              const DoctorProfileSearch()));
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
                                backgroundImage: const AssetImage(
                                    "assets/images/avatar.jpg"),
                                foregroundImage: data['imageUrl'].isEmpty
                                    ? null
                                    : NetworkImage(data['imageUrl']),
                              ),
                              trailing: TextButton(
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
                                                  const AppointmentPage()));
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            style: BorderStyle.solid,
                                            color: kPrimaryColor)),
                                    elevation: MaterialStateProperty.all(6),
                                    backgroundColor: MaterialStateProperty.all(
                                        kPrimaryLightColor),
                                    foregroundColor: MaterialStateProperty.all(
                                        kPrimaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                  child: const Text("Reserver")),
                            ),
                          );
                        }
                        return Container();
                      }),
                );
        },
      ),
    );
  }
}
