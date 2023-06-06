// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/doctor_home/home_screens/chat_doc.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointPage extends StatefulWidget {
  const AppointPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppointPageState();
}

class _AppointPageState extends State<AppointPage> {
  bool pTyping = false;
  TextEditingController bill = TextEditingController();
  TextEditingController pres = TextEditingController();
  bool fTyping = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FirestoreServices.getPres(Appointment.prescriptionId);
    FirestoreServices.getBill(Appointment.billId);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Rendez-vous"),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  Conversation.id = "";
                  FirestoreServices.getConv(
                      Appointment.patientId, Appointment.doctorId);
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
              height: size.height * 0.25,
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
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Appointment.patientImage.isEmpty
                        ? null
                        : NetworkImage(Appointment.patientImage),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${Appointment.patientFirstName} ${Appointment.patientLastName}",
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
                        Appointment.patientPhone,
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
                          final Uri url = Uri(
                              scheme: 'tel', path: Appointment.patientPhone);
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
                    IconlyLight.time_circle,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Appointment.time,
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
                    Appointment.date,
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

            // ****************************
            // partie facture

            Padding(
                padding: const EdgeInsets.only(
                    right: 35, top: 10, bottom: 10, left: 35),
                child: fTyping == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              Bill.fee == 0
                                  ? "Ajouter facture"
                                  : "Modifer la facture",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: kPrimaryColor)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (Bill.fee != 0) {
                                    bill.text = Bill.fee.toString();
                                  }
                                  fTyping = !fTyping;
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
                                if (bill.text.isEmpty) {
                                  showAlert();
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Bills')
                                      .doc(Appointment.billId)
                                      .update({'fee': int.parse(bill.text)});
                                  setState(() {
                                    Bill.fee;
                                    fTyping = !fTyping;
                                  });
                                }
                              },
                              icon: const Icon(Icons.done)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  fTyping = !fTyping;
                                });
                              },
                              icon: const Icon(Icons.close))
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.money_rounded,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Facture",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 65, right: 10),
                    width: 80,
                    height: 40,
                    child: fTyping == false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, left: 50),
                            child: Text(
                              Bill.fee.toString(),
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 153, 12, 12)),
                            ),
                          )
                        : TextField(
                            style: const TextStyle(fontSize: 23),
                            decoration: const InputDecoration(
                              hintText: "00",
                              contentPadding: EdgeInsets.only(top: 5, left: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor)),
                            ),
                            cursorColor: Colors.black,
                            controller: bill,
                            keyboardType: TextInputType.number,
                          ),
                  ),
                  const Text("TND", style: TextStyle(fontSize: 20))
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),

            // ****************************
            // partie ordonnance

            Padding(
                padding: const EdgeInsets.only(
                    right: 35, top: 10, bottom: 10, left: 35),
                child: pTyping == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              Prescription.prescription == ''
                                  ? "Ajouter ordonnance"
                                  : "Modifer l'ordonnance",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: kPrimaryColor)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (Prescription.prescription != '') {
                                    pres.text = Prescription.prescription;
                                  }
                                  pTyping = !pTyping;
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
                                if (pres.text.isEmpty) {
                                  showAlert();
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Prescriptions')
                                      .doc(Appointment.prescriptionId)
                                      .update({'prescription': pres.text});
                                  setState(() {
                                    FirestoreServices.getPres(
                                        Appointment.prescriptionId);
                                    Prescription.prescription = pres.text;
                                    pTyping = !pTyping;
                                  });
                                }
                              },
                              icon: const Icon(Icons.done)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  pTyping = !pTyping;
                                });
                              },
                              icon: const Icon(Icons.close))
                        ],
                      )),
            Prescription.prescription == "" && pTyping == false
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
                      controller: pres,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Prescription.prescription == ""
                            ? "Tapez le contenu de l'ordonnance ICI"
                            : Prescription.prescription,
                      ),
                      readOnly: pTyping == false ? true : false,
                    ),
                  ),
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
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kPrimaryColor)),
      child: child,
    );
  }
}
