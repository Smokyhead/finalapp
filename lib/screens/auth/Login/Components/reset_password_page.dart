// ignore_for_file: avoid_print

import 'package:finalapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  String emailBody = "Email sent";
  String emailSub = "Réinisialisation de mot de passe";
  String mes = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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

  Future _verifyEmail() async {
    if (_isValidEmail(emailController.text.trim()) == true) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                content: const Text(
                    "Email envoyé!\nvérifier votre boîte de réception"),
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
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                    const Text("un problème est survenu\nVeuillez réessayer"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          title: const Text("Mot de passe"),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Untitled design.jpg'),
              fit: BoxFit.cover,
              opacity: 0.5),
        ),
        child: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 100),
                      child: const Text(
                        "Récuperer votre mot de passe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: kPrimaryColor),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(right: 5, left: 5, bottom: 25),
                      child: const Text(
                        "Veuillez saisir votre adresse email",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextFieldContainer(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                        controller: emailController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(top: 50),
                      width: 150,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          _verifyEmail();
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        child: const Text("Valider",
                            style: TextStyle(fontSize: 19)),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
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
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
