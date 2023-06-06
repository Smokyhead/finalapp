// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/Welcome/Components/choice.dart';
import 'package:finalapp/screens/auth/Doctor_Login/doctor_login_screen.dart';
import 'package:finalapp/screens/auth/Login/Components/background_login.dart';
import 'package:finalapp/screens/auth/Login/Components/reset_password_page.dart';
import 'package:finalapp/screens/patient_home/patient_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool isPatient = false;
  late String id = "";
  final String role = "patient";
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  bool hidePassword = true;
  late String userID;

  @override
  void initState() {
    super.initState();
  }

  Future<void> formValidation() async {
    if (myController1.text.isNotEmpty && myController2.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text(
                "Connection en cours...",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            );
          });
      signIn();
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
              content: const Text("Veuillez saisir vos données"),
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

  Future<void> getPatientById(String patientId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        print(data['role']);
        if (data['role'] == "patient") {
          isPatient = true;
          print("this is the DATA: $data");
          Patient.fromMap(data);
          print("DONE!!!");
        } else {
          isPatient = false;
          print("You are not a patient!!");
        }
      } else {
        print('Patient not found');
      }
    } catch (e) {
      print(e.toString());
      print("something went wrong!!");
    }
  }

  void signIn() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: myController1.text.trim(),
        password: myController2.text.trim(),
      );
      final User currentUser = userCredential.user!;
      id = currentUser.uid;
      await getPatientById(id);
      if (isPatient == true) {
        print(Patient.firstName);
        Navigator.pop(context);
        UserState.isConnected = true;
        Role.role = "patient";
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const PatientHome();
        }));
      } else {
        Navigator.pop(context);
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
                "Cette page est pour les Patients!!",
                style: TextStyle(fontSize: 17.5),
              ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const DoctorLoginScreen();
                      }));
                    },
                    child:
                        const Text("Connectez-vous en tant que Docteur ICI")),
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
                    child: const Text("Annuler"))
              ],
            );
          },
        );
      }

      //send user to homePage
      // Route newRoute = MaterialPageRoute(builder: (c) => const Scaffold());
      // Navigator.pushReplacement(context, newRoute);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Navigator.pop(context);
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
            content: const Text("Email ou mot de passe invalide"),
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: const Text(
                "Connectez vous",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: kPrimaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "en tant que Patient",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor),
              ),
            ),
            const SizedBox(height: 50),
            TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "Votre Email",
                    border: InputBorder.none,
                    icon: Icon(
                      IconlyLight.profile,
                      color: kPrimaryColor,
                    )),
                controller: myController1,
              ),
            ),
            const SizedBox(height: 10),
            TextFieldContainer(
                child: TextFormField(
              obscureText: hidePassword,
              decoration: InputDecoration(
                icon: const Icon(
                  IconlyLight.lock,
                  color: kPrimaryColor,
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? IconlyLight.hide : IconlyLight.show,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: kPrimaryColor),
                border: InputBorder.none,
                hintText: "Votre Mot de passe",
              ),
              controller: myController2,
            )),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 5),
              width: 310,
              height: 60,
              child: TextButton(
                  onPressed: () {
                    formValidation();
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("CONNEXION", style: TextStyle(fontSize: 20)),
                      SizedBox(width: 130),
                      Icon(IconlyBold.login)
                    ],
                  )),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ResetPassword();
                  }));
                },
                child: const Text(
                  'Récupérez Mot de passe',
                  style: TextStyle(color: Colors.blueGrey),
                )),
            const SizedBox(height: 50),
            Column(
              children: [
                Container(
                    margin: const EdgeInsetsDirectional.only(top: 20),
                    child: const Text('Vous n\'avez pas un compte?')),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ChoicePage();
                    }));
                  },
                  child: const Text(
                    'Inscrivez-vous ici',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
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
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
