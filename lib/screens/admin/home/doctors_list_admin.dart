// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class Doctors extends StatefulWidget {
  const Doctors({super.key});

  @override
  State<StatefulWidget> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  bool typing = false;
  TextEditingController? searchCont = TextEditingController();
  String name = "";

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
          elevation: 5,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: typing
              ? SizedBox(
                  height: 35,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    cursorColor: Colors.black,
                    controller: searchCont,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 15),
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        hintText: 'Recherche',
                        hintStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                )
              : const Text("Docteurs"),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 15),
              icon: Icon(typing ? Icons.done : IconlyLight.search),
              onPressed: () {
                setState(() {
                  typing = !typing;
                });
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Doctors").snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (name.isEmpty) {
                          return Card(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              elevation: 2.5,
                              color: const Color.fromARGB(255, 243, 243, 243),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data['firstName']} ${data['lastName']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "${data['phone']}",
                                      style: const TextStyle(height: 1.2),
                                    ),
                                    Text(
                                      "${data['userEmail']}",
                                      style: const TextStyle(height: 1.2),
                                    )
                                  ],
                                ),
                                subtitle: Text(data['service'],
                                    style: const TextStyle(height: 1.2)),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color.fromARGB(255, 203, 203, 203),
                                  backgroundImage: const AssetImage(
                                      "assets/images/avatar.jpg"),
                                  foregroundImage: data['imageUrl'].isEmpty
                                      ? null
                                      : NetworkImage(data['imageUrl']),
                                ),
                                trailing: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.green,
                                    child: IconButton(
                                      onPressed: () {
                                        final Uri url = Uri(
                                            scheme: 'tel', path: data['phone']);
                                        launchUrl(url);
                                      },
                                      icon: const Icon(
                                        Icons.call,
                                        size: 20,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ));
                        } else if (data['lastName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['firstName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['service']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['email']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) ||
                            data['phone']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase())) {
                          return Card(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              elevation: 2.5,
                              color: const Color.fromARGB(255, 243, 243, 243),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
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
                                    Text("${data['phone']}"),
                                    Text("${data['userEmail']}")
                                  ],
                                ),
                                subtitle: Text(data['service']),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color.fromARGB(255, 203, 203, 203),
                                  backgroundImage: const AssetImage(
                                      "assets/images/avatar.jpg"),
                                  foregroundImage: data['imageUrl'].isEmpty
                                      ? null
                                      : NetworkImage(data['imageUrl']),
                                ),
                                trailing: CircleAvatar(
                                  radius: 17.5,
                                  backgroundColor: Colors.green,
                                  child: IconButton(
                                    onPressed: () {
                                      final Uri url = Uri(
                                          scheme: 'tel', path: data['phone']);
                                      launchUrl(url);
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      size: 17.5,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ));
                        }
                        return Container();
                      }),
                );
        },
      ),
    );
  }
}
