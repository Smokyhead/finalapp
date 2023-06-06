// ignore_for_file: library_prefixes, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/screens/doctor_home/home_screens/app_feedback.dart';
import 'package:finalapp/screens/doctor_home/home_screens/change_pw.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String imageUrl = "";
  TextEditingController? firstName = TextEditingController();
  TextEditingController? lastName = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? phone = TextEditingController();
  bool fNtyping = false;
  bool lNtyping = false;
  bool etyping = false;
  bool ptyping = false;
  bool hidePassword = true;
  TextEditingController? myController = TextEditingController();
  String errorAuth = "";

  @override
  void setState(VoidCallback fn) {
    Doctor.imageUrl;
    super.setState(fn);
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

  bool isPhoneValid(String phone) {
    RegExp regExp = RegExp(r'^(9|5|2)\d{7}$');
    return regExp.hasMatch(phone);
  }

  bool isEmailValid(String email) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return regExp.hasMatch(email);
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
          etyping = !etyping;
          email!.clear();
          myController!.clear();
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

  void changeEmail(String email) async {
    if (isEmailValid(email)) {
      FirebaseAuth.instance.currentUser!.updateEmail(email);
      FirebaseFirestore.instance
          .collection('Doctors')
          .doc(Doctor.uid)
          .update({'userEmail': email});
      FirestoreServices.getDoctorById(Doctor.uid);
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
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Compte"),
          actions: [
            IconButton(
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
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('assets/images/Untitled design.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: Stack(children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          const AssetImage("assets/images/avatar.jpg"),
                      foregroundImage: Doctor.imageUrl.isEmpty
                          ? null
                          : NetworkImage(Doctor.imageUrl),
                    ),
                    const Positioned(
                        bottom: 1,
                        right: 1,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                        )),
                    Positioned(
                        bottom: 15,
                        right: 15,
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()),
                              );
                            },
                            icon: const Icon(
                              IconlyBold.camera,
                              size: 30,
                            )))
                  ]),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {
                    deletePhoto();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Supprimez votre photo",
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: const Icon(IconlyBold.delete))
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Prénom:',
                            style: TextStyle(fontSize: 17.5),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: lNtyping
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      height: 35,
                                      width: 130,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                        ),
                                        cursorColor: Colors.black,
                                        controller: lastName,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                    )
                                  : Text(
                                      Doctor.lastName,
                                      style: const TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ],
                      ),
                      Container(
                          child: lNtyping
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (lastName!.text.isEmpty) {
                                            showAlert();
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('Doctors')
                                                .doc(Doctor.uid)
                                                .update({
                                              'lastName': lastName!.text
                                            });
                                            FirestoreServices.getDoctorById(
                                                Doctor.uid);
                                            setState(() {
                                              Doctor.lastName = lastName!.text;
                                              lNtyping = !lNtyping;
                                              lastName!.clear();
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.done)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            lNtyping = !lNtyping;
                                            lastName!.text = "";
                                          });
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      lNtyping = !lNtyping;
                                    });
                                  },
                                  icon: const Icon(IconlyLight.edit))),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Nom:',
                            style: TextStyle(fontSize: 17.5),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: fNtyping
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      height: 35,
                                      width: 130,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                        ),
                                        cursorColor: Colors.black,
                                        controller: firstName,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                    )
                                  : Text(
                                      Doctor.firstName,
                                      style: const TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ],
                      ),
                      Container(
                          child: fNtyping
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (firstName!.text.isEmpty) {
                                            showAlert();
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('Doctors')
                                                .doc(Doctor.uid)
                                                .update({
                                              'firstName': firstName!.text
                                            });
                                            FirestoreServices.getDoctorById(
                                                Doctor.uid);
                                            setState(() {
                                              Doctor.firstName =
                                                  firstName!.text;
                                              fNtyping = !fNtyping;
                                              firstName!.clear();
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.done)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            fNtyping = !fNtyping;
                                            firstName!.text = "";
                                          });
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      fNtyping = !fNtyping;
                                    });
                                  },
                                  icon: const Icon(IconlyLight.edit))),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Email:',
                              style: TextStyle(fontSize: 17.5),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                Doctor.email,
                                style: const TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                etyping = !etyping;
                              });
                            },
                            icon: etyping
                                ? const Icon(Icons.close)
                                : const Icon(IconlyLight.edit))
                      ]),
                ),
                Container(
                    child: etyping
                        ? Column(
                            children: [
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
                                        hidePassword
                                            ? IconlyLight.hide
                                            : IconlyLight.show,
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
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 5),
                                width: 90,
                                height: 50,
                                child: TextButton(
                                    onPressed: () {
                                      if (email!.text.isEmpty ||
                                          myController!.text.isEmpty) {
                                        showAlert();
                                      } else {
                                        updateEmail(
                                            Doctor.email,
                                            email!.text.trim().toLowerCase(),
                                            myController!.text.trim());
                                      }
                                      print("errorrrrr: $errorAuth");
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10),
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
                                    child: const Text("Valider",
                                        style: TextStyle(fontSize: 17))),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          )
                        : const SizedBox.shrink()),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Téléphone:',
                            style: TextStyle(fontSize: 17.5),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: ptyping
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      height: 35,
                                      width: 130,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor)),
                                        ),
                                        cursorColor: Colors.black,
                                        controller: phone,
                                        keyboardType: TextInputType.number,
                                      ),
                                    )
                                  : Text(
                                      Doctor.phone,
                                      style: const TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ],
                      ),
                      Container(
                          child: ptyping
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (phone!.text.isEmpty) {
                                            showAlert();
                                          } else {
                                            if (isPhoneValid(phone!.text) ==
                                                true) {
                                              FirebaseFirestore.instance
                                                  .collection('Doctors')
                                                  .doc(Doctor.uid)
                                                  .update(
                                                      {'phone': phone!.text});
                                              FirestoreServices.getDoctorById(
                                                  Doctor.uid);
                                              setState(() {
                                                Doctor.phone = phone!.text;
                                                ptyping = !ptyping;
                                                phone!.clear();
                                              });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "OOPS!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30),
                                                      ),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      content: const Text(
                                                          "Numéro invalide"),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          kPrimaryColor),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30)),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "OK"))
                                                      ],
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.done)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            ptyping = !ptyping;
                                            phone!.text = "";
                                          });
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ptyping = !ptyping;
                                    });
                                  },
                                  icon: const Icon(IconlyLight.edit))),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Service:',
                        style: TextStyle(fontSize: 17.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Doctor.service,
                        style: const TextStyle(fontSize: 17.5),
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: kPrimaryColor,
                  indent: 20,
                  endIndent: 20,
                  height: 15,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ChangePW();
                      }));
                    },
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
                      "Modifier Mot de passe",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AppFeedback();
                      }));
                    },
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
                      "Ajouter Feedback",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      FirestoreServices.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const WelcomeScreen();
                      }));
                    },
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
                      "Déconnecter",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ])),
        ),
      ),
    );
  }

  void deletePhoto() {
    if (Doctor.imageUrl == "") {
      showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              title: const Text(
                "OOPS!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: const Text("Vous n'avez aucune photo"),
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
      showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: const Text(
                "Vous êtes sûr de supprimer la photo?",
                style: TextStyle(fontSize: 17),
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: (context),
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            );
                          });
                      FirebaseFirestore.instance
                          .collection("Doctors")
                          .doc(Doctor.uid)
                          .update({"imageUrl": ""});
                      FirestoreServices.getDoctorById(Doctor.uid);
                      checkDeletion();
                      Navigator.pop(context);
                    },
                    child: const Text("Supprimer")),
                TextButton(
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
                    child: const Text("Annuler")),
              ],
            );
          });
    }
  }

  void uploadImage() async {
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        });
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("Doctors")
        .child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(_imageFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      imageUrl = url;
      Doctor.imageUrl = imageUrl;
    });
    FirebaseFirestore.instance
        .collection("Doctors")
        .doc(Doctor.uid)
        .update({"imageUrl": imageUrl});
    FirestoreServices.getDoctorById(Doctor.uid);
    checkUrl(imageUrl);
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Sélectionner votre photo",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    icon: const Icon(IconlyBold.camera),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    label: const Text("Camera"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    icon: const Icon(IconlyBold.image),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    label: const Text("Gallerie"),
                  ),
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    _imageFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile;
    });
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
            title: const Text(
              "Voulez vous séléctionner cette photo?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: CircleAvatar(
              radius: 100,
              backgroundImage: const AssetImage("assets/images/avatar.jpg"),
              foregroundImage:
                  _imageFile == null ? null : FileImage(File(_imageFile!.path)),
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
                    uploadImage();
                  },
                  child: const Text("OK")),
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
        });
  }

  void checkUrl(String url) {
    Navigator.pop(context);

    if (Doctor.imageUrl != url) {
      Navigator.pop(context);

      Timer(const Duration(seconds: 4), () {
        checkUrl(url);
      });
    } else {
      setState(() {
        Doctor.imageUrl;
      });
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  void checkDeletion() {
    if (Doctor.imageUrl != "") {
      Timer(const Duration(seconds: 4), () {
        checkDeletion();
      });
    } else {
      setState(() {
        Doctor.imageUrl;
      });
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
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
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.75,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
