import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<StatefulWidget> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  TextEditingController cont = TextEditingController();
  String uuid = "";
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
          title: const Text("Services"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ajouter service",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldContainer(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: "Nom de service",
                          border: InputBorder.none,
                        ),
                        controller: cont,
                      ),
                    ),
                    SizedBox(
                        height: 50,
                        width: 70,
                        child: TextButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(6),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            foregroundColor:
                                MaterialStateProperty.all(kPrimaryLightColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            if (cont.text == "") {
                              showAlert();
                            } else {
                              uuid = const Uuid().v4();
                              FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc(uuid)
                                  .set({'id': uuid, 'name': cont.text.trim()});
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
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        content: Text(
                                          "Service ajouté.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor),
                                        ),
                                      );
                                    });
                              });

                              Timer(const Duration(seconds: 2), () {
                                Navigator.pop(context);
                                setState(() {
                                  cont.clear();
                                });
                              });
                            }
                          },
                          child: const Text(
                            "Valider",
                            style: TextStyle(fontSize: 14),
                          ),
                        )),
                  ],
                ),
                const Divider(
                  height: 25,
                ),
                const Text(
                  "Services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Services')
                      .orderBy('name')
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
                          "Pas de service à afficher",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 176, 127, 127)),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return ListBody(
                        children: snapshots.data!.docs.map((item) {
                          var data = item.data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(
                                data['name'],
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              )),
                              const Divider(
                                thickness: 1,
                                color: Colors.black38,
                              )
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ]),
        ),
      ),
    );
  }

  void showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "OOPS!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: const Text("Veillez saisir vos données"),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.7,
      height: 50,
      decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPrimaryColor)),
      child: child,
    );
  }
}
