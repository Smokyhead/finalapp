import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/widgets/appointment.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uuid/uuid.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<StatefulWidget> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final myController = TextEditingController();
  String uuid = "";

  Future submitFeedback() async {
    if (myController.text.isEmpty) {
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
      uuid = const Uuid().v4();
      FirebaseFirestore.instance.collection("Feedbacks").doc(uuid).set({
        "id": uuid,
        "patientId": Patient.uid,
        "patientName": "${Patient.firstName} ${Patient.lastName}",
        "doctorId": Doctor.uid,
        "doctorName": "${Doctor.firstName} ${Doctor.lastName}",
        "feedback": myController.text
      });
      FirebaseFirestore.instance.collection('Doctors').doc(Doctor.uid).update({
        'feedbacks': FieldValue.arrayUnion([uuid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.4,
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
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 90,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Doctor.imageUrl.isEmpty
                        ? null
                        : NetworkImage(Doctor.imageUrl),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    "${Doctor.firstName} ${Doctor.lastName}",
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
                children: [
                  const Icon(
                    IconlyLight.call,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    Doctor.phone,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
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
                    Doctor.email,
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
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      "Services:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Wrap(
                        spacing: 5,
                        children: Doctor.services
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList()),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width - 100,
              height: 0.5,
              color: Colors.black,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Reserver un rendez-vous"),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: 130,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AppointmentPage();
                    }));
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(
                        style: BorderStyle.solid, color: kPrimaryColor)),
                    elevation: MaterialStateProperty.all(6),
                    backgroundColor:
                        MaterialStateProperty.all(kPrimaryLightColor),
                    foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  child: const Text(
                    "Reserver",
                    style: TextStyle(fontSize: 23.5),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: 130,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(
                        style: BorderStyle.solid, color: kPrimaryColor)),
                    elevation: MaterialStateProperty.all(6),
                    backgroundColor:
                        MaterialStateProperty.all(kPrimaryLightColor),
                    foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  child: const Text(
                    "Retour",
                    style: TextStyle(fontSize: 23.5),
                  )),
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Comment vous trouvez ce docteur?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          content: TextFieldContainer(
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: myController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tapez votre réponse ici",
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kPrimaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Annuler")),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kPrimaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                                onPressed: () {
                                  submitFeedback();
                                  Navigator.pop(context);
                                },
                                child: const Text("Valider"))
                          ],
                        );
                      });
                },
                child: const Text(
                  "Ajoutez un feedback",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
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
