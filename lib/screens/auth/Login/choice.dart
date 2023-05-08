import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/auth/Doctor_Login/doctor_login_screen.dart';
import 'package:finalapp/screens/auth/Login/login-screen.dart';
import 'package:flutter/material.dart';

class LoginChoicePage extends StatefulWidget {
  const LoginChoicePage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginChoicePage();
}

class _LoginChoicePage extends State<LoginChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.5,
          image: AssetImage('assets/images/Untitled design.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(bottom: 50, top: 100),
            alignment: AlignmentDirectional.center,
            child: const Text(
              "Vous êtes:",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 5,
                  color: kPrimaryColor),
            ),
          ),
          SizedBox(
            height: 120,
            width: 230,
            child: TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(15),
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(30)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DoctorLoginScreen();
                  }));
                },
                child: const Text(
                  "Docteur",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                )),
          ),
          const SizedBox(height: 35),
          SizedBox(
            height: 120,
            width: 230,
            child: TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(15),
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(30)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text(
                  "Patient",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                )),
          ),
          Column(
            children: [
              Container(
                  margin: const EdgeInsetsDirectional.only(top: 40),
                  child: const Text('Avez-vous déja un compte?')),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text(
                  'Connectez-vous ici',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
