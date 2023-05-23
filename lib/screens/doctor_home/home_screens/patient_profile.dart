// ignore_for_file: avoid_print

import 'package:finalapp/constants.dart';
import 'package:finalapp/models/observation_model.dart';
import 'package:finalapp/models/users.dart';
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
  TextEditingController cont = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Observation",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      child: typing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.done)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        typing = !typing;
                                      });
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  typing = !typing;
                                });
                              },
                              icon: const Icon(IconlyLight.edit))),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              child: typing
                  ? TextFieldContainer(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: myController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Observation",
                        ),
                      ),
                    )
                  : checkIfNull(),
            ),
            const SizedBox(
              height: 25,
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
          ],
        ),
      ),
    );
  }

  checkIfNull() {
    var size = MediaQuery.of(context).size;
    if (Observation.id != "") {
      return Container(
          width: size.width * 0.8,
          height: 100,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 10)
              ],
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(5),
              border:
                  Border.all(color: const Color.fromARGB(255, 219, 223, 224))),
          child: Text(Observation.observation));
    } else {
      return const Text(
        "Aucune observation à afficher",
        style: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
      );
    }
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
