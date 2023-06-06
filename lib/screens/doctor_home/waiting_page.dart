import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/Welcome/welcome_screen.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

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
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("${Doctor.firstName} ${Doctor.lastName}"),
            actions: [
              IconButton(
                  onPressed: () {
                    FirestoreServices.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const WelcomeScreen();
                    }));
                  },
                  icon: const Icon(IconlyBold.logout))
            ],
          ),
        ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Veuillez patienter jusqu'à ce que votre compte soit approuvé",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(166, 48, 66, 68)),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: size.width * 0.8,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment.center,
                                opacity: 0.5,
                                fit: BoxFit.contain,
                                image:
                                    AssetImage('assets/images/picture.png'))),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
