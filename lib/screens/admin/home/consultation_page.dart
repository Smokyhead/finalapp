// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Appoint extends StatefulWidget {
  const Appoint({super.key});

  @override
  State<StatefulWidget> createState() => _AppointState();
}

class _AppointState extends State<Appoint> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Rendez-vous"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                width: size.width * 0.95,
                child: Card(
                    elevation: 2.5,
                    color: const Color.fromARGB(255, 227, 239, 246),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Rendez-vous:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: kPrimaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "Rendez-vous terminé",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        side: const BorderSide(
                                            color: kPrimaryColor, width: 1.5),
                                        activeColor: kPrimaryColor,
                                        checkColor: kPrimaryLightColor,
                                        value: Appointment.completed,
                                        onChanged: (newVal) {
                                          setState(() {
                                            Appointment.completed =
                                                !Appointment.completed;
                                          });
                                          FirebaseFirestore.instance
                                              .collection('Appointments')
                                              .doc(Appointment.id)
                                              .update({
                                            'completed': Appointment.completed
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 30,
                                thickness: 2,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    Appointment.date,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Divider(
                                height: 30,
                                thickness: 2,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    Appointment.time,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ])))),
            Container(
              margin: const EdgeInsets.all(10),
              width: size.width * 0.95,
              child: Card(
                elevation: 2.5,
                color: const Color.fromARGB(255, 227, 239, 246),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Docteur:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kPrimaryColor),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                  "${Appointment.doctorFirstName} ${Appointment.doctorLastName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21))
                            ],
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                const AssetImage("assets/images/avatar.jpg"),
                            foregroundImage: Appointment.doctorImage.isEmpty
                                ? null
                                : NetworkImage(Appointment.doctorImage),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.call,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                Appointment.doctorPhone,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: 17.5,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () {
                                final Uri url = Uri(
                                    scheme: 'tel',
                                    path: Appointment.doctorPhone);
                                launchUrl(url);
                              },
                              icon: const Icon(
                                Icons.call,
                                size: 17.5,
                              ),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.email,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            Doctor.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.medical_services,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            Doctor.service,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: size.width * 0.95,
              child: Card(
                elevation: 2.5,
                color: const Color.fromARGB(255, 227, 239, 246),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Patient:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kPrimaryColor),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                  "${Appointment.patientFirstName} ${Appointment.patientLastName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21))
                            ],
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                const AssetImage("assets/images/avatar.jpg"),
                            foregroundImage: Appointment.patientImage.isEmpty
                                ? null
                                : NetworkImage(Appointment.patientImage),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.call,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                Appointment.patientPhone,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: 17.5,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () {
                                final Uri url = Uri(
                                    scheme: 'tel',
                                    path: Appointment.patientPhone);
                                launchUrl(url);
                              },
                              icon: const Icon(
                                Icons.call,
                                size: 17.5,
                              ),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.email,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            Patient.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
