// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/Screens/Welcome/Components/background_welc.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/admin.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/admin/home/home_screen.dart';
import 'package:finalapp/screens/auth/Login/Components/reset_password_page.dart';
import 'package:finalapp/screens/auth/Login/choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Connexion extends StatelessWidget {
  const Connexion({super.key});

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
            title: const Text("Admin"),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('assets/images/Untitled design.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: const ConnexionBody(),
        ));
  }
}

class ConnexionBody extends StatefulWidget {
  const ConnexionBody({super.key});

  @override
  State<ConnexionBody> createState() => _ConnexionBodyState();
}

class _ConnexionBodyState extends State<ConnexionBody> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  bool hidePassword = true;
  bool isAdmin = true;
  late String id = "";
  @override
  void initState() {
    super.initState();
  }

  Future<void> formValidation() async {
    if (myController1.text.trim().isNotEmpty &&
        myController2.text.trim().isNotEmpty) {
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
      UserState.isConnected = true;
      Role.role = "admin";
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

  Future<void> getAdminById(String id) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Admin').doc(id).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data['role'] == "admin") {
          isAdmin = true;
          print("this is the DATA: $data");
          Admin.fromMap(data);
          print("DONE!!!");
        }
      } else {
        print('Doctor not found');
        isAdmin = false;
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
      await getAdminById(id);
      if (isAdmin == true) {
        Navigator.pop(context);

        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const AdminHome();
        }));
      } else {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginChoicePage();
        }));
      }
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
            content: const Text("Email ou mot de passe incorrect"),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: const Text(
                "Connectez vous",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: kPrimaryColor),
              ),
            ),
            const SizedBox(height: 50),
            TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "Email",
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
                hintText: "Mot de passe",
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
            const SizedBox(
              height: 50,
            )
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
