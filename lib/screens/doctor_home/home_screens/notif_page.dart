import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uuid/uuid.dart';

class DNotifPage extends StatefulWidget {
  const DNotifPage({super.key});

  static int notifNumber = 0;

  @override
  State<StatefulWidget> createState() => _DNotifPageState();
}

class _DNotifPageState extends State<DNotifPage> {
  final DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Notifications"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where('isApproved', isEqualTo: false)
            .where('doctorId', isEqualTo: Doctor.uid)
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
          DNotifPage.notifNumber = snapshots.data!.docs.length;
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
            return SizedBox(
                height: 170,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 203, 203, 203),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                        title: Text(
                          "${data['patientFirstName']} ${data['patientLastName']}",
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Le: ${data['date']}\nà: ${data['time']}",
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
                                        .collection("Appointments")
                                        .doc(data['id'])
                                        .update({"isApproved": true});
                                    FirebaseFirestore.instance
                                        .collection('Doctors')
                                        .doc(Doctor.uid)
                                        .update({
                                      'patients': FieldValue.arrayUnion(
                                          [data['patientId']])
                                    });
                                    FirebaseFirestore.instance
                                        .collection('Patients')
                                        .doc(data['patientId'])
                                        .update({
                                      'doctors':
                                          FieldValue.arrayUnion([Doctor.uid])
                                    });
                                    final uuid1 = const Uuid().v4();
                                    FirebaseFirestore.instance
                                        .collection('Notifications')
                                        .doc(uuid1)
                                        .set({
                                      'read': false,
                                      'patient': data['patientId'],
                                      'doctor': data['doctorId'],
                                      'doctorImage': data['doctorImageUrl'],
                                      'title': "Confirmation",
                                      'content':
                                          "Votre demande pour rendez-vous avec Dr ${data['doctorFirstName']} ${data['doctorLastName']} le ${data['date']} à ${data['time']} est confirmée",
                                      'dateTime': dateTime,
                                      'appointmentId': data['id']
                                    });
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
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Appointments")
                                        .doc(data['id'])
                                        .delete();
                                    final uuid2 = const Uuid().v4();
                                    FirebaseFirestore.instance
                                        .collection('Notifications')
                                        .doc(uuid2)
                                        .set({
                                      'read': false,
                                      'patient': data['patientId'],
                                      'doctor': data['doctorId'],
                                      'doctorImage': data['doctorImageUrl'],
                                      'title': "Refus",
                                      'content':
                                          "Votre demande pour rendez-vous avec Dr ${data['doctorFirstName']} ${data['doctorLastName']} le ${data['date']} à ${data['time']} est refusée",
                                      'dateTime': dateTime,
                                      'appointmentId': data['id']
                                    });
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
                    }));
          }
        },
      ),
    );
  }
}
