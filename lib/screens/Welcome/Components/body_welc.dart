import 'package:finalapp/constants.dart';
import 'package:finalapp/provider/user_prov.dart';
import 'package:finalapp/screens/Welcome/Components/choice.dart';
import 'package:finalapp/screens/auth/Login/choice.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'background_welc.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Bienvenue",
                textScaleFactor: 4,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 5,
                    color: kPrimaryColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                "Connectez-vous",
                style: TextStyle(
                    height: 2, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 255,
                height: 50,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginChoicePage();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "SE CONNECTER",
                          style: TextStyle(
                              fontSize: 18.5, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 25),
                        Icon(IconlyLight.login)
                      ],
                    )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 255,
                height: 50,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ChoicePage();
                      }));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "S'INSCRIRE",
                          style: TextStyle(
                              fontSize: 18.5, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 67.5),
                        Icon(IconlyLight.add_user)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
