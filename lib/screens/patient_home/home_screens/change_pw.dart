import 'package:finalapp/constants.dart';
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

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                const SizedBox(height: 100),
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
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 100,
                      child: TextButton(
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
                        child: const Text(
                          'Valider',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          
                        },
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 100,
                      child: TextButton(
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
                        child: const Text(
                          'Fermer',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )));
    
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
