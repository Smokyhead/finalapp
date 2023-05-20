import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/services.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<StatefulWidget> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  var myServices = Doctor.services;
  var list = Services.items;
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
          title: const Text("Mes services"),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: kPrimaryLightColor,
          elevation: 20,
          height: 70,
          child: TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(kPrimaryColor)),
            onPressed: () {
              if (myServices.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(Doctor.uid)
                    .update({'services': myServices});
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content:
                            Text("Vos services on été mis à jour avec succés."),
                      );
                    });
                Timer(const Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "OOPS!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content:
                            const Text('Veuillez choisir au moin un service.'),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
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
            },
            child: const Text(
              "Sauvegarder les modifications",
              style: TextStyle(fontSize: 18),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mes services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 236, 240, 244),
                  height: 250,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 1,
                    ),
                    itemCount: myServices.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(
                          myServices[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              const Color.fromARGB(255, 93, 79, 78),
                          child: IconButton(
                            onPressed: () {
                              myServices.remove(myServices[index]);
                              setState(() {
                                myServices;
                              });
                            },
                            icon: const Icon(
                              IconlyBold.delete,
                              size: 15,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Ajouter services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 236, 240, 244),
                  height: 500,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 1,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(
                          list[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              const Color.fromARGB(255, 129, 182, 65),
                          child: IconButton(
                            onPressed: () {
                              if (myServices.contains(list[index])) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        content: Text(
                                            "vous ne pouvez pas ajouter un service qui existe déjà."),
                                      );
                                    });
                                Timer(const Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                });
                              } else {
                                myServices.add(list[index]);
                                setState(() {
                                  myServices;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> selectedItems = [];

  void serviceChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemValue);
      } else {
        selectedItems.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void submit() {
    Navigator.pop(context, selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text(
          "Choisissez vos services:",
          style: TextStyle(color: kPrimaryColor),
        ),
        content: SingleChildScrollView(
            child: ListBody(
                children: widget.items
                    .map((item) => CheckboxListTile(
                        title: Text(item),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedItems.contains(item),
                        onChanged: (isChecked) =>
                            serviceChange(item, isChecked!)))
                    .toList())),
        actions: [
          TextButton(
            onPressed: submit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            child: const Text("Valider"),
          ),
          TextButton(
              onPressed: cancel,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              child: const Text("Annuler"))
        ]);
  }
}
