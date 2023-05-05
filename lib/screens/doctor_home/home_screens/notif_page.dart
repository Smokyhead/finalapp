import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                )
              : ListView.separated(
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
        },
      ),
    );
  }
}
