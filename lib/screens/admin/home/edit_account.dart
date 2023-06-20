import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/admin.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<StatefulWidget> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  TextEditingController email = TextEditingController();
  TextEditingController myController = TextEditingController();
  bool hidePassword = true;
  String errorAuth = "";

  @override
  void initState() {
    email.clear();
    myController.clear();
    super.initState();
  }

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
        EmailAuthProvider.credential(email: Admin.email, password: oldpw);

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
            content: const Text("Veillez saisir vos données"),
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

  void updateEmail(String oldEmail, String newEmail, String password) async {
    try {
      showDialog(
          context: (context),
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          });
      throw FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(
              EmailAuthProvider.credential(email: oldEmail, password: password))
          .then((value) {
        changeEmail(newEmail);
        setState(() {
          email.clear();
          myController.clear();
        });
      });
    } catch (errorAuth) {
      print("this is the error!!!! ${errorAuth.toString()}");
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
              content: const Text('Mot de passe incorrect'),
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

  bool isEmailValid(String email) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return regExp.hasMatch(email);
  }

  void changeEmail(String email) async {
    if (isEmailValid(email)) {
      FirebaseAuth.instance.currentUser!.updateEmail(email);
      FirebaseFirestore.instance
          .collection('Admin')
          .doc(Admin.id)
          .update({'userEmail': email});
      FirestoreServices.getAdminById(Admin.id);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text("Votre email a était changé avec succés!"),
            );
          });
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
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
              content: const Text('Veuillez saisir un email valide'),
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
          elevation: 10,
          backgroundColor: kPrimaryColor,
          title: TextButton(
            onPressed: () {
              FirestoreServices.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const EditAccount();
              }));
            },
            child: const Text(
              "Gérer compte",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: () {
                  FirestoreServices.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WelcomeScreen();
                  }));
                },
                icon: const Icon(IconlyBold.logout))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Modifier E-mail",
                style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              TextFieldContainer(
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "Nouveau Email",
                      border: InputBorder.none,
                      icon: Icon(
                        IconlyLight.message,
                        color: kPrimaryColor,
                      )),
                ),
              ),
              const SizedBox(height: 5),
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
                        hidePassword ? Icons.visibility_off : Icons.visibility,
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
                controller: myController,
              )),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsetsDirectional.only(top: 5),
                width: 90,
                height: 50,
                child: TextButton(
                    onPressed: () {
                      if (email.text.isEmpty || myController.text.isEmpty) {
                        showAlert();
                      } else {
                        updateEmail(
                            Admin.email,
                            email.text.trim().toLowerCase(),
                            myController.text.trim());
                      }
                      print("errorrrrr: $errorAuth");
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
                    child:
                        const Text("Valider", style: TextStyle(fontSize: 17))),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 2,
              ),
              // password************************************************************
              const SizedBox(height: 20),
              const Text(
                "Modifier Mot de passe",
                style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
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
                        hidePassword1 ? Icons.visibility_off : Icons.visibility,
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
                        hidePassword2 ? Icons.visibility_off : Icons.visibility,
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
                        hidePassword3 ? Icons.visibility_off : Icons.visibility,
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
                height: 15,
              ),
              SizedBox(
                height: 55,
                width: 100,
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
                                    fontWeight: FontWeight.bold, fontSize: 30),
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
                          changePassword(Admin.email, oldpwController.text,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
            ],
          ),
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
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
