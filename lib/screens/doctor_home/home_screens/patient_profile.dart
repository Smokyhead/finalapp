// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/observation_model.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/home_screens/chat_doc.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  State<StatefulWidget> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  TextEditingController myController = TextEditingController();
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    FirestoreServices.getObsbyId(Observation.id);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Profil du patient"),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  Conversation.id = "";
                  FirestoreServices.getConv(Patient.uid, Doctor.uid);
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatPageD()));
                  });
                },
                icon: const Icon(IconlyBold.send))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.35,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryLightColor,
                    spreadRadius: 10,
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(250, 80),
                    bottomRight: Radius.elliptical(250, 80)),
                gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryLightColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 90,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Patient.imageUrl.isEmpty
                        ? null
                        : NetworkImage(Patient.imageUrl),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    "${Patient.firstName} ${Patient.lastName}",
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.call,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        Patient.phone,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: TextButton.icon(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        onPressed: () async {
                          final Uri url =
                              Uri(scheme: 'tel', path: Patient.phone);
                          launchUrl(url);
                        },
                        icon: const Icon(
                          IconlyBold.call,
                          size: 18,
                        ),
                        label: const Text('Appeler')),
                  )
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  const Icon(
                    IconlyLight.message,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Patient.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  const Icon(
                    IconlyLight.calendar,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Patient.dob,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),

            // observation part ========================================

            Padding(
                padding: const EdgeInsets.only(
                    right: 35, top: 15, bottom: 10, left: 35),
                child: typing == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              Observation.observation == ''
                                  ? "Ajouter observation"
                                  : "Modifer l'observation",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: kPrimaryColor)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (Observation.observation != '') {
                                    myController.text = Observation.observation;
                                  }
                                  typing = !typing;
                                });
                              },
                              icon: const Icon(IconlyLight.edit)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (myController.text.isEmpty) {
                                  showAlert();
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Observations')
                                      .doc(Observation.id)
                                      .update(
                                          {'observation': myController.text});
                                  setState(() {
                                    FirestoreServices.getObsbyId(
                                        Observation.id);
                                    Observation.observation = myController.text;
                                    typing = !typing;
                                  });
                                }
                              },
                              icon: const Icon(Icons.done)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  typing = !typing;
                                });
                              },
                              icon: const Icon(Icons.close))
                        ],
                      )),
            Observation.observation == "" && typing == false
                ? const Center(
                    child: Text(
                      "Aucune ordonnance à afficher",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : TextFieldContainer(
                    child: TextField(
                      style: const TextStyle(fontSize: 20),
                      textCapitalization: TextCapitalization.sentences,
                      controller: myController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Observation.observation == ""
                            ? "Observation"
                            : Observation.observation,
                      ),
                      readOnly: typing == false ? true : false,
                    ),
                  ),

            // =========================================================

            const SizedBox(
              height: 25,
            ),
          ],
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
            content: const Text("Veillez remplir le champs vide."),
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
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      height: 150,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
