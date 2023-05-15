import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppFeedback extends StatefulWidget {
  const AppFeedback({super.key});

  @override
  State<StatefulWidget> createState() => _AppFeedback();
}

class _AppFeedback extends State<AppFeedback> {
  final controller = TextEditingController();
  String uuid = "";
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 120),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 1),
                child: const Text(
                  'Aimez-vous l\'application?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const SizedBox(
                width: 300,
                child: Text(
                  'Donnez votre avis pour nous aider à ameliorer l\'application :',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldContainer(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tapez votre réponse ici",
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                  height: 55,
                  width: 150,
                  child: TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      child: const Text(
                        'Valider',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        uuid = const Uuid().v4();
                        FirebaseFirestore.instance
                            .collection('AppFeedbacks')
                            .doc(uuid)
                            .set({
                          'userId': Doctor.uid,
                          'userRole': 'doctor',
                          'feedback': controller.text.trim(),
                          'dateTime': dateTime
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext build) {
                              return const AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                content: Text(
                                  "Votre feedback a était envoyée avec succés",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor),
                                ),
                              );
                            });
                        Timer(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      })),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 55,
                  width: 150,
                  child: TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      child: const Text(
                        'Retour',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }))
            ]),
      )),
    ));
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
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      height: 150,
      decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kPrimaryColor)),
      child: child,
    );
  }
}
