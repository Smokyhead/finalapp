import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/home_screens/chat.dart';
import 'package:finalapp/screens/patient_home/home_screens/new_dis.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<StatefulWidget> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const NewConversation();
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
            .where('patient', isEqualTo: Patient.uid)
            .orderBy('lastActivity', descending: false)
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
                          color: data['seenByPatient'] == false
                              ? kPrimaryLightColor
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            onTap: () {
                              FirestoreServices.getDoctorById(data['doctor']);
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
                                        builder: (context) =>
                                            const ChatPage()));
                              });
                              FirebaseFirestore.instance
                                  .collection('Conversations')
                                  .doc(data['id'])
                                  .update({'seenByPatient': true});
                            },
                            tileColor: data['seenByPatient'] == false
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
                                  foregroundImage: data['doctorImage'].isEmpty
                                      ? null
                                      : NetworkImage(data['doctorImage']),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dr ${data['doctorFirstName']} ${data['doctorLastName']}",
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
                            trailing: data['seenByPatient'] == false
                                ? const CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    radius: 10,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ));
                  }),
            );
          }
        },
      ),
    );
  }
}
