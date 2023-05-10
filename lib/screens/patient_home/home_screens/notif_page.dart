import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:timeago/timeago.dart' as timeago;

class PNotifPage extends StatefulWidget {
  const PNotifPage({super.key});

  @override
  State<StatefulWidget> createState() => _PNotifPageState();
}

class _PNotifPageState extends State<PNotifPage> {
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
          leading: const Icon(IconlyBroken.notification),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Notifications"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Notifications")
            .where('patient', isEqualTo: Patient.uid)
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Card(
                      elevation: 2.5,
                      color: data['read'] == false
                          ? kPrimaryLightColor
                          : const Color.fromARGB(255, 243, 243, 243),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
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
                                        ListTile(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("Notifications")
                                                .doc(data['id'])
                                                .update({"read": true});
                                            Navigator.pop(context);
                                          },
                                          title: const Text("Marquer comme lu"),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("Notifications")
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
                        contentPadding: const EdgeInsets.all(10),
                        isThreeLine: true,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 203, 203, 203),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImage'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImage']),
                        ),
                        title: Text(
                          data['title'],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['content'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              timeago.format(data['dateTime'].toDate(),
                                  locale: 'en_short'),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
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
                                          ListTile(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("Notifications")
                                                  .doc(data['id'])
                                                  .update({"read": true});
                                              Navigator.pop(context);
                                            },
                                            title:
                                                const Text("Marquer comme lu"),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("Notifications")
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
                          icon: const Icon(
                            Icons.more_vert,
                            size: 32.5,
                          ),
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
