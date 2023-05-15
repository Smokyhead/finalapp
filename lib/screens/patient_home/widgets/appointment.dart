// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:uuid/uuid.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  static final dateContr = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  String formattedTime = "";
  String formattedDate = "";
  late DateTime dateTime;
  String uuid = "";
  bool isApproved = false;

  Future saveDataToFirestore() async {
    if (formattedDate.isEmpty || formattedTime.isEmpty) {
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
              content: const Text("Veuillez séléctionner le temps et la date."),
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
    } else {
      String date = DateFormat('yyyy-MM-dd').format(_selectedDate);
      dateTime = DateTime.parse("$date $formattedTime:00");
      print(dateTime);
      uuid = const Uuid().v4();
      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('Appointments')
          .where('doctorId', isEqualTo: Doctor.uid)
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: formattedTime)
          .where('isApproved', isEqualTo: true)
          .get();
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('Appointments')
          .where('patientId', isEqualTo: Patient.uid)
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: formattedTime)
          .where('isApproved', isEqualTo: true)
          .get();
      if (querySnapshot1.docs.isEmpty && querySnapshot2.docs.isEmpty) {
        FirebaseFirestore.instance.collection("Appointments").doc(uuid).set({
          "id": uuid,
          "doctorId": Doctor.uid,
          "doctorFirstName": Doctor.firstName,
          "doctorLastName": Doctor.lastName,
          "patientId": Patient.uid,
          "patientFirstName": Patient.firstName,
          "patientLastName": Patient.lastName,
          "date": formattedDate,
          "time": formattedTime,
          "isApproved": isApproved,
          "doctorImageUrl": Doctor.imageUrl,
          "patientImageUrl": Patient.imageUrl,
          "dateTime": dateTime,
          "status": "upcoming",
          "doctorPhone": Doctor.phone,
          "patientPhone": Patient.phone,
          "billId": "",
          "prescriptionId": ""
        });
        showDialog(
            context: (context),
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            });
        Timer(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Text(
                    "Votre demande pour rendez-vous a était envoyée avec succés",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                );
              });
          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
      } else {
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
                content: const Text(
                    "Le temps que vous avez choisi est déjà reservé,\nveuillez en choisir un autre."),
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
      uuid = "";
    }
  }

  @override
  void initState() {
    formattedDate = "";
    formattedTime = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.15,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryLightColor,
                    spreadRadius: 10,
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(250, 50),
                    bottomRight: Radius.elliptical(250, 50)),
                gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryLightColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: const Text(
                "Reservez Rendez-vous",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 60,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Doctor.imageUrl.isEmpty
                        ? null
                        : NetworkImage(Doctor.imageUrl),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Docteur:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${Doctor.firstName} ${Doctor.lastName}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Date:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(const BorderSide(
                                style: BorderStyle.solid,
                                color: kPrimaryColor)),
                            elevation: MaterialStateProperty.all(6),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryLightColor),
                            foregroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()),
                            );
                            print(formattedDate);
                          },
                          icon: const Icon(IconlyBold.calendar),
                          label: Text(
                            formattedDate.isEmpty
                                ? "jj/mm/aaaa"
                                : formattedDate,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Temps:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(const BorderSide(
                                style: BorderStyle.solid,
                                color: kPrimaryColor)),
                            elevation: MaterialStateProperty.all(6),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryLightColor),
                            foregroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => buildTimePicker()),
                            );
                          },
                          icon: const Icon(IconlyBold.time_circle),
                          label: Text(
                            formattedTime.isEmpty ? "hh:mm" : formattedTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  SizedBox(
                    height: 60,
                    width: 130,
                    child: TextButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(7),
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
                          print(
                              "Doctor id: ${Doctor.uid}\nPatient id: ${Patient.uid}\nAppointment date: $formattedDate\nAppointment time: $formattedTime");
                          saveDataToFirestore();
                        },
                        child: const Text(
                          "Envoyer",
                          style: TextStyle(fontSize: 22),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 60,
                    width: 130,
                    child: TextButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(7),
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
                        child: const Text(
                          "Annuler",
                          style: TextStyle(fontSize: 22),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimePicker() => Container(
        height: 350,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            const Text(
              "Sélectionner le temps du rendez-vous",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                minuteInterval: 15,
                use24hFormat: true,
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now()
                    .add(Duration(minutes: 15 - DateTime.now().minute % 15)),
                onDateTimeChanged: (value) => setState(() {
                  _selectedTime = value;
                  formattedTime = DateFormat('HH:mm').format(_selectedTime);
                }),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(
                    style: BorderStyle.solid, color: kPrimaryColor)),
                elevation: MaterialStateProperty.all(6),
                backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),
                foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              child: const Text("ok"),
            )
          ],
        ),
      );

  Widget bottomSheet() => Container(
        height: 350,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Sélectionner la date du rendez-vous",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              child: ScrollDatePicker(
                options: const DatePickerOptions(isLoop: false),
                selectedDate: _selectedDate,
                minimumDate: DateTime.now(),
                maximumDate: DateTime(2100),
                locale: const Locale('fr'),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    _selectedDate = value;

                    formattedDate =
                        DateFormat('dd-MM-yyyy').format(_selectedDate);
                    dateContr.text = formattedDate;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(
                    style: BorderStyle.solid, color: kPrimaryColor)),
                elevation: MaterialStateProperty.all(6),
                backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),
                foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              child: const Text("ok"),
            )
          ],
        ),
      );
}
