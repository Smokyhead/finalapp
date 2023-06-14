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

  Future<bool> checkObservationExists(String patientId, String doctorId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Observations')
        .where('patientId', isEqualTo: patientId)
        .where('doctorId', isEqualTo: doctorId)
        .where('observation', isEqualTo: '')
        .limit(1)
        .get();

    return snapshot.size > 0;
  }

  Future<void> createObservation(String patientId, String doctorId) async {
    final uuid = const Uuid().v4();
    FirebaseFirestore.instance.collection('Observations').doc(uuid).set({
      'id': uuid,
      'patientId': patientId,
      'doctorId': doctorId,
      'observation': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      DNotifPage.notifNumber;
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          leading: const Icon(IconlyBroken.notification),
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
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  final appointmentTime = data['dateTime'] as Timestamp;
                  final appointmentDateTime = appointmentTime.toDate();
                  final currentTime = DateTime.now();
                  if (appointmentDateTime.isBefore(currentTime)) {
                    FirebaseFirestore.instance.collection('Notifications').add({
                      'read': false,
                      'patient': data['patientId'],
                      'doctor': data['doctorId'],
                      'doctorImage': data['doctorImageUrl'],
                      'title': "Dotre demande n'est plus valable",
                      'content':
                          "Votre demande pour rendez-vous avec Dr ${data['doctorFirstName']} ${data['doctorLastName']} le ${data['date']} à ${data['time']} n'est plus valable et était supprimé",
                      'dateTime': dateTime,
                      'appointmentId': data['id'],
                    });
                    FirebaseFirestore.instance
                        .collection("Appointments")
                        .doc(data["id"])
                        .delete();
                  }
                  return ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 203, 203, 203),
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
                              onPressed: () async {
                                final uuid1 = const Uuid().v4();
                                final uuid3 = const Uuid().v4();
                                final uuid4 = const Uuid().v4();
                                FirebaseFirestore.instance
                                    .collection("Appointments")
                                    .doc(data['id'])
                                    .update({
                                  "isApproved": true,
                                  'prescriptionId': uuid4,
                                  'billId': uuid3
                                });
                                FirebaseFirestore.instance
                                    .collection('Doctors')
                                    .doc(Doctor.uid)
                                    .update({
                                  'patients': FieldValue.arrayUnion(
                                      [data['patientId']]),
                                });
                                FirebaseFirestore.instance
                                    .collection('Patients')
                                    .doc(data['patientId'])
                                    .update({
                                  'doctors': FieldValue.arrayUnion([Doctor.uid])
                                });
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
                                  'appointmentId': data['id'],
                                  'id': uuid1
                                });

                                FirebaseFirestore.instance
                                    .collection('Bills')
                                    .doc(uuid3)
                                    .set({
                                  'id': uuid3,
                                  'consultId': data['id'],
                                  'fee': 0,
                                });

                                FirebaseFirestore.instance
                                    .collection('Prescriptions')
                                    .doc(uuid4)
                                    .set({
                                  'id': uuid4,
                                  'consultId': data['id'],
                                  'prescription': "",
                                });

                                final exists = await checkObservationExists(
                                    data['patientId'], data['doctorId']);
                                if (!exists) {
                                  await createObservation(
                                      data['patientId'], data['doctorId']);
                                }
                                setState(() {
                                  DNotifPage.notifNumber;
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
                                  'appointmentId': data['id'],
                                  'id': uuid2
                                });
                                setState(() {
                                  DNotifPage.notifNumber;
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
                });
          }
        },
      ),
    );
  }
}
