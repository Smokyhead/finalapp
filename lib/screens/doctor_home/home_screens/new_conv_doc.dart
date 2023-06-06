import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/home_screens/chat_doc.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';

class NewConversationD extends StatefulWidget {
  const NewConversationD({super.key});

  @override
  State<StatefulWidget> createState() => _NewConversationDState();
}

class _NewConversationDState extends State<NewConversationD> {
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
          title: const Text("Nouvelle Discussion"),
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
                  separatorBuilder: (context, index) => const Divider(
                        height: 3,
                        color: kPrimaryColor,
                      ),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return ListTile(
                      onTap: () {
                        Conversation.id = "";
                        FirestoreServices.getPatientById(data['userUID']);
                        FirestoreServices.getConv(data['userUID'], Doctor.uid);
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
                          Text("${data['userEmail']}")
                        ],
                      ),
                      subtitle: Text(data['phone']),
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
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
