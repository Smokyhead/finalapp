import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/home_screens/chat.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';

class NewConversation extends StatefulWidget {
  const NewConversation({super.key});

  @override
  State<StatefulWidget> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> {
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
                        FirestoreServices.getDoctorById(data['userUID']);
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
                                  builder: (context) => const ChatPage()));
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
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
