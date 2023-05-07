import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  static int number = 0;
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
            .where('isApproved', isEqualTo: true)
            .where('patientId', isEqualTo: Patient.uid)
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
          number = snapshots.data!.docs.length;
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
                    itemCount: number,
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
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: const Text(
                          "Notification de confirmation",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Votre demande pour rendez-vous avec Dr ${data['doctorFirstName']} ${data['doctorLastName']} le ${data['date']} à ${data['time']} est confirmée",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
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
