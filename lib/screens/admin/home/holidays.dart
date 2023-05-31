import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:uuid/uuid.dart';

class Holidays extends StatefulWidget {
  const Holidays({super.key});

  @override
  State<StatefulWidget> createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String formattedDate = "";
  String uuid = "";
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
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Jours Fériés"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ajouter Jour Férié",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              TextFieldContainer(
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: const Icon(
                          Icons.celebration_rounded,
                          color: kPrimaryColor,
                        )),
                    hintText: "Occasion",
                    border: InputBorder.none,
                  ),
                  controller: name,
                ),
              ),
              const SizedBox(
                height: 3.5,
              ),
              TextFieldContainer(
                child: TextFormField(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                  readOnly: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: kPrimaryColor,
                        )),
                    hintText: "Date",
                    border: InputBorder.none,
                  ),
                  controller: date,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 45,
                  width: 100,
                  child: TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor:
                          MaterialStateProperty.all(kPrimaryLightColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    onPressed: () {
                      if (name.text == "" || formattedDate == "") {
                        showAlert();
                      } else {
                        uuid = const Uuid().v4();
                        FirebaseFirestore.instance
                            .collection('Holidays')
                            .doc(uuid)
                            .set({
                          'id': uuid,
                          'name': name.text.trim(),
                          'date': formattedDate
                        });
                        showDialog(
                            context: (context),
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              );
                            });
                        Timer(const Duration(seconds: 1), () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  content: Text(
                                    "Jour Férié ajouté.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor),
                                  ),
                                );
                              });
                        });

                        Timer(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          setState(() {
                            name.clear();
                            date.clear();
                          });
                        });
                      }
                    },
                    child: const Text(
                      "Valider",
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
              const Divider(
                height: 25,
              ),
              const Text(
                "Jours Fériés",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Holidays')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                  final docs = snapshots.data?.docs;
                  if (docs == null || docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Pas de jours fériés à afficher",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 176, 127, 127)),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return ListBody(
                      children: snapshots.data!.docs.map((item) {
                        var data = item.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                data['name'],
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5),
                              ),
                              subtitle: Text(
                                data['date'],
                                style:
                                    const TextStyle(fontSize: 17, height: 1.5),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black38,
                            )
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget bottomSheet() => Container(
        height: 350,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Sélectionner la date du jour férié",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              child: ScrollDatePicker(
                options: const DatePickerOptions(isLoop: false),
                selectedDate: _selectedDate,
                minimumDate: DateTime.now(),
                maximumDate: DateTime(2100),
                locale: const Locale('fr'),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    _selectedDate = value;
                    formattedDate =
                        DateFormat('dd-MM-yyyy').format(_selectedDate);
                    date.text = formattedDate;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDate;
                  formattedDate;
                });
                Navigator.pop(context);
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(
                    style: BorderStyle.solid, color: kPrimaryColor)),
                elevation: MaterialStateProperty.all(6),
                backgroundColor: MaterialStateProperty.all(kPrimaryLightColor),
                foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              child: const Text("ok"),
            )
          ],
        ),
      );
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
      padding: const EdgeInsets.only(left: 10),
      width: size.width * 0.7,
      height: 45,
      decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPrimaryColor)),
      child: child,
    );
  }
}
