import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/provider/dark_theme_prov.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/screens/patient_home/home_screens/app_feedback.dart';
import 'package:finalapp/screens/patient_home/home_screens/change_pw.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool hidePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: const AssetImage("assets/images/avatar.jpg"),
                foregroundImage: Patient.imageUrl.isEmpty
                    ? null
                    : NetworkImage(Patient.imageUrl),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 200,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ChangePW();
                  }));
                },
                style: ButtonStyle(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AppFeedback();
                  }));
                },
                style: ButtonStyle(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }));
                },
                style: ButtonStyle(
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
            SizedBox(
              width: 500,
              height: 200,
              child: SwitchListTile(
                title: const Text("Thème"),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onChanged: (bool value) {
                  themeState.setDarkTheme = value;
                },
                value: themeState.getDarkTheme,
              ),
            ),
          ])),
    );
  }
}
