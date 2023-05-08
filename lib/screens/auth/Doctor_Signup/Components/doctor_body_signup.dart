// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/auth/Doctor_Login/doctor_login_screen.dart';
import 'package:finalapp/screens/auth/Patient_Signup/Components/background_signup.dart';
import 'package:finalapp/screens/auth/Pic_Selection_doctor/dpic_selection_screen.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> selectedItems = [];

  void _showMultiSelect() async {
    final List<String> items = [
      "chirurgie viscérale",
      "chirurgie générale",
      "chirurgie cardio- vasculaire et thoracique",
      "chirurgie vasculaire périphérique",
      "orthopédie",
      "traumatologie",
      "urologie",
      "oto-rhino-laryngologie",
      "chirurgie maxillo-faciale",
      "ophtalmologie",
      "neurochirurgie",
      "gynécologie obstétrique",
      "médecine et chirurgie dentaire",
      "cardiologie",
      "gastro-entérologie",
      "anesthésie réanimation",
      "pneumo allergologie",
      "néphrologie",
      "endocrinologie",
      "neurologie",
      "psychiatrie",
      "dermatologie",
      "pédiatrie",
      "néonatologie",
      "hématologie",
    ];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(items: items);
        });

    if (results != null) {
      setState(() {
        selectedItems = results;
      });
    }
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfController = TextEditingController();
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool emailValid = true;
  late String mes;
  late String id = "";

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        emailValid = _isValidEmail(emailController.text.trim());
      });
    });
  }

  bool _isValidEmail(String email) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (!emailRegExp.hasMatch(email)) {
      mes = "Email n'est pas valide";
      return false;
    }
    return true;
  }

  bool _isPhoneValid(String phone) {
    String pattern = r'^(9|5|2)\d{7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phone);
  }

  bool _isValidPassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Future<void> formValidation() async {
    if (selectedItems.isNotEmpty) {
      if (_isValidEmail(emailController.text) == true &&
          _isPhoneValid(phoneController.text) == true) {
        if (pwController.text.trim() == pwConfController.text.trim()) {
          if (firstNameController.text.isNotEmpty &&
              lastNameController.text.isNotEmpty &&
              _isValidEmail(emailController.text) == true &&
              _isPhoneValid(phoneController.text) == true &&
              pwController.text.isNotEmpty &&
              pwConfController.text.isNotEmpty) {
            if (_isValidPassword(pwController.text.trim()) == true) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      content: Text(
                        "Compte encours de création...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    );
                  });
              authenticateAndSignUp();
            } else {
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      content: const Text(
                          "Le mot de passe doit contenir au minimum:\n8 caractères\nUne lettre majuscule\nUne lettre minuscule\nUn chiffre\nUn symbole"),
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
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      "OOPS!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    content: const Text("Veillez saisir vos données"),
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
                  content: const Text("Veillez confirmer votre mot de passe"),
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
                content: const Text("Email ou téléphone invalide"),
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
              content: const Text("Veuillez séléctionnez au moins un service."),
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

  void authenticateAndSignUp() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwController.text.trim(),
      );
      final User currentUser = userCredential.user!;
      id = currentUser.uid;
      FirestoreServices.getDoctorById(id);

      await saveDataToFirestore(currentUser);
      Navigator.pop(context);

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const DPicSelectScreen();
      }));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e);
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
                "L'adresse e-mail est déjà utilisée par un autre compte"),
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
    } catch (e) {
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
            content: const Text("Mot de passe invalide"),
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

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("Doctors").doc(currentUser.uid).set({
      "role": "doctor",
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "phone": phoneController.text,
      "services": selectedItems,
      "imageUrl": "",
      "patients": []
    });

    //save data locally
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", currentUser.uid);
    await sharedPreferences.setString("role", "doctor");
    await sharedPreferences.setString(
        "userEmail", currentUser.email.toString());
    await sharedPreferences.setString(
        "firstName", firstNameController.text.trim());
    await sharedPreferences.setString(
        "laststName", lastNameController.text.trim());
    await sharedPreferences.setString("phone", phoneController.text.toString());
    await sharedPreferences.setStringList("services", selectedItems);
    await sharedPreferences.setString("imageUrl", "");
    await sharedPreferences.setStringList("patients", []);
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController dateController = TextEditingController();
    return Background(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            margin: const EdgeInsetsDirectional.only(top: 75),
            child: const Text(
              "Inscrivez vous",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: kPrimaryColor),
            ),
          ),
          TextFieldContainer(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  hintText: "Nom", border: InputBorder.none),
              controller: lastNameController,
            ),
          ),
          TextFieldContainer(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  hintText: "Prénom", border: InputBorder.none),
              controller: firstNameController,
            ),
          ),
          TextFieldContainer(
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "E-mail", border: InputBorder.none),
              controller: emailController,
            ),
          ),
          TextFieldContainer(
              child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "Téléphone", border: InputBorder.none),
            controller: phoneController,
          )),
          TextFieldContainer(
              child: TextField(
            obscureText: hidePassword1,
            decoration: InputDecoration(
              hintText: "Mot de passe",
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword1 ? IconlyLight.hide : IconlyLight.show,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword1 = !hidePassword1;
                    });
                  },
                  color: kPrimaryColor),
            ),
            controller: pwController,
          )),
          TextFieldContainer(
              child: TextField(
            obscureText: hidePassword2,
            decoration: InputDecoration(
              hintText: "Confirmer Mot de passe",
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword2 ? IconlyLight.hide : IconlyLight.show,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword2 = !hidePassword2;
                    });
                  },
                  color: kPrimaryColor),
            ),
            controller: pwConfController,
          )),
          const SizedBox(
            height: 25,
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 5),
            width: 200,
            height: 50,
            child: TextButton(
              onPressed: () {
                _showMultiSelect();
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),
                foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: kPrimaryColor)),
                ),
              ),
              child: const Text("Services", style: TextStyle(fontSize: 20)),
            ),
          ),
          const Divider(
            height: 25,
          ),
          Wrap(
              spacing: 5,
              children: selectedItems
                  .map((e) => Chip(
                        label: Text(e),
                      ))
                  .toList()),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 5),
            width: 310,
            height: 50,
            child: TextButton(
              onPressed: () {
                formValidation();
                UserState.isConnected = true;
                Role.role = "doctor";
                print("id: $id");
                print(Doctor.uid);
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
              child: const Text("INSCRIPTION", style: TextStyle(fontSize: 20)),
            ),
          ),
          Column(
            children: [
              Container(
                  margin: const EdgeInsetsDirectional.only(top: 20),
                  child: const Text('Avez-vous déja un compte?')),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DoctorLoginScreen();
                  }));
                },
                child: const Text(
                  'Connectez-vous ici',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ]),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: 315,
      height: 55,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> selectedItems = [];

  void serviceChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemValue);
      } else {
        selectedItems.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void submit() {
    Navigator.pop(context, selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text(
          "Choisissez vos services:",
          style: TextStyle(color: kPrimaryColor),
        ),
        content: SingleChildScrollView(
            child: ListBody(
                children: widget.items
                    .map((item) => CheckboxListTile(
                        title: Text(item),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedItems.contains(item),
                        onChanged: (isChecked) =>
                            serviceChange(item, isChecked!)))
                    .toList())),
        actions: [
          TextButton(
            onPressed: submit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            child: const Text("Valider"),
          ),
          TextButton(
              onPressed: cancel,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              child: const Text("Annuler"))
        ]);
  }
}
