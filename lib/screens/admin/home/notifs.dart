import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;

class Notifs extends StatefulWidget {
  const Notifs({super.key});

  @override
  State<StatefulWidget> createState() => _NotifsState();
}

class _NotifsState extends State<Notifs> {
  String message1 =
      "Votre compte a été approuvé,\nVous pouvez maintenant utilisier l'application.";
  String message2 =
      "Votre compte a été supprimé,\nVous n'êtes pas inscrit à la clinique.";
  Future sendEmail({
    required String result,
    required String toEmail,
    required String toName,
    required String message,
  }) async {
    const serviceId = 'clin';
    const templateId = 'template_grnmjwi';
    const userId = 'fFvfsdhiiJ0709RVg';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'Content_Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'result': result,
            'to_email': toEmail,
            'to_name': toName,
            'message': message
          }
        }));
    // ignore: avoid_print
    print(response.body);
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
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Notifications"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Doctors")
            .where('isApproved', isEqualTo: false)
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
                "Vous n'avez aucune notification pour le moment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  return ListTile(
                    onTap: () async {},
                    isThreeLine: true,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 203, 203, 203),
                      backgroundImage:
                          const AssetImage("assets/images/avatar.jpg"),
                      foregroundImage: data['imageUrl'].isEmpty
                          ? null
                          : NetworkImage(data['imageUrl']),
                    ),
                    title: Text(
                      "${data['firstName']} ${data['lastName']}",
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${data['service']}\n${data['phone']}",
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    trailing: SizedBox(
                      height: 50,
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Doctors')
                                    .doc(data['userUID'])
                                    .update({'isApproved': true});
                                sendEmail(
                                    result: 'approuvé',
                                    toEmail: data['userEmail'],
                                    toName:
                                        '${data['firstName']} ${data['lastName']}',
                                    message: message1);
                              },
                              icon: const Icon(
                                Icons.check,
                                size: 15,
                              ),
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () async {
                                final UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: data['userEmail'],
                                  password: data['password'],
                                );
                                final User user = userCredential.user!;
                                await user.delete();
                                FirebaseFirestore.instance
                                    .collection('Doctors')
                                    .doc(data['userUID'])
                                    .delete();
                                sendEmail(
                                    result: 'supprimé',
                                    toEmail: data['userEmail'],
                                    toName:
                                        '${data['firstName']} ${data['lastName']}',
                                    message: message2);
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: Admin.email,
                                  password: Admin.password,
                                );
                              },
                              icon: const Icon(
                                IconlyBold.delete,
                                size: 15,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
