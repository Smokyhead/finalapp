import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';

class AppFeedback extends StatefulWidget {
  const AppFeedback({super.key});

  @override
  State<StatefulWidget> createState() => _AppFeedback();
}

class _AppFeedback extends State<AppFeedback> {

    final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Aimez-vous l\'application?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const SizedBox(
                  width: 300,
                  child: Text(
                    'Donnez votre avis pour nous aider à ameliorer l\'application :',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const TextFieldContainer(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tapez votre réponse ici",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                    height: 55,
                    width: 150,
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        child: const Text(
                          'Valider',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {})),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 55,
                    width: 150,
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }))
              ]),
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
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      height: 150,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
