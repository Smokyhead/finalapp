// ignore_for_file: avoid_print

import 'dart:async';

import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/auth/Login/Components/reset_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePW extends StatefulWidget {
  const ChangePW({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePW();
}

class _ChangePW extends State<ChangePW> {
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool hidePassword3 = true;
  final TextEditingController oldpwController = TextEditingController();
  final TextEditingController newpwController = TextEditingController();
  final TextEditingController newpwconController = TextEditingController();
  String oldpw = "";
  String newpw = "";
  String newpwcon = "";

  final currentUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  bool _isValidPassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  changePassword(
      String email, String oldpw, String newpw, String newpwConf) async {
    final cred =
        EmailAuthProvider.credential(email: Patient.email, password: oldpw);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpw);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text("Votre mot de passe a était changé avec succés!"),
            );
          });
      setState(() {
        oldpwController.clear();
        newpwController.clear();
        newpwconController.clear();
      });
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }).catchError((e) {
      print(e.toString());
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
              content: const Text("Mot de passe incorrect"),
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
    });
  }

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
            title: const Text("Réinitialisation du mot de passe"),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: const Text(
                    'Réinitialisez votre mot de passe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                TextFieldContainer(
                    child: TextFormField(
                  controller: oldpwController,
                  obscureText: hidePassword1,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword1 = !hidePassword1;
                          });
                        },
                        color: kPrimaryColor),
                    border: InputBorder.none,
                    hintText: "Votre Mot de passe",
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                TextFieldContainer(
                    child: TextFormField(
                  controller: newpwController,
                  obscureText: hidePassword2,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.key,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword2
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword2 = !hidePassword2;
                          });
                        },
                        color: kPrimaryColor),
                    border: InputBorder.none,
                    hintText: "Nouveau mot de passe",
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                TextFieldContainer(
                    child: TextFormField(
                  controller: newpwconController,
                  obscureText: hidePassword3,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.check,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword3
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword3 = !hidePassword3;
                          });
                        },
                        color: kPrimaryColor),
                    border: InputBorder.none,
                    hintText: "Confirmer nouveau mot de passe",
                  ),
                )),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 55,
                  width: 300,
                  child: TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    child: const Text(
                      'Valider',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      if (oldpwController.text.isEmpty ||
                          newpwController.text.isEmpty ||
                          newpwconController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "OOPS!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                content: const Text(
                                    "Veillez remplir les champs vides"),
                                actions: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kPrimaryColor),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
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
                        if (_isValidPassword(newpwController.text) == true) {
                          if (newpwController.text == newpwconController.text) {
                            changePassword(Patient.email, oldpwController.text,
                                newpwController.text, newpwconController.text);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "OOPS!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    content: const Text(
                                        "Veillez confirmer votre mot de passe"),
                                    actions: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kPrimaryColor),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "OOPS!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  content: const Text(
                                      "Le mot de passe doit contenir au minimum:\n8 caractères\nUne lettre majuscule\nUne lettre minuscule\nUn chiffre\nUn symbole"),
                                  actions: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  kPrimaryColor),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
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
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ResetPassword();
                      }));
                    },
                    child: const Text(
                      'Récupérez Mot de passe',
                      style: TextStyle(color: Colors.blueGrey),
                    )),
              ],
            ),
          ),
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
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      height: 60,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
