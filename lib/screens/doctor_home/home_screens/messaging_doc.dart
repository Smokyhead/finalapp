import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/home_screens/chat_doc.dart';
import 'package:finalapp/screens/doctor_home/home_screens/new_conv_doc.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class MessagingD extends StatefulWidget {
  const MessagingD({super.key});

  @override
  State<StatefulWidget> createState() => _MessagingDState();
}

class _MessagingDState extends State<MessagingD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const NewConversationD();
          }));
        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          leading: const Icon(IconlyBroken.chat),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Messages"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Conversations")
            .where('doctor', isEqualTo: Doctor.uid)
            .orderBy('lastActivity', descending: true)
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
                "Vous n'avez aucun message pour le moment",
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
                  separatorBuilder: (context, index) => const Divider(
                        height: 3,
                        color: kPrimaryColor,
                      ),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        color: data['seenByDoctor'] == false
                            ? kPrimaryLightColor
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          onTap: () {
                            FirestoreServices.getPatientById(data['patient']);
                            FirestoreServices.getConv(
                                data['patient'], data['doctor']);

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
                                      builder: (context) => const ChatPageD()));
                            });
                            FirebaseFirestore.instance
                                .collection('Conversations')
                                .doc(data['id'])
                                .update({'seenByDoctor': true});
                          },
                          tileColor: data['seenByDoctor'] == false
                              ? kPrimaryLightColor
                              : Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor:
                                    const Color.fromARGB(255, 203, 203, 203),
                                backgroundImage: const AssetImage(
                                    "assets/images/avatar.jpg"),
                                foregroundImage: data['patientImage'].isEmpty
                                    ? null
                                    : NetworkImage(data['patientImage']),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['patientFirstName']} ${data['patientLastName']}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                  Text(
                                    data['lastMessage'],
                                    style: const TextStyle(
                                        fontSize: 18, height: 2),
                                  ),
                                  Text(
                                    "Le ${data['date']} à ${data['time']}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: data['seenByDoctor'] == false
                              ? const CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 10,
                                )
                              : IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                              content: SizedBox(
                                                height: 128,
                                                child: Column(children: [
                                                  data['read'] == false
                                                      ? ListTile(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Conversations")
                                                                .doc(data['id'])
                                                                .update({
                                                              "seenByDoctor":
                                                                  true
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          title: const Text(
                                                              "Marquer comme lu"),
                                                        )
                                                      : ListTile(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Conversations")
                                                                .doc(data['id'])
                                                                .update({
                                                              "seenByDoctor":
                                                                  false
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          title: const Text(
                                                              "Marquer comme non lu"),
                                                        ),
                                                  const Divider(),
                                                  ListTile(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "Conversations")
                                                          .doc(data['id'])
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    title: const Text(
                                                      "Supprimer",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ]),
                                              ));
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    size: 32.5,
                                  ),
                                ),
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      content: SizedBox(
                                        height: 128,
                                        child: Column(children: [
                                          data['read'] == false
                                              ? ListTile(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Conversations")
                                                        .doc(data['id'])
                                                        .update({
                                                      "seenByDoctor": true
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  title: const Text(
                                                      "Marquer comme lu"),
                                                )
                                              : ListTile(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Conversations")
                                                        .doc(data['id'])
                                                        .update({
                                                      "seenByDoctor": false
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  title: const Text(
                                                      "Marquer comme non lu"),
                                                ),
                                          const Divider(),
                                          ListTile(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("Conversations")
                                                  .doc(data['id'])
                                                  .delete();
                                              Navigator.pop(context);
                                            },
                                            title: const Text(
                                              "Supprimer",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ]),
                                      ));
                                });
                          },
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
